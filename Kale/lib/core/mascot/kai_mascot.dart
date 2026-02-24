import 'package:flutter/material.dart';
import 'package:kale/core/mascot/kai_painter.dart';
import 'package:kale/core/mascot/kai_pose.dart';

/// Kai the Chameleon mascot widget.
///
/// Renders a stylized geometric chameleon with Adinkra crest patterns,
/// Ndebele-inspired body markings, and Maasai wristband accents.
///
/// {@tool snippet}
/// ```dart
/// KaiMascot(
///   pose: KaiPose.welcome,
///   size: 200,
/// )
/// ```
/// {@end-tool}
class KaiMascot extends StatelessWidget {
  const KaiMascot({
    required this.pose,
    super.key,
    this.size = 200,
    this.colorTint,
  });

  /// Which pose Kai should display.
  final KaiPose pose;

  /// The width and height of the mascot. Defaults to 200.
  final double size;

  /// Optional color tint for contextual states.
  /// Pass amber for warnings, income-green for celebrations, etc.
  final Color? colorTint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: KaiPainter(
          pose: pose,
          colorTint: colorTint,
        ),
      ),
    );
  }
}
