import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Speedometer-style gauge for budget spending visualization.
///
/// Renders a 270-degree arc with a gradient stroke showing
/// budget utilization percentage. Center displays the percentage
/// and status text.
class BudgetGauge extends StatelessWidget {
  /// Creates a [BudgetGauge].
  const BudgetGauge({
    required this.percent,
    super.key,
    this.size = 200,
    this.statusText,
  });

  /// Spending percentage (0.0 to 1.5+).
  final double percent;

  /// Widget size.
  final double size;

  /// Optional status text below the percentage.
  final String? statusText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayPercent = (percent * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated gauge arc
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(
                  progress: value,
                  isDark: isDark,
                  trackColor: theme.colorScheme.outlineVariant
                      .withValues(alpha: 0.15),
                ),
              );
            },
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$displayPercent%',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _progressColor(isDark),
                ),
              ),
              if (statusText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    statusText!.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _progressColor(bool isDark) {
    if (percent > 1.0) {
      return isDark ? AppColors.expenseDark : AppColors.expenseLight;
    }
    if (percent > 0.8) {
      return isDark ? AppColors.warningDark : AppColors.warningLight;
    }
    return isDark ? AppColors.primaryDark : AppColors.primaryLight;
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.isDark,
    required this.trackColor,
  });

  final double progress;
  final bool isDark;
  final Color trackColor;

  static const double _startAngle = 135 * math.pi / 180; // Start at 135°
  static const double _sweepAngle = 270 * math.pi / 180; // 270° arc

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, trackPaint);

    // Progress arc with gradient
    if (progress > 0) {
      final progressSweep = _sweepAngle * progress;

      final gradient = SweepGradient(
        startAngle: _startAngle,
        endAngle: _startAngle + progressSweep,
        colors: isDark
            ? [AppColors.primaryDark, AppColors.primaryContainerDark]
            : [AppColors.primaryLight, AppColors.primaryContainerLight],
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, _startAngle, progressSweep, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
