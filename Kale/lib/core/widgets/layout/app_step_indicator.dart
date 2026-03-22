import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Linear step indicator for multi-step wizards.
class AppStepIndicator extends StatelessWidget {
  /// Creates an [AppStepIndicator].
  const AppStepIndicator({
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
    this.height = 4,
    super.key,
  });

  /// Zero-indexed current step.
  final int currentStep;

  /// Total number of steps.
  final int totalSteps;

  /// Color for completed and current step segments.
  final Color? activeColor;

  /// Color for incomplete step segments.
  final Color? inactiveColor;

  /// Height of the indicator bar.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive =
        inactiveColor ?? theme.colorScheme.surfaceContainerHighest;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index <= currentStep;
        return Expanded(
          child: Container(
            margin: index < totalSteps - 1
                ? const EdgeInsets.only(right: AppSpacing.xs)
                : EdgeInsets.zero,
            height: height,
            decoration: BoxDecoration(
              color: isCompleted ? active : inactive,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
