import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Decorative "Le Fil" K mark watermark for brand anchoring.
///
/// Renders the one-colour brand mark at low opacity, positioned via
/// [alignment]. Used on hero cards, headers, splash, budget setup, and
/// empty states.
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

  /// Edge length of the square mark. Defaults to 120.
  ///
  /// Named `fontSize` for compatibility with the former text-based "K".
  final double fontSize;

  /// Alignment within the parent Stack. Defaults to bottomRight.
  final Alignment alignment;

  /// Color override. Defaults to onSurface from theme.
  final Color? color;

  /// Positional offset to allow partial cropping. Defaults to (20, 20).
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final markColor = color ?? Theme.of(context).colorScheme.onSurface;

    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset,
            child: SvgPicture.asset(
              'assets/images/logo-mark-mono.svg',
              width: fontSize,
              height: fontSize,
              colorFilter: ColorFilter.mode(
                markColor.withValues(alpha: opacity),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
