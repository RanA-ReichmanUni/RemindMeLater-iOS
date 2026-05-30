import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remind_me_later/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../models/timeframe.dart';
import '../../providers/reminder_provider.dart';
import '../components/animated_backdrop.dart';
import '../components/timeframe_sheet.dart';

class DumpScreen extends StatefulWidget {
  final String? prefillText;
  final VoidCallback onPrefillConsumed;

  const DumpScreen({
    super.key,
    this.prefillText,
    required this.onPrefillConsumed,
  });

  @override
  State<DumpScreen> createState() => _DumpScreenState();
}

class _DumpScreenState extends State<DumpScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  Timeframe _selectedTimeframe = Timeframe.nextFewDays;
  bool _ignoreComfortHours = false;
  bool _showSuccess = false;
  bool _isTextEmpty = true;

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.18, end: 0.30).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _textController.addListener(_onTextChanged);

    if (widget.prefillText != null && widget.prefillText!.isNotEmpty) {
      _textController.text = widget.prefillText!;
      widget.onPrefillConsumed();
    }
  }

  @override
  void didUpdateWidget(covariant DumpScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prefillText != null && widget.prefillText!.isNotEmpty) {
      _textController.text = widget.prefillText!;
      widget.onPrefillConsumed();
    }
  }

  void _onTextChanged() {
    final empty = _textController.text.trim().isEmpty;
    if (empty != _isTextEmpty) {
      setState(() {
        _isTextEmpty = empty;
      });
      if (!empty) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _saveReminder(ReminderProvider provider) async {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    provider.addReminder(text, _selectedTimeframe, ignoreComfortHours: _ignoreComfortHours);
    _textController.clear();
    _ignoreComfortHours = false;

    setState(() {
      _showSuccess = true;
    });

    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
        });
      }
    });
  }

  void _openTimeframeSheet(ReminderProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return TimeframeSheet(
          selected: _selectedTimeframe,
          comfortStart: provider.comfortStart,
          comfortEnd: provider.comfortEnd,
          onSelected: (timeframe, ignore) {
            setState(() {
              _selectedTimeframe = timeframe;
              _ignoreComfortHours = ignore;
            });
          },
          onDismiss: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final provider = Provider.of<ReminderProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapt padding based on screen height like Android squeeze parameter
        final double h = constraints.maxHeight;
        final double squeeze = ((h - 520.0) / 200.0).clamp(0.0, 1.0);

        final double titleVertPad = 14.0 + 8.0 * squeeze;
        final double subtitleGap = 6.0 + 10.0 * squeeze;
        final double preDividerGap = 8.0 + 12.0 * squeeze;
        final double inputVertPad = 12.0 + 8.0 * squeeze;
        final double interCardGap = 8.0 + 8.0 * squeeze;
        final double buttonHeight = 48.0 + 10.0 * squeeze;
        final double textFieldHeight = 56.0 + 64.0 * squeeze;
        final double topPadding = MediaQuery.of(context).padding.top;
        final double bottomPadding = MediaQuery.of(context).padding.bottom;
        final double availableHeight = (constraints.maxHeight - topPadding - bottomPadding - 28.0).clamp(0.0, double.infinity);

        return Stack(
          children: [
            // Backdrop
            AnimatedBackdrop(animate: provider.backgroundAnimationsEnabled),

            // Foreground Content
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: availableHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                      child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // Hero title tile + input, visually fused
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      color: colors.primaryContainer.withOpacity(0.45),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: titleVertPad,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Dump & Forget:',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: colors.primary,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Remind Me Later',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colors.onSurface.withOpacity(0.55),
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: subtitleGap),
                                Text(
                                  AppLocalizations.of(context).tagline,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: preDividerGap),
                          Divider(
                            color: colors.primary.withOpacity(0.14),
                            height: 1,
                            thickness: 1,
                          ),
                          const SizedBox(height: 8),

                          // Input section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: inputVertPad,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: colors.primary.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.create,
                                        size: 18,
                                        color: colors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      AppLocalizations.of(context).dumpInputHeader,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _ChaosPad(
                                  controller: _textController,
                                  height: textFieldHeight,
                                  colors: colors,
                                  theme: theme,
                                  onSubmit: () {
                                    if (!_isTextEmpty) {
                                      _saveReminder(provider);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: interCardGap),

                    // Timing vibe Card
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      color: colors.primaryContainer.withOpacity(0.22),
                      elevation: 0,
                      child: InkWell(
                        onTap: () => _openTimeframeSheet(provider),
                        borderRadius: BorderRadius.circular(28),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: colors.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.schedule_outlined,
                                  size: 18,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).timingVibeLabel,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedTimeframe.localizedLabel(context),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Remind Me Later Glow Button
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = _isTextEmpty ? 1.0 : _scaleAnimation.value;
                        final glow = _isTextEmpty ? 0.0 : _glowAnimation.value;

                        return Container(
                          width: double.infinity,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            boxShadow: [
                              if (!_isTextEmpty)
                                BoxShadow(
                                  color: colors.primary.withOpacity(glow),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                )
                            ],
                          ),
                          transform: Matrix4.identity()
                            ..scale(scale),
                          transformAlignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: ElevatedButton(
                        onPressed: _isTextEmpty ? null : () => _saveReminder(provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          disabledBackgroundColor: colors.surfaceVariant,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: _isTextEmpty ? 0 : 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context).remindMeLaterBtn,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _isTextEmpty ? colors.onSurfaceVariant : colors.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.check,
                              color: _isTextEmpty ? colors.onSurfaceVariant : colors.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (!_isTextEmpty) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          _textController.clear();
                        },
                        child: Text(AppLocalizations.of(context).clearDraft),
                      ),
                    ],

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

            // Success overlay
            if (_showSuccess)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.50),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: colors.primary.withOpacity(0.45),
                            width: 1.5,
                          ),
                        ),
                        color: colors.primaryContainer,
                        borderOnForeground: true,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 28.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 40,
                                  color: colors.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                AppLocalizations.of(context).gotIt,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colors.onSurface,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context).wellRemindYouLater,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ChaosPad extends StatefulWidget {
  final TextEditingController controller;
  final double height;
  final ColorScheme colors;
  final ThemeData theme;
  final VoidCallback onSubmit;

  const _ChaosPad({
    required this.controller,
    required this.height,
    required this.colors,
    required this.theme,
    required this.onSubmit,
  });

  @override
  State<_ChaosPad> createState() => _ChaosPadState();
}

class _ChaosPadState extends State<_ChaosPad> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double focusStrength = _isFocused ? 1.0 : 0.0;
    final Color topGradient = widget.colors.primaryContainer.withOpacity(0.36 + (0.1 * focusStrength));
    final Color glowColor = widget.colors.primary.withOpacity(0.20 + (0.25 * focusStrength));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            topGradient,
            widget.colors.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: glowColor,
            width: 1.0,
          ),
        ),
        color: widget.colors.surface,
        borderOnForeground: true,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: 5,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: widget.theme.textTheme.bodyLarge?.copyWith(
              color: widget.colors.onSurface,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: widget.colors.primary,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).dumpHintText,
              hintStyle: widget.theme.textTheme.bodyLarge?.copyWith(
                color: widget.colors.onSurfaceVariant.withOpacity(0.75),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => _focusNode.unfocus(),
          ),
        ),
      ),
    );
  }
}
