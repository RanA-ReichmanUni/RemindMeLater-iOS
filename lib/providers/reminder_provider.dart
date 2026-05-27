import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/reminder.dart';
import '../models/timeframe.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';

class ReminderProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SettingsService _settings = SettingsService.instance;
  final NotificationService _notifications = NotificationService.instance;

  List<Reminder> _reminders = [];
  int _comfortStart = 9;
  int _comfortEnd = 21;
  bool _hasOnboarded = false;
  bool _termsAccepted = false;
  bool _backgroundAnimationsEnabled = true;

  // Getters
  List<Reminder> get reminders => _reminders;
  int get comfortStart => _comfortStart;
  int get comfortEnd => _comfortEnd;
  bool get hasOnboarded => _hasOnboarded;
  bool get termsAccepted => _termsAccepted;
  bool get backgroundAnimationsEnabled => _backgroundAnimationsEnabled;

  ReminderProvider() {
    _init();
  }

  Future<void> _init() async {
    await refreshSettings();
    await refreshReminders();
  }

  Future<void> refreshSettings() async {
    _comfortStart = await _settings.getComfortStart();
    _comfortEnd = await _settings.getComfortEnd();
    _hasOnboarded = await _settings.getHasOnboarded();
    _termsAccepted = await _settings.getTermsAccepted();
    _backgroundAnimationsEnabled = await _settings.getBackgroundAnimationsEnabled();
    notifyListeners();
  }

  Future<void> refreshReminders() async {
    _reminders = await _db.getActiveReminders();
    notifyListeners();
  }

  Future<void> addReminder(String text, Timeframe timeframe, {bool ignoreComfortHours = false}) async {
    final scheduledAt = computeRandomTime(
      timeframe,
      _comfortStart,
      _comfortEnd,
      ignoreComfortHours: ignoreComfortHours,
    );
    final reminder = Reminder(
      text: text.trim(),
      timeframe: timeframe,
      scheduledAt: scheduledAt,
    );
    final id = await _db.insertReminder(reminder);
    final savedReminder = reminder.copyWith(id: id);
    
    await _notifications.scheduleNotification(savedReminder);
    await refreshReminders();
  }

  Future<void> deleteReminder(Reminder reminder) async {
    if (reminder.id != null) {
      await _notifications.cancelNotification(reminder.id!);
      await _db.deleteReminder(reminder.id!);
      await refreshReminders();
    }
  }

  Future<void> updateTimeframe(Reminder reminder, Timeframe newTimeframe) async {
    if (reminder.id == null) return;
    await _notifications.cancelNotification(reminder.id!);

    final newTime = computeRandomTime(
      newTimeframe,
      _comfortStart,
      _comfortEnd,
    );
    final updated = reminder.copyWith(
      timeframe: newTimeframe,
      scheduledAt: newTime,
      status: ReminderStatus.pending,
    );

    await _db.updateReminder(updated);
    await _notifications.scheduleNotification(updated);
    await refreshReminders();
  }

  Future<void> markDone(int reminderId) async {
    await _notifications.cancelNotification(reminderId);
    await _db.updateReminderStatus(reminderId, ReminderStatus.done);
    await refreshReminders();
  }

  Future<void> saveComfortHours(int start, int end) async {
    await _settings.saveComfortHours(start, end);
    // When settings saves comfort hours, it sets hasOnboarded to true.
    await refreshSettings();
  }

  Future<void> acceptTerms() async {
    await _settings.setTermsAccepted(true);
    await refreshSettings();
  }

  Future<void> setBackgroundAnimationsEnabled(bool enabled) async {
    await _settings.setBackgroundAnimationsEnabled(enabled);
    await refreshSettings();
  }

  /// Fires alarm in exactly 1 minute for testing purposes.
  Future<void> scheduleInOneMinute(String text) async {
    final scheduledAt = DateTime.now().millisecondsSinceEpoch + 60000;
    final reminder = Reminder(
      text: text.trim().isEmpty ? 'Test reminder' : text.trim(),
      timeframe: Timeframe.laterToday,
      scheduledAt: scheduledAt,
    );
    final id = await _db.insertReminder(reminder);
    final savedReminder = reminder.copyWith(id: id);

    await _notifications.scheduleNotification(savedReminder);
    await refreshReminders();
  }
}
