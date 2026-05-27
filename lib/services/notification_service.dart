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
  
  final String? payload = notificationResponse.payload;
  if (payload == null) return;
  final int? reminderId = int.tryParse(payload);
  if (reminderId == null) return;

  final db = DatabaseHelper.instance;
  final settings = SettingsService.instance;

  if (notificationResponse.actionId == 'action_done') {
    await db.updateReminderStatus(reminderId, ReminderStatus.done);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(reminderId);
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
      await NotificationService.instance.scheduleNotification(updated);
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

  Stream<Reminder> get alarmStream => _alarmStreamController.stream;

  NotificationService._init();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Settings
    final List<DarwinNotificationCategory> darwinNotificationCategories = [
      DarwinNotificationCategory(
        'reminder_category',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'action_done',
            '✓ Done',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'action_snooze',
            '💤 Snooze (Later today)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String? payload = response.payload;
        if (payload == null) return;
        final int? reminderId = int.tryParse(payload);
        if (reminderId == null) return;

        // If the user selects an action
        if (response.actionId == 'action_done') {
          await DatabaseHelper.instance.updateReminderStatus(reminderId, ReminderStatus.done);
          await flutterLocalNotificationsPlugin.cancel(reminderId);
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
            await scheduleNotification(updated);
          }
        } else {
          // Normal click — trigger app alarm screen if reminder is pending
          final db = DatabaseHelper.instance;
          final reminder = await db.getReminderById(reminderId);
          if (reminder != null && reminder.status == ReminderStatus.pending) {
            _alarmStreamController.add(reminder);
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    if (reminder.id == null) return;

    final scheduledDate = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.local,
      reminder.scheduledAt,
    );

    // If scheduled time has already passed, fire in 5 seconds to avoid silent loss
    final now = tz.TZDateTime.now(tz.local);
    final fireTime = scheduledDate.isBefore(now)
        ? now.add(const Duration(seconds: 5))
        : scheduledDate;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Dump & Forget Reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('action_done', '✓ Done'),
        AndroidNotificationAction('action_snooze', '💤 Snooze'),
      ],
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: 'reminder_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
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
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
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
