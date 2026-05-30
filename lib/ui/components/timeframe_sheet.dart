import 'dart:math';
import 'package:flutter/material.dart';
import 'package:remind_me_later/l10n/app_localizations.dart';
import '../../models/timeframe.dart';

class TimeframeSheet extends StatefulWidget {
  final Timeframe selected;
  final int comfortStart;
  final int comfortEnd;
  final Function(Timeframe timeframe, bool ignoreComfortHours) onSelected;
  final VoidCallback onDismiss;

  const TimeframeSheet({
    super.key,
    required this.selected,
    required this.comfortStart,
    required this.comfortEnd,
    required this.onSelected,
    required this.onDismiss,
  });

  @override
  State<TimeframeSheet> createState() => _TimeframeSheetState();
}

class _TimeframeSheetState extends State<TimeframeSheet> {
  bool _isOutsideOrNearComfortEnd() {
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;

    if (widget.comfortEnd > widget.comfortStart) {
      // Normal daytime window
      return nowMin < widget.comfortStart * 60 ||
          nowMin >= widget.comfortEnd * 60 ||
          (widget.comfortEnd * 60 - nowMin) < 30;
    } else {
      // Night shift window
      final inWindow = nowMin >= widget.comfortStart * 60 || nowMin < widget.comfortEnd * 60;
      if (!inWindow) return true;
      final minsToEnd = nowMin >= widget.comfortStart * 60
          ? (24 * 60 - nowMin) + widget.comfortEnd * 60
          : widget.comfortEnd * 60 - nowMin;
      return minsToEnd < 30;
    }
  }

  String _to12h(int hour) {
    final suffix = hour < 12 ? 'AM' : 'PM';
    int h = hour;
    if (hour == 0) {
      h = 12;
    } else if (hour > 12) {
      h = hour - 12;
    }
    return '$h:00 $suffix';
  }

  String _buildWarningMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;
    final nightShift = widget.comfortEnd <= widget.comfortStart;

    if (nightShift && (nowMin >= widget.comfortStart * 60 || nowMin < widget.comfortEnd * 60)) {
      final remaining = nowMin >= widget.comfortStart * 60
          ? (24 * 60 - nowMin) + widget.comfortEnd * 60
          : widget.comfortEnd * 60 - nowMin;
      return l10n.warningMinutesLeft(remaining, remaining == 1 ? '' : 's');
    }

    if (nowMin < widget.comfortStart * 60) {
      return l10n.warningNotStarted(_to12h(widget.comfortStart));
    } else if (nowMin >= widget.comfortEnd * 60) {
      return l10n.warningEnded(_to12h(widget.comfortEnd));
    } else {
      final remaining = widget.comfortEnd * 60 - nowMin;
      return l10n.warningAlmostOver(remaining, remaining == 1 ? '' : 's');
    }
  }

  void _showComfortWarning(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        final colors = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(l10n.outsideComfortHours),
          content: Text(_buildWarningMessage(context)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
                widget.onSelected(Timeframe.laterToday, false);
                widget.onDismiss();
              },
              child: Text(l10n.scheduleForTomorrow),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
                widget.onSelected(Timeframe.laterToday, true);
                widget.onDismiss();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.alertMeAnyway),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).timingVibeTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).timingVibeSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _TimeframeGrid(
            selected: widget.selected,
            onSelected: (timeframe) {
              if (timeframe == Timeframe.laterToday && _isOutsideOrNearComfortEnd()) {
                // Dismiss sheet first, then show warning
                Navigator.of(context).pop();
                _showComfortWarning(context);
              } else {
                Navigator.of(context).pop();
                widget.onSelected(timeframe, false);
                widget.onDismiss();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TimeframeGrid extends StatelessWidget {
  final Timeframe selected;
  final Function(Timeframe) onSelected;

  const _TimeframeGrid({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final options = Timeframe.values;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final tf = options[index];
        return _TimeframeTile(
          timeframe: tf,
          isSelected: selected == tf,
          onClick: () => onSelected(tf),
        );
      },
    );
  }
}

class _TimeframeTile extends StatelessWidget {
  final Timeframe timeframe;
  final bool isSelected;
  final VoidCallback onClick;

  const _TimeframeTile({
    required this.timeframe,
    required this.isSelected,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final String subtitle = timeframe.localizedSubtitle(context);

    return GestureDetector(
      onTap: onClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryContainer.withOpacity(0.9) : colors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outline.withOpacity(0.28),
            width: 1.4,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timeframe.emoji, style: const TextStyle(fontSize: 24)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 32,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : colors.outline.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              timeframe.localizedLabel(context),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.onPrimaryContainer : colors.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
