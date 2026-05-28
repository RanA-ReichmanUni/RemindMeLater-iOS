import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../models/reminder.dart';
import '../../models/timeframe.dart';
import '../../providers/reminder_provider.dart';
import '../components/comfort_hours_sheet.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  int _displayCount = 10;

  String _formatHour(int hour) {
    final suffix = hour < 12 ? 'AM' : 'PM';
    int h = hour;
    if (hour == 0) {
      h = 12;
    } else if (hour > 12) {
      h = hour - 12;
    }
    return '$h:00 $suffix';
  }

  void _openComfortHoursSheet(BuildContext context, ReminderProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return ComfortHoursSheet(
          initialStart: provider.comfortStart,
          initialEnd: provider.comfortEnd,
          onDismiss: () => Navigator.of(context).pop(),
          onSave: (start, end) {
            provider.saveComfortHours(start, end);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final provider = Provider.of<ReminderProvider>(context);
    final reminders = provider.reminders;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.background,
            colors.surfaceVariant.withOpacity(0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Screen Header
              _ScreenHeader(
                count: reminders.length,
                comfortLabel: AppLocalizations.of(context).comfortWindowLabel(
                  _formatHour(provider.comfortStart),
                  _formatHour(provider.comfortEnd),
                ),
                onComfortClick: () => _openComfortHoursSheet(context, provider),
                theme: theme,
                colors: colors,
              ),
              const SizedBox(height: 12),

              // Queue List
              Expanded(
                child: reminders.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        itemCount: reminders.length > _displayCount ? _displayCount + 1 : reminders.length,
                        itemBuilder: (context, index) {
                          if (index == _displayCount) {
                            final remaining = reminders.length - _displayCount;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _displayCount += 10;
                                  });
                                },
                                child: Text(AppLocalizations.of(context).loadMore(remaining)),
                              ),
                            );
                          }

                          final reminder = reminders[index];
                          return Padding(
                            key: ValueKey(reminder.id),
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _ReminderCard(
                              reminder: reminder,
                              onDone: () => provider.markDone(reminder.id!),
                              onMove: (updatedTimeframe) => provider.updateTimeframe(reminder, updatedTimeframe),
                              colors: colors,
                              theme: theme,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  final int count;
  final String comfortLabel;
  final VoidCallback onComfortClick;
  final ThemeData theme;
  final ColorScheme colors;

  const _ScreenHeader({
    required this.count,
    required this.comfortLabel,
    required this.onComfortClick,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: colors.primary.withOpacity(0.20),
          width: 1.0,
        ),
      ),
      color: colors.surfaceVariant.withOpacity(0.62),
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context).dumpForgetHeader,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context).chaosQueue,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count == 1
                  ? AppLocalizations.of(context).trackingOne
                  : AppLocalizations.of(context).trackingCount(count),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: colors.onSecondaryContainer.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              color: colors.surface,
              margin: EdgeInsets.zero,
              elevation: 0,
              borderOnForeground: true,
              child: InkWell(
                onTap: onComfortClick,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comfortLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      Icon(
                        Icons.settings,
                        size: 18,
                        color: colors.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatefulWidget {
  final Reminder reminder;
  final VoidCallback onDone;
  final Function(Timeframe) onMove;
  final ColorScheme colors;
  final ThemeData theme;

  const _ReminderCard({
    required this.reminder,
    required this.onDone,
    required this.onMove,
    required this.colors,
    required this.theme,
  });

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
  bool _expanded = false;

  Pair<String, Color> _timeframeBadge(Timeframe timeframe) {
    switch (timeframe) {
      case Timeframe.laterToday:
        return Pair('⚡', widget.colors.secondary);
      case Timeframe.nextFewDays:
        return Pair('🌤', widget.colors.primary);
      case Timeframe.nextWeeks:
        return Pair('🌙', widget.colors.tertiaryContainer); // Or custom color tint
      case Timeframe.nextMonth:
        return Pair('🌊', widget.colors.onSurfaceVariant);
    }
  }

  void _showHandledConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(l10n.markAsHandled),
          content: Text(l10n.markHandledBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDone();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.colors.primary,
                foregroundColor: widget.colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.yesHandled),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeData = _timeframeBadge(widget.reminder.timeframe);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: widget.colors.primary.withOpacity(0.35),
          width: 1.0,
        ),
      ),
      color: widget.colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: badgeData.second.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(badgeData.first),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.reminder.timeframe.label,
                            style: widget.theme.textTheme.labelLarge?.copyWith(
                              color: widget.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.reminder.text,
                        style: widget.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showHandledConfirm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.colors.primary,
                      foregroundColor: widget.colors.onPrimary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.done, size: 18),
                    label: Text(AppLocalizations.of(context).handled, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.colors.primary,
                      side: BorderSide(color: widget.colors.primary.withOpacity(0.45), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: Icon(_expanded ? Icons.close : Icons.notifications, size: 18),
                    label: Text(
                      _expanded ? AppLocalizations.of(context).close : AppLocalizations.of(context).delay,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Delay options
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context).coolKickTo,
                          style: widget.theme.textTheme.labelMedium?.copyWith(
                            color: widget.colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _DelayGrid(
                          timeframe: widget.reminder.timeframe,
                          onSelected: (option) {
                            setState(() {
                              _expanded = false;
                            });
                            widget.onMove(option);
                          },
                          colors: widget.colors,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DelayGrid extends StatelessWidget {
  final Timeframe timeframe;
  final Function(Timeframe) onSelected;
  final ColorScheme colors;

  const _DelayGrid({
    required this.timeframe,
    required this.onSelected,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final options = Timeframe.values;

    return Column(
      children: [
        Row(
          children: [
            _DelayButton(
              option: options[0],
              isSelected: timeframe == options[0],
              onSelected: onSelected,
              colors: colors,
            ),
            const SizedBox(width: 8),
            _DelayButton(
              option: options[1],
              isSelected: timeframe == options[1],
              onSelected: onSelected,
              colors: colors,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _DelayButton(
              option: options[2],
              isSelected: timeframe == options[2],
              onSelected: onSelected,
              colors: colors,
            ),
            const SizedBox(width: 8),
            _DelayButton(
              option: options[3],
              isSelected: timeframe == options[3],
              onSelected: onSelected,
              colors: colors,
            ),
          ],
        ),
      ],
    );
  }
}

class _DelayButton extends StatelessWidget {
  final Timeframe option;
  final bool isSelected;
  final Function(Timeframe) onSelected;
  final ColorScheme colors;

  const _DelayButton({
    required this.option,
    required this.isSelected,
    required this.onSelected,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onSelected(option),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSelected ? colors.primary : colors.outline.withOpacity(0.35),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          option.localizedLabel(context),
          style: TextStyle(
            color: isSelected ? colors.primary : colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: colors.surfaceVariant.withOpacity(0.55),
        margin: const EdgeInsets.all(8.0),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🧭', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).zeroChaosin,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).brainDumpOther,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Pair<F, S> {
  final F first;
  final S second;
  Pair(this.first, this.second);
}
