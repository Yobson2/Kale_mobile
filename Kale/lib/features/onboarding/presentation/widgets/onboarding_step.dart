import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/onboarding/presentation/widgets/onboarding_illustration.dart';

/// Single onboarding step with illustration, title, and description.
class OnboardingStep extends StatelessWidget {
  const OnboardingStep({
    required this.stepIndex,
    required this.title,
    required this.description,
    super.key,
  });

  /// Index of the step (used to pick the correct illustration).
  final int stepIndex;

  /// Step title.
  final String title;

  /// Step description.
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.paddingHorizontalXl,
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Illustration
          OnboardingIllustration(stepIndex: stepIndex),
          const Spacer(),
          // Title
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalMd,
          // Description
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.brightness == Brightness.dark
                  ? theme.textTheme.bodySmall?.color
                  : theme.textTheme.bodySmall?.color,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
