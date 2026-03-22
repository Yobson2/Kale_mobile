import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Circular icon button with label for quick action rows.
class AppQuickAction extends StatelessWidget {
  /// Creates an [AppQuickAction].
  const AppQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.backgroundColor,
    this.iconSize = 24,
    super.key,
  });

  /// The icon to display.
  final IconData icon;

  /// The label displayed below the icon.
  final String label;

  /// Callback when tapped.
  final VoidCallback onTap;

  /// Icon color.
  final Color? color;

  /// Background color of the circle.
  final Color? backgroundColor;

  /// Size of the icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.primary;
    final bgColor =
        backgroundColor ?? iconColor.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.borderRadiusLg,
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          AppSpacing.verticalSm,
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
