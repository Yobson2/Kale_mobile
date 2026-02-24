import 'package:flutter/material.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Empty state placeholder with Kai mascot, title, subtitle, and action.
///
/// When [useMascot] is true (default), shows Kai in the idle pose instead
/// of a plain icon. Pass a custom [mascotPose] for contextual poses.
class AppEmptyState extends StatelessWidget {
  /// Creates an [AppEmptyState].
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'Nothing here yet',
    this.subtitle,
    this.actionText,
    this.onAction,
    this.iconSize = 64,
    this.useMascot = true,
    this.mascotPose = KaiPose.idle,
    this.mascotSize = 120,
  });

  /// Large icon displayed at the top (used when [useMascot] is false).
  final IconData icon;

  /// Title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional action button text.
  final String? actionText;

  /// Callback for the action button.
  final VoidCallback? onAction;

  /// Size of the icon (used when [useMascot] is false).
  final double iconSize;

  /// Whether to show Kai mascot instead of the plain icon.
  final bool useMascot;

  /// Which pose Kai should display. Defaults to [KaiPose.idle].
  final KaiPose mascotPose;

  /// Size of the mascot illustration.
  final double mascotSize;

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
              if (useMascot)
                KaiMascot(
                  pose: mascotPose,
                  size: mascotSize,
                )
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
                OutlinedButton(
                  onPressed: onAction,
                  child: Text(actionText!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
