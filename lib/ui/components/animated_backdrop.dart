import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackdrop extends StatefulWidget {
  final bool animate;
  const AnimatedBackdrop({super.key, this.animate = true});

  @override
  State<AnimatedBackdrop> createState() => _AnimatedBackdropState();
}

class _AnimatedBackdropState extends State<AnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return CustomPaint(
        painter: BackdropPainter(
          theme: Theme.of(context),
          driftX: 28.0,
          driftY: -18.0,
          glow: 0.08,
        ),
        child: const SizedBox.expand(),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final double driftX = -90.0 + 180.0 * t;
        final double driftY = 70.0 - 140.0 * t;
        final double glow = 0.05 + 0.13 * sin(t * pi);

        return CustomPaint(
          painter: BackdropPainter(
            theme: Theme.of(context),
            driftX: driftX,
            driftY: driftY,
            glow: glow,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class BackdropPainter extends CustomPainter {
  final ThemeData theme;
  final double driftX;
  final double driftY;
  final double glow;

  BackdropPainter({
    required this.theme,
    required this.driftX,
    required this.driftY,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colors = theme.colorScheme;
    final rect = Offset.zero & size;

    // 1. Draw linear gradient background
    // Clamping coordinates relative to size to keep gradient rendering correct
    final gradient = LinearGradient(
      colors: [
        colors.background,
        colors.primaryContainer.withOpacity(0.32),
        colors.secondaryContainer.withOpacity(0.24),
      ],
      begin: Alignment(
        (-0.5 + (driftX / size.width)).clamp(-1.0, 1.0),
        (-0.5 + (driftY / size.height)).clamp(-1.0, 1.0),
      ),
      end: Alignment(
        (0.5 - (driftX / size.width)).clamp(-1.0, 1.0),
        (0.5 - (driftY / size.height)).clamp(-1.0, 1.0),
      ),
    );

    final paintBg = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paintBg);

    final double minDimension = min(size.width, size.height);

    // 2. Draw circles with alpha opacity
    // Circle 1: Primary
    final paint1 = Paint()
      ..color = colors.primary.withOpacity((0.14 + glow).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.2 + driftX, size.height * 0.2 + driftY),
      minDimension * 0.45,
      paint1,
    );

    // Circle 2: Tertiary (Using primary/secondary mix since Material 3 colorScheme tertiary is nullable or defaults to container)
    final Color tertiaryColor = colors.secondary.withRed(150); // custom tint
    final paint2 = Paint()
      ..color = tertiaryColor.withOpacity((0.12 + glow * 0.6).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.9 - driftX, size.height * 0.15 - driftY),
      minDimension * 0.28,
      paint2,
    );

    // Circle 3: Secondary
    final paint3 = Paint()
      ..color = colors.secondary.withOpacity((0.1 + glow * 0.5).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.85 + driftY, size.height * 0.85 - driftX),
      minDimension * 0.55,
      paint3,
    );
  }

  @override
  bool shouldRepaint(covariant BackdropPainter oldDelegate) {
    return oldDelegate.driftX != driftX ||
        oldDelegate.driftY != driftY ||
        oldDelegate.glow != glow ||
        oldDelegate.theme != theme;
  }
}
