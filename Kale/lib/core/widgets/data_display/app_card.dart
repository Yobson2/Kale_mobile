import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Themed card using tonal surface layering (no borders).
///
/// Depth is achieved through background color tier shifts, not borders
/// or heavy shadows. Per the Digital Loom "No-Line Rule".
class AppCard extends StatelessWidget {
  /// Creates an [AppCard].
  const AppCard({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.padding,
    this.onTap,
    this.color,
    this.gradient,
    this.borderRadius,
  });

  /// Card body content.
  final Widget child;

  /// Optional header widget above body.
  final Widget? header;

  /// Optional footer widget below body.
  final Widget? footer;

  /// Content padding. Defaults to [AppSpacing.paddingLg].
  final EdgeInsetsGeometry? padding;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Background color override. Defaults to theme's card color.
  final Color? color;

  /// Optional gradient background (for hero/finance cards).
  final Gradient? gradient;

  /// Border radius override.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: gradient == null
              ? (color ?? theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow)
              : null,
          gradient: gradient,
          borderRadius: borderRadius ?? AppRadius.borderRadiusMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) ...[
              Padding(
                padding: AppSpacing.paddingLg,
                child: header,
              ),
              AppSpacing.verticalSm,
            ],
            Padding(
              padding: padding ?? AppSpacing.paddingLg,
              child: child,
            ),
            if (footer != null) ...[
              AppSpacing.verticalSm,
              Padding(
                padding: AppSpacing.paddingLg,
                child: footer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
