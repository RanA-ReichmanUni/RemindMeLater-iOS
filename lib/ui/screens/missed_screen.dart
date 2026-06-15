import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reminder.dart';
import '../../models/timeframe.dart';
import '../../providers/reminder_provider.dart';

class MissedScreen extends StatefulWidget {
  const MissedScreen({super.key});

  @override
  State<MissedScreen> createState() => _MissedScreenState();
}

class _MissedScreenState extends State<MissedScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final provider = Provider.of<ReminderProvider>(context);
    final missed = provider.firedReminders;

    // Accent colour depends on whether there are missed items
    final accentColor = missed.isEmpty 
        ? Colors.green.shade600 
        : Color.lerp(colors.error, Colors.orange, 0.45)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.background,
            accentColor.withOpacity(0.06),
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
              _MissedHeader(count: missed.length, accentColor: accentColor, theme: theme, colors: colors),
              const SizedBox(height: 12),
              Expanded(
                child: missed.isEmpty
                    ? _AllCaughtUp(accentColor: accentColor)
                    : ListView.builder(
                        itemCount: missed.length,
                        itemBuilder: (context, index) {
                          final reminder = missed[index];
                          return Padding(
                            key: ValueKey(reminder.id),
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _MissedCard(
                              reminder: reminder,
                              accentColor: accentColor,
                              onDone: () => provider.markDone(reminder.id!),
                              onMove: (tf) => provider.updateTimeframe(reminder, tf),
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

// ── Header ──────────────────────────────────────────────────────────────────

class _MissedHeader extends StatelessWidget {
  final int count;
  final Color accentColor;
  final ThemeData theme;
  final ColorScheme colors;

  const _MissedHeader({
    required this.count,
    required this.accentColor,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: accentColor.withOpacity(0.35), width: 1.0),
      ),
      color: accentColor.withOpacity(0.08),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'MISSED ALERTS',
              style: theme.textTheme.labelMedium?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count == 0
                  ? 'All caught up!'
                  : count == 1
                      ? '1 alert needs your attention'
                      : '$count alerts need your attention',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'These fired while you were away. Handle them or delay.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Missed Card ──────────────────────────────────────────────────────────────

class _MissedCard extends StatefulWidget {
  final Reminder reminder;
  final Color accentColor;
  final VoidCallback onDone;
  final Function(Timeframe) onMove;
  final ColorScheme colors;
  final ThemeData theme;

  const _MissedCard({
    required this.reminder,
    required this.accentColor,
    required this.onDone,
    required this.onMove,
    required this.colors,
    required this.theme,
  });

  @override
  State<_MissedCard> createState() => _MissedCardState();
}

class _MissedCardState extends State<_MissedCard> {
  bool _expanded = false;

  String _timeAgo(int epochMs) {
    final diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(epochMs));
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _showHandledConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Mark as Handled?'),
        content: const Text('This will remove the reminder from your missed list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onDone();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes, handled'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: widget.accentColor.withOpacity(0.50), width: 1.2),
      ),
      color: widget.colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overdue indicator bubble
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🔔', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _timeAgo(widget.reminder.scheduledAt),
                        style: widget.theme.textTheme.labelSmall?.copyWith(
                          color: widget.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
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
            const SizedBox(height: 12),

            // Handled / Delay buttons
            Builder(builder: (context) {
              final useVertical = MediaQuery.textScalerOf(context).scale(1.0) > 1.4;
              final handledBtn = ElevatedButton.icon(
                onPressed: () => _showHandledConfirm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.done, size: 18),
                label: const Text('Handled', style: TextStyle(fontWeight: FontWeight.bold)),
              );

              final delayBtn = OutlinedButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.accentColor,
                  side: BorderSide(color: widget.accentColor.withOpacity(0.5), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: Icon(_expanded ? Icons.close : Icons.update, size: 18),
                label: Text(
                  _expanded ? 'Close' : 'Delay',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );

              return useVertical
                  ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      handledBtn,
                      const SizedBox(height: 8),
                      delayBtn,
                    ])
                  : Row(children: [
                      Expanded(child: handledBtn),
                      const SizedBox(width: 10),
                      Expanded(child: delayBtn),
                    ]);
            }),

            // Delay grid
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'Reschedule for:',
                          style: widget.theme.textTheme.labelMedium?.copyWith(
                            color: widget.colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _DelayGrid(
                          onSelected: (tf) {
                            setState(() => _expanded = false);
                            widget.onMove(tf);
                          },
                          accentColor: widget.accentColor,
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

// ── Delay Grid ───────────────────────────────────────────────────────────────

class _DelayGrid extends StatelessWidget {
  final Function(Timeframe) onSelected;
  final Color accentColor;
  final ColorScheme colors;

  const _DelayGrid({
    required this.onSelected,
    required this.accentColor,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final options = Timeframe.values;
    return Column(
      children: [
        Row(children: [
          _DelayBtn(option: options[0], onSelected: onSelected, accentColor: accentColor, colors: colors),
          const SizedBox(width: 8),
          _DelayBtn(option: options[1], onSelected: onSelected, accentColor: accentColor, colors: colors),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          _DelayBtn(option: options[2], onSelected: onSelected, accentColor: accentColor, colors: colors),
          const SizedBox(width: 8),
          _DelayBtn(option: options[3], onSelected: onSelected, accentColor: accentColor, colors: colors),
        ]),
      ],
    );
  }
}

class _DelayBtn extends StatelessWidget {
  final Timeframe option;
  final Function(Timeframe) onSelected;
  final Color accentColor;
  final ColorScheme colors;

  const _DelayBtn({
    required this.option,
    required this.onSelected,
    required this.accentColor,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onSelected(option),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: accentColor.withOpacity(0.35), width: 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          option.localizedLabel(context),
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _AllCaughtUp extends StatelessWidget {
  final Color accentColor;

  const _AllCaughtUp({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: accentColor.withOpacity(0.35), width: 1.0),
        ),
        color: accentColor.withOpacity(0.08),
        margin: const EdgeInsets.all(8),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(
                'All caught up!',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'No missed alerts. Check back here\nif you miss a notification.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
