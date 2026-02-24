import 'dart:math';

import 'package:flutter/material.dart';

/// Circular progress indicator for savings goals.
class SavingsProgressRing extends StatelessWidget {
  /// Creates a [SavingsProgressRing].
  const SavingsProgressRing({
    required this.progress,
    required this.size,
    super.key,
    this.strokeWidth = 6,
    this.backgroundColor,
    this.progressColor,
    this.child,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Diameter of the ring.
  final double size;

  /// Width of the ring stroke.
  final double strokeWidth;

  /// Color behind the progress arc.
  final Color? backgroundColor;

  /// Color of the progress arc.
  final Color? progressColor;

  /// Widget displayed in the center.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fgColor = progressColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: bgColor,
              progressColor: fgColor,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle.
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc.
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from top.
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor;
}
