import 'dart:ui';

import 'package:flutter/material.dart';

/// Glassmorphic container with backdrop blur and semi-transparent fill.
///
/// Wraps content in a frosted-glass effect using [BackdropFilter].
/// Used by the bottom navigation bar, app bar overlays, and modal backdrops.
class GlassContainer extends StatelessWidget {
  /// Creates a [GlassContainer].
  const GlassContainer({
    required this.child,
    super.key,
    this.opacity = 0.6,
    this.blurRadius = 16,
    this.borderRadius,
    this.color,
    this.border,
    this.padding,
  });

  /// The child widget to display inside the glass container.
  final Widget child;

  /// Opacity of the background fill (0.0 - 1.0). Defaults to 0.6.
  final double opacity;

  /// Blur sigma for the backdrop filter. Defaults to 16.
  final double blurRadius;

  /// Border radius. Defaults to none (rectangular).
  final BorderRadius? borderRadius;

  /// Background color. Defaults to surface color from theme.
  final Color? color;

  /// Optional border decoration.
  final BoxBorder? border;

  /// Optional padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final surfaceColor =
        color ?? Theme.of(context).colorScheme.surface;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurRadius,
          sigmaY: blurRadius,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: surfaceColor.withValues(alpha: opacity),
            borderRadius: borderRadius,
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}
