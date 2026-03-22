import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Decorative geometric "K" watermark for brand anchoring.
///
/// Renders a large "K" character at low opacity, positioned via [alignment].
/// Used on hero cards, headers, splash, budget setup, and empty states.
class GeometricKWatermark extends StatelessWidget {
  /// Creates a [GeometricKWatermark].
  const GeometricKWatermark({
    super.key,
    this.opacity = 0.05,
    this.fontSize = 120,
    this.alignment = Alignment.bottomRight,
    this.color,
    this.offset = const Offset(20, 20),
  });

  /// Opacity of the watermark (3-10% typical). Defaults to 5%.
  final double opacity;

  /// Font size of the "K" character. Defaults to 120.
  final double fontSize;

  /// Alignment within the parent Stack. Defaults to bottomRight.
  final Alignment alignment;

  /// Color override. Defaults to onSurface from theme.
  final Color? color;

  /// Positional offset to allow partial cropping. Defaults to (20, 20).
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final textColor =
        color ?? Theme.of(context).colorScheme.onSurface;

    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset,
            child: Text(
              'K',
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
                color: textColor.withValues(alpha: opacity),
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
