import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';

/// Visual indicator of password strength based on validation rules.
///
/// Evaluates the password against 5 rules (length >= 8, uppercase, lowercase,
/// digit, special character) and shows a segmented bar with 4 levels.
class PasswordStrengthIndicator extends StatelessWidget {
  /// Creates a [PasswordStrengthIndicator].
  const PasswordStrengthIndicator({required this.password, super.key});

  /// The current password value to evaluate.
  final String password;

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final score = Validators.passwordStrength(password);
    final level = _StrengthLevel.fromScore(score);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = level.color(isDark: isDark);
    final filledSegments = level.segments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            final isFilled = index < filledSegments;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                margin: index < 3
                    ? const EdgeInsets.only(right: AppSpacing.xs)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: isFilled
                      ? color
                      : Theme.of(context).dividerColor,
                  borderRadius: AppRadius.borderRadiusFull,
                ),
              ),
            );
          }),
        ),
        AppSpacing.verticalXs,
        Text(
          level.label(context),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

/// Internal strength level classification.
enum _StrengthLevel {
  weak,
  fair,
  strong,
  veryStrong;

  /// Maps a 0–5 score to a strength level.
  static _StrengthLevel fromScore(int score) {
    if (score <= 2) return weak;
    if (score == 3) return fair;
    if (score == 4) return strong;
    return veryStrong;
  }

  /// Number of bar segments to fill (out of 4).
  int get segments => switch (this) {
        weak => 1,
        fair => 2,
        strong => 3,
        veryStrong => 4,
      };

  /// Color for this strength level, theme-aware.
  Color color({required bool isDark}) => switch (this) {
        weak => isDark ? AppColors.errorDark : AppColors.errorLight,
        fair => isDark ? AppColors.warningDark : AppColors.warningLight,
        strong => const Color(0xFFA3E635),
        veryStrong => isDark ? AppColors.successDark : AppColors.successLight,
      };

  /// Localized label for this strength level.
  String label(BuildContext context) => switch (this) {
        weak => context.l10n.passwordStrengthWeak,
        fair => context.l10n.passwordStrengthFair,
        strong => context.l10n.passwordStrengthStrong,
        veryStrong => context.l10n.passwordStrengthVeryStrong,
      };
}
