import 'package:flutter/material.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Error state placeholder with Kai mascot (warning pose) and retry button.
///
/// When [useMascot] is true (default), shows Kai in the warning pose instead
/// of a plain icon. Pass a custom [mascotPose] for contextual poses.
class AppErrorState extends StatelessWidget {
  /// Creates an [AppErrorState].
  const AppErrorState({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
    this.retryText = 'Retry',
    this.icon = Icons.error_outline,
    this.iconSize = 64,
    this.useMascot = true,
    this.mascotPose = KaiPose.warning,
    this.mascotSize = 120,
  });

  /// Error message.
  final String message;

  /// Callback for the retry button.
  final VoidCallback? onRetry;

  /// Retry button text.
  final String retryText;

  /// Error icon (used when [useMascot] is false).
  final IconData icon;

  /// Size of the icon (used when [useMascot] is false).
  final double iconSize;

  /// Whether to show Kai mascot instead of the plain icon.
  final bool useMascot;

  /// Which pose Kai should display. Defaults to [KaiPose.warning].
  final KaiPose mascotPose;

  /// Size of the mascot illustration.
  final double mascotSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      label: message,
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
                  color: theme.colorScheme.error,
                ),
              AppSpacing.verticalLg,
              Text(
                message,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                AppSpacing.verticalXl,
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
