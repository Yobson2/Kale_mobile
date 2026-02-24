import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Row of social login buttons (Google & Apple).
class SocialLoginButtons extends StatelessWidget {
  /// Creates [SocialLoginButtons].
  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.googleLabel = 'Continue with Google',
    this.appleLabel = 'Continue with Apple',
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
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            onPressed: onGooglePressed,
            icon: SvgPicture.asset(
              'assets/images/google.svg',
              width: 20,
              height: 20,
            ),
            label: googleLabel,
            theme: theme,
          ),
        ),
        AppSpacing.horizontalMd,
        Expanded(
          child: _SocialButton(
            onPressed: onApplePressed,
            icon: Icon(
              Icons.apple,
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            label: appleLabel,
            theme: theme,
          ),
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
    required this.theme,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        child: icon,
      ),
    );
  }
}
