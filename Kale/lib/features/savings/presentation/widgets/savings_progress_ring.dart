import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Circular progress indicator for savings goals with gradient stroke.
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
    final isDark = theme.brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.15);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GradientRingPainter(
                  progress: animatedProgress,
                  strokeWidth: strokeWidth,
                  backgroundColor: bgColor,
                  progressColor: progressColor,
                  isDark: isDark,
                ),
              ),
              if (child != null) child!,
            ],
          ),
        );
      },
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  _GradientRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.isDark,
    this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color? progressColor;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background circle.
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc with gradient.
    if (progress > 0) {
      final sweepAngle = 2 * pi * progress;

      final Paint progressPaint;
      if (progressColor != null) {
        progressPaint = Paint()
          ..color = progressColor!
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
      } else {
        final gradient = SweepGradient(
          startAngle: -pi / 2,
          endAngle: -pi / 2 + sweepAngle,
          colors: isDark
              ? [AppColors.primaryDark, AppColors.primaryContainerDark]
              : [AppColors.primaryLight, AppColors.primaryContainerLight],
        );
        progressPaint = Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
      }

      canvas.drawArc(
        rect,
        -pi / 2, // Start from top.
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.isDark != isDark;
}
