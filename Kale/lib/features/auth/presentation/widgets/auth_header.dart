import 'package:flutter/material.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Header widget for auth pages with Kai mascot, title, and subtitle.
///
/// Shows Kai in a contextual pose inside concentric circles, matching
/// the onboarding visual style. Pass [mascotPose] to set the emotional
/// context (e.g. [KaiPose.thinking] for forgot-password).
class AuthHeader extends StatelessWidget {
  /// Creates an [AuthHeader].
  const AuthHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.mascotPose = KaiPose.welcome,
    this.mascotSize = 80,
  });

  /// Main title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Which pose Kai should display. Defaults to [KaiPose.welcome].
  final KaiPose mascotPose;

  /// Size of the mascot illustration.
  final double mascotSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final container = theme.colorScheme.primaryContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.verticalXl,
        // Kai mascot with concentric circles (matches onboarding style)
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer soft circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        container.withValues(alpha: isDark ? 0.2 : 0.4),
                  ),
                ),
                // Inner circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        container.withValues(alpha: isDark ? 0.4 : 0.7),
                  ),
                ),
                // Kai mascot
                KaiMascot(pose: mascotPose, size: mascotSize),
              ],
            ),
          ),
        ),
        AppSpacing.verticalXl,
        Text(title, style: theme.textTheme.headlineMedium),
        if (subtitle != null) ...[
          AppSpacing.verticalSm,
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
        AppSpacing.verticalXxl,
      ],
    );
  }
}
