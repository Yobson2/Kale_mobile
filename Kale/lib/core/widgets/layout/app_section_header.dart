import 'package:flutter/material.dart';

/// Section header with title and optional trailing action.
class AppSectionHeader extends StatelessWidget {
  /// Creates an [AppSectionHeader].
  const AppSectionHeader({
    required this.title,
    this.trailing,
    this.trailingText,
    this.onTrailingTap,
    this.padding,
    super.key,
  });

  /// Section title text.
  final String title;

  /// Optional trailing widget (overrides [trailingText]).
  final Widget? trailing;

  /// Optional trailing text shown as a tappable link.
  final String? trailingText;

  /// Callback when trailing text is tapped.
  final VoidCallback? onTrailingTap;

  /// Optional custom padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailing != null)
            trailing!
          else if (trailingText != null)
            TextButton(
              onPressed: onTrailingTap,
              child: Text(
                trailingText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
