import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComfortHoursSheet extends StatefulWidget {
  final int initialStart;
  final int initialEnd;
  final VoidCallback onDismiss;
  final Function(int start, int end) onSave;

  const ComfortHoursSheet({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.onDismiss,
    required this.onSave,
  });

  @override
  State<ComfortHoursSheet> createState() => _ComfortHoursSheetState();
}

class _ComfortHoursSheetState extends State<ComfortHoursSheet> {
  late int start;
  late int end;

  @override
  void initState() {
    super.initState();
    start = widget.initialStart;
    end = widget.initialEnd;
  }

  String formatHour(int hour) {
    final suffix = hour < 12 ? 'AM' : 'PM';
    int h = hour;
    if (hour == 0) {
      h = 12;
    } else if (hour > 12) {
      h = hour - 12;
    }
    return '$h:00 $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isSpansOvernight = end <= start && start != end;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).comfortHoursTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).comfortHoursSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // From Stepper
          _HourStepper(
            label: AppLocalizations.of(context).fromLabel,
            hour: start,
            format: formatHour,
            onDecrease: () {
              if (start > 0) {
                setState(() => start--);
              }
            },
            onIncrease: () {
              if (start < 23) {
                setState(() => start++);
              }
            },
          ),
          const SizedBox(height: 16),
          
          // Until Stepper
          _HourStepper(
            label: AppLocalizations.of(context).untilLabel,
            hour: end,
            format: formatHour,
            onDecrease: () {
              if (end > 0) {
                setState(() => end--);
              }
            },
            onIncrease: () {
              if (end < 23) {
                setState(() => end++);
              }
            },
          ),
          const SizedBox(height: 16),

          if (isSpansOvernight) ...[
            Text(
              AppLocalizations.of(context).spansOvernight,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],

          ElevatedButton(
            onPressed: end == start ? null : () => widget.onSave(start, end),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(AppLocalizations.of(context).saveBtn, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _HourStepper extends StatelessWidget {
  final String label;
  final int hour;
  final String Function(int) format;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _HourStepper({
    required this.label,
    required this.hour,
    required this.format,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrease,
              icon: const Text('−', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 90,
              child: Text(
                format(hour),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onIncrease,
              icon: const Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}
