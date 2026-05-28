import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import '../../database/database_helper.dart';
import '../../models/reminder.dart';
import '../../models/timeframe.dart';
import '../../providers/reminder_provider.dart';
import '../../services/notification_service.dart';

class AlarmScreen extends StatefulWidget {
  final Reminder reminder;
  final VoidCallback onDismiss;
  final bool playSiren;

  const AlarmScreen({
    super.key,
    required this.reminder,
    required this.onDismiss,
    this.playSiren = true,
  });

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  bool _showSnoozeOptions = false;

  @override
  void initState() {
    super.initState();
    // Play default alarm tone on page load only if requested
    if (widget.playSiren) {
      _startRingtone();
    }
  }

  void _startRingtone() {
    try {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );
    } catch (e) {
      // Ringtone player might fail in some test envs, catch gracefully
    }
  }

  void _stopRingtone() {
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {
      // Catch gracefully
    }
  }

  @override
  void dispose() {
    _stopRingtone();
    super.dispose();
  }

  void _handleDone(ReminderProvider provider) async {
    _stopRingtone();
    await provider.markDone(widget.reminder.id!);
    widget.onDismiss();
  }

  void _handleSnooze(ReminderProvider provider, Timeframe newTimeframe) async {
    _stopRingtone();
    await provider.updateTimeframe(widget.reminder, newTimeframe);
    widget.onDismiss();
  }

  void _handleSnoozeTomorrow(ReminderProvider provider) async {
    _stopRingtone();
    
    // Custom snooze tomorrow: schedules exactly tomorrow at a random hour within comfort window
    final random = Random();
    final comfortStart = provider.comfortStart;
    final comfortEnd = provider.comfortEnd;
    
    int hour;
    if (comfortEnd > comfortStart) {
      hour = comfortStart + random.nextInt(comfortEnd - comfortStart);
    } else {
      hour = (comfortStart + random.nextInt((24 - comfortStart) + comfortEnd)) % 24;
    }
    
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final scheduledAt = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      hour,
      random.nextInt(60),
    ).millisecondsSinceEpoch;

    final updated = widget.reminder.copyWith(
      timeframe: Timeframe.nextFewDays,
      scheduledAt: scheduledAt,
      status: ReminderStatus.pending,
    );

    // Save and schedule
    await DatabaseHelper.instance.updateReminder(updated);
    await NotificationService.instance.scheduleNotification(updated);
    await provider.refreshReminders();

    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final provider = Provider.of<ReminderProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              // Pinned App title at the top
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dump & Forget:',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colors.primary,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Remind Me Later',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface.withOpacity(0.55),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ringing Bell + Reminder text in center
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🔔',
                      style: TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.reminder.text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onBackground,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).youWantedReminded,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons at the bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Expandable snooze panel
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: _showSnoozeOptions
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: colors.surfaceVariant,
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(
                                          AppLocalizations.of(context).snoozeUntil,
                                          style: theme.textTheme.labelLarge?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                      _SnoozeRow(
                                        label: AppLocalizations.of(context).snoozeLaterToday,
                                        onClick: () => _handleSnooze(provider, Timeframe.laterToday),
                                        colors: colors,
                                      ),
                                      _SnoozeRow(
                                        label: AppLocalizations.of(context).snoozeTomorrow,
                                        onClick: () => _handleSnoozeTomorrow(provider),
                                        colors: colors,
                                      ),
                                      _SnoozeRow(
                                        label: AppLocalizations.of(context).snoozeNextFewDays,
                                        onClick: () => _handleSnooze(provider, Timeframe.nextFewDays),
                                        colors: colors,
                                      ),
                                      _SnoozeRow(
                                        label: AppLocalizations.of(context).snoozeNextWeeks,
                                        onClick: () => _handleSnooze(provider, Timeframe.nextWeeks),
                                        colors: colors,
                                      ),
                                      _SnoozeRow(
                                        label: AppLocalizations.of(context).snoozeNextMonth,
                                        onClick: () => _handleSnooze(provider, Timeframe.nextMonth),
                                        colors: colors,
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 12),

                      // Bottom actions: Done and Snooze
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleDone(provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                AppLocalizations.of(context).doneBtn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _showSnoozeOptions = !_showSnoozeOptions;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colors.primary.withOpacity(0.45), width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                _showSnoozeOptions
                                    ? AppLocalizations.of(context).cancelSnooze
                                    : AppLocalizations.of(context).snoozeBtn,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SnoozeRow extends StatelessWidget {
  final String label;
  final VoidCallback onClick;
  final ColorScheme colors;

  const _SnoozeRow({
    required this.label,
    required this.onClick,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onClick,
        child: Text(
          label,
          style: TextStyle(
            color: colors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
