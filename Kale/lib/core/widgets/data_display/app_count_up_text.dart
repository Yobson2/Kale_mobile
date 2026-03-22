import 'package:flutter/material.dart';

/// Text widget that animates from 0 to [value] with a counting effect.
class AppCountUpText extends StatelessWidget {
  /// Creates an [AppCountUpText].
  const AppCountUpText({
    required this.value,
    required this.formatter,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  /// The target numeric value to count up to.
  final double value;

  /// Formatter function to convert the animated value to a string.
  final String Function(double value) formatter;

  /// Text style.
  final TextStyle? style;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, _) {
        return Text(
          formatter(animatedValue),
          style: style,
        );
      },
    );
  }
}
