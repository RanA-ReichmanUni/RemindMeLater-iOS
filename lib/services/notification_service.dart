import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/database_helper.dart';
import '../models/reminder.dart';
import '../models/timeframe.dart';
import 'settings_service.dart';

// Top-level or static background action handler
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final String? payload = notificationResponse.payload;
  if (payload == null) return;
  final int? reminderId = int.tryParse(payload);
  if (reminderId == null) return;

  // The background isolate is a separate Dart environment — we must initialize
  // the plugin here before using cancel/schedule.
  final plugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  await plugin.initialize(
    const InitializationSettings(android: initSettingsAndroid),
  );

  final db = DatabaseHelper.instance;
  final settings = SettingsService.instance;

  if (notificationResponse.actionId == 'action_done') {
    await db.updateReminderStatus(reminderId, ReminderStatus.done);
    await plugin.cancel(reminderId);
  } else if (notificationResponse.actionId == 'action_snooze') {
    final reminder = await db.getReminderById(reminderId);
    if (reminder != null) {
      final comfortStart = await settings.getComfortStart();
      final comfortEnd = await settings.getComfortEnd();

      // Snooze = Later Today
      final newTime = computeRandomTime(Timeframe.laterToday, comfortStart, comfortEnd);
      final updated = reminder.copyWith(
        timeframe: Timeframe.laterToday,
        scheduledAt: newTime,
        status: ReminderStatus.pending,
      );

      await db.updateReminder(updated);
      await plugin.cancel(reminderId); // Dismiss the active notification

      // Schedule the snoozed reminder directly (avoids uninitialized singleton)
      final fireTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, newTime);
      await plugin.zonedSchedule(
        updated.id!,
        'Reminder 🔔',
        updated.text,
        fireTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders_channel_v2',
            'Reminders',
            channelDescription: 'Dump & Forget Reminders',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('soft_arrival_3sec'),
            fullScreenIntent: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: updated.id.toString(),
      );
    }
  }
}


class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Controller for foreground alarm events
  final StreamController<Reminder> _alarmStreamController =
      StreamController<Reminder>.broadcast();

  // Controller for background actions (Done/Snooze) to tell UI to reload
  final StreamController<String> _actionStreamController =
      StreamController<String>.broadcast();

  Stream<Reminder> get alarmStream => _alarmStreamController.stream;
  Stream<String> get actionStream => _actionStreamController.stream;

  Reminder? pendingLaunchAlarm;

  void consumePendingLaunchAlarm() {
    if (pendingLaunchAlarm != null) {
      _alarmStreamController.add(pendingLaunchAlarm!);
      pendingLaunchAlarm = null;
    }
  }

  NotificationService._init();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timeZoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('[NotificationService] Timezone set successfully to: $timeZoneName');
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      debugPrint('[NotificationService] Timezone initialization failed, using UTC: $e');
    }

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Settings
    final List<DarwinNotificationCategory> darwinNotificationCategories = [
      DarwinNotificationCategory(
        'reminder_category',
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Check if app was launched from a notification
    final launchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails != null && launchDetails.didNotificationLaunchApp && launchDetails.notificationResponse != null) {
      debugPrint('[NotificationService] App launched from notification payload');
      await _handleNotificationResponse(launchDetails.notificationResponse!);
    }

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    // Explicitly request permissions for iOS/macOS
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        final bool? granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        debugPrint('[NotificationService] iOS/Darwin permissions requested. Result: $granted');
      } catch (e) {
        debugPrint('[NotificationService] Error requesting iOS/Darwin notification permissions: $e');
      }
    }
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    if (reminder.id == null) return;

    try {
      final scheduledDate = tz.TZDateTime.fromMillisecondsSinceEpoch(
        tz.local,
        reminder.scheduledAt,
      );

      // If scheduled time has already passed, fire in 5 seconds to avoid silent loss
      final now = tz.TZDateTime.now(tz.local);
      final fireTime = scheduledDate.isBefore(now)
          ? now.add(const Duration(seconds: 5))
          : scheduledDate;

      debugPrint('[NotificationService] Scheduling notification ID: ${reminder.id}');
      debugPrint('[NotificationService] tz.local: ${tz.local.name}');
      debugPrint('[NotificationService] Now is: $now');
      debugPrint('[NotificationService] Scheduled Date: $scheduledDate');
      debugPrint('[NotificationService] Fire time (computed): $fireTime');

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'reminders_channel_v2',
        'Reminders',
        channelDescription: 'Dump & Forget Reminders',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        sound: RawResourceAndroidNotificationSound('soft_arrival_3sec'),
        fullScreenIntent: true,
      );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        categoryIdentifier: 'reminder_category',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
        sound: 'Soft_Arrival_3Sec.wav',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.id!,
        'Reminder 🔔',
        reminder.text,
        fireTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: reminder.id.toString(),
      );
      debugPrint('[NotificationService] Successfully scheduled notification ID ${reminder.id} at $fireTime');
    } catch (e, stackTrace) {
      debugPrint('[NotificationService] ERROR scheduling notification ID ${reminder.id}: $e');
      debugPrint('[NotificationService] StackTrace: $stackTrace');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint('[NotificationService] ERROR cancelling notification $id: $e');
    }
  }

  Future<void> _handleNotificationResponse(NotificationResponse response) async {
    final String? payload = response.payload;
    debugPrint('[NotificationService] _handleNotificationResponse payload: $payload, actionId: ${response.actionId}');
    if (payload == null) return;
    final int? reminderId = int.tryParse(payload);
    if (reminderId == null) return;

    // If the user selects an action
    if (response.actionId == 'action_done') {
      await DatabaseHelper.instance.updateReminderStatus(reminderId, ReminderStatus.done);
      await flutterLocalNotificationsPlugin.cancel(reminderId);
      if (_actionStreamController.hasListener) _actionStreamController.add('reload');
    } else if (response.actionId == 'action_snooze') {
      final db = DatabaseHelper.instance;
      final settings = SettingsService.instance;
      final reminder = await db.getReminderById(reminderId);
      if (reminder != null) {
        final comfortStart = await settings.getComfortStart();
        final comfortEnd = await settings.getComfortEnd();
        final newTime = computeRandomTime(Timeframe.laterToday, comfortStart, comfortEnd);
        final updated = reminder.copyWith(
          timeframe: Timeframe.laterToday,
          scheduledAt: newTime,
          status: ReminderStatus.pending,
        );
        await db.updateReminder(updated);
        await flutterLocalNotificationsPlugin.cancel(reminderId); // Clear active notification
        await scheduleNotification(updated);
        if (_actionStreamController.hasListener) _actionStreamController.add('reload');
      }
    } else {
      // Normal click — trigger app alarm screen if reminder is pending
      final db = DatabaseHelper.instance;
      final reminder = await db.getReminderById(reminderId);
      if (reminder != null && reminder.status == ReminderStatus.pending) {
        if (_alarmStreamController.hasListener) {
          _alarmStreamController.add(reminder);
        } else {
          pendingLaunchAlarm = reminder;
        }
      }
    }
  }
}

