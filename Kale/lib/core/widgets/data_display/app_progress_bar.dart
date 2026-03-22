import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';

/// A themed linear progress bar with gradient fill and animated transitions.
///
/// Uses a gradient from primary -> primaryContainer for the filled portion
/// and outlineVariant at low opacity for the track.
class AppProgressBar extends StatelessWidget {
  /// Creates an [AppProgressBar].
  const AppProgressBar({
    required this.progress,
    this.height = 8,
    this.progressColor,
    this.gradient,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 600),
    super.key,
  });

  /// Progress value between 0.0 and 1.0.
  final double progress;

  /// Height of the progress bar.
  final double height;

  /// Color of the filled portion. Ignored when [gradient] is set.
  final Color? progressColor;

  /// Gradient for the filled portion. Defaults to primary -> primaryContainer.
  final Gradient? gradient;

  /// Color of the background track.
  final Color? backgroundColor;

  /// Animation duration for value changes.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trackColor = backgroundColor ??
        colorScheme.outlineVariant.withValues(alpha: 0.15);
    final fillGradient = gradient ??
        LinearGradient(
          colors: [
            progressColor ?? colorScheme.primary,
            progressColor ?? colorScheme.primaryContainer,
          ],
        );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: AppRadius.borderRadiusFull,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedValue,
            child: Container(
              decoration: BoxDecoration(
                gradient: fillGradient,
                borderRadius: AppRadius.borderRadiusFull,
              ),
            ),
          ),
        );
      },
    );
  }
}
