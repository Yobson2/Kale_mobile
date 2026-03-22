import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Empty state placeholder with icon, title, subtitle, and action.
class AppEmptyState extends StatelessWidget {
  /// Creates an [AppEmptyState].
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'Nothing here yet',
    this.subtitle,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.iconSize = 64,
    this.illustration,
  });

  /// Large icon displayed at the top (hidden when [illustration] is provided).
  final IconData icon;

  /// Title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional action button text.
  final String? actionText;

  /// Callback for the action button.
  final VoidCallback? onAction;

  /// Optional secondary action button text.
  final String? secondaryActionText;

  /// Callback for the secondary action button.
  final VoidCallback? onSecondaryAction;

  /// Size of the icon.
  final double iconSize;

  /// Optional illustration widget (Lottie, SVG, Image) displayed instead of
  /// the icon.
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: subtitle != null ? '$title. $subtitle' : title,
      child: Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (illustration != null)
                illustration!
              else
                Icon(
                  icon,
                  size: iconSize,
                  color: theme.colorScheme.outline,
                ),
              AppSpacing.verticalLg,
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                AppSpacing.verticalSm,
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionText != null && onAction != null) ...[
                AppSpacing.verticalXl,
                FilledButton(
                  onPressed: onAction,
                  child: Text(actionText!),
                ),
              ],
              if (secondaryActionText != null &&
                  onSecondaryAction != null) ...[
                AppSpacing.verticalSm,
                OutlinedButton(
                  onPressed: onSecondaryAction,
                  child: Text(secondaryActionText!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