int computeRandomTime(
  Timeframe timeframe,
  int comfortStart,
  int comfortEnd, {
  bool ignoreComfortHours = false,
}) {
  final random = Random();
  final now = DateTime.now();

  if (timeframe == Timeframe.laterToday) {
    final int nowMin = now.hour * 60 + now.minute;
    final bool nightShift = comfortEnd <= comfortStart;

    DateTime fireTime;

    if (ignoreComfortHours) {
      final int toMidnight = 24 * 60 - nowMin;
      if (!nightShift && toMidnight >= 30) {
        final int floor = nowMin + 30;
        final int ceil = min(nowMin + 240, 23 * 60 + 59);
        final int fire = floor < ceil ? floor + random.nextInt(ceil - floor) : floor;
        fireTime = DateTime(now.year, now.month, now.day, fire ~/ 60, fire % 60);
      } else {
        fireTime = now.add(Duration(minutes: 30 + random.nextInt(30)));
      }
    } else if (!nightShift) {
      // Normal daytime window
      final int startMin = max(nowMin + 5, comfortStart * 60);
      final int endMin = comfortEnd * 60;
      if (startMin + 30 >= endMin) {
        // Shift to tomorrow
        final tomorrow = now.add(const Duration(days: 1));
        final int r = comfortStart * 60 + random.nextInt((comfortEnd - comfortStart) * 60);
        fireTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, r ~/ 60, r % 60);
      } else {
        final int r = startMin + random.nextInt(endMin - startMin);
        fireTime = DateTime(now.year, now.month, now.day, r ~/ 60, r % 60);
      }
    } else {
      // Night shift window
      final bool inWindow = nowMin >= comfortStart * 60 || nowMin < comfortEnd * 60;
      final int windowLen = (24 - comfortStart) * 60 + comfortEnd * 60;
      final int nowLinear = nowMin >= comfortStart * 60
          ? nowMin - comfortStart * 60
          : (24 - comfortStart) * 60 + nowMin;
      final int floorLinear = nowLinear + 5;

      if (!inWindow || floorLinear + 30 >= windowLen) {
        DateTime targetDay = now;
        if (comfortStart * 60 <= nowMin) {
          targetDay = now.add(const Duration(days: 1));
        }
        fireTime = DateTime(
          targetDay.year,
          targetDay.month,
          targetDay.day,
          comfortStart,
          random.nextInt(60),
        );
      } else {
        final int r = floorLinear + random.nextInt(windowLen - floorLinear);
        final int absMin = (comfortStart * 60 + r) % (24 * 60);
        DateTime targetDay = now;
        if (absMin < nowMin) {
          targetDay = now.add(const Duration(days: 1));
        }
        fireTime = DateTime(
          targetDay.year,
          targetDay.month,
          targetDay.day,
          absMin ~/ 60,
          absMin % 60,
        );
      }
    }

    return DateTime(
      fireTime.year,
      fireTime.month,
      fireTime.day,
      fireTime.hour,
      fireTime.minute,
    ).millisecondsSinceEpoch;
  } else {
    // Other timeframes
    final int minDays = timeframe.minDays;
    final int maxDays = timeframe.maxDays;
    final int daysToAdd = minDays + random.nextInt(maxDays - minDays + 1);

    final targetDate = now.add(Duration(days: daysToAdd));
    final bool nightShift = comfortEnd <= comfortStart;

    int randomHour;
    if (!nightShift) {
      randomHour = comfortStart + random.nextInt(comfortEnd - comfortStart);
    } else {
      randomHour = (comfortStart + random.nextInt((24 - comfortStart) + comfortEnd)) % 24;
    }
    final int randomMinute = random.nextInt(60);

    return DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      randomHour,
      randomMinute,
    ).millisecondsSinceEpoch;
  }
}
