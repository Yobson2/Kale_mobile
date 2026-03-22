import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';

/// A themed linear progress bar with animated value transitions.
///
/// Used across budget and savings features to show completion progress.
class AppProgressBar extends StatelessWidget {
  /// Creates an [AppProgressBar].
  const AppProgressBar({
    required this.progress,
    this.height = 8,
    this.progressColor,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 600),
    super.key,
  });

  /// Progress value between 0.0 and 1.0.
  final double progress;

  /// Height of the progress bar.
  final double height;

  /// Color of the filled portion. Defaults to theme primary.
  final Color? progressColor;

  /// Color of the background track. Defaults to surfaceContainerHighest.
  final Color? backgroundColor;

  /// Animation duration for value changes.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fillColor = progressColor ?? colorScheme.primary;
    final trackColor =
        backgroundColor ?? colorScheme.surfaceContainerHighest;

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
                color: fillColor,
                borderRadius: AppRadius.borderRadiusFull,
              ),
            ),
          ),
        );
      },
    );
  }
}
