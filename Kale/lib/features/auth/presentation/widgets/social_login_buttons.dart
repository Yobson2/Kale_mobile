import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// 2-column grid of social login buttons (Google & Apple).
///
/// Uses tonal surface backgrounds instead of outlined borders.
class SocialLoginButtons extends StatelessWidget {
  /// Creates [SocialLoginButtons].
  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.googleLabel = 'Google',
    this.appleLabel = 'Apple',
  });

  /// Callback for Google sign-in.
  final VoidCallback? onGooglePressed;

  /// Callback for Apple sign-in.
  final VoidCallback? onApplePressed;

  /// Google button label. Override for i18n.
  final String googleLabel;

  /// Apple button label. Override for i18n.
  final String appleLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SocialButton(
          onPressed: onGooglePressed,
          icon: SvgPicture.asset(
            'assets/images/google.svg',
            width: 20,
            height: 20,
          ),
          label: googleLabel,
        ),
        AppSpacing.verticalMd,
        _SocialButton(
          onPressed: onApplePressed,
          icon: const Icon(Icons.apple, size: 24),
          label: appleLabel,
          isDark: true,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isDark = false,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bgColor =
        isDark ? colorScheme.inverseSurface : colorScheme.surfaceContainerLow;
    final fgColor =
        isDark ? colorScheme.onInverseSurface : colorScheme.onSurface;

    return SizedBox(
      height: 52,
      child: Material(
        color: bgColor,
        borderRadius: AppRadius.borderRadiusMd,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.borderRadiusMd,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: fgColor),
                child: icon,
              ),
              AppSpacing.horizontalSm,
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: fgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
