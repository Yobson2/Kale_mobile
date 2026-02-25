import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Header widget for auth pages with concentric circles, title, and subtitle.
class AuthHeader extends StatelessWidget {
  /// Creates an [AuthHeader].
  const AuthHeader({
    required this.title,
    super.key,
    this.subtitle,
  });

  /// Main title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final container = theme.colorScheme.primaryContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.verticalXl,
        // Concentric circles visual
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
                // Icon in center
                Icon(
                  Icons.lock_outline_rounded,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
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
