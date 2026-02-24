import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Animated confetti painter for celebration overlays.
///
/// Renders geometric confetti particles (diamonds, circles, triangles)
/// in brand colors that float downward across the screen.
class ConfettiPainter extends CustomPainter {
  ConfettiPainter({required this.progress});

  /// Animation progress from 0.0 to 1.0.
  final double progress;

  static final _random = math.Random(42);
  static final _particles = List.generate(24, _ParticleData.random);

  static const _colors = [
    AppColors.kaiBody,
    AppColors.kaiEye,
    AppColors.kaiAccentBlue,
    AppColors.incomeLight,
    Colors.white,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in _particles) {
      final x = particle.startX * size.width;
      final baseY = -20 + (size.height + 40) * (progress + particle.delay);
      final y = baseY % (size.height + 40) - 20;

      // Horizontal sway.
      final sway = math.sin(progress * math.pi * 4 + particle.phase) *
          particle.swayAmount *
          20;

      final rotation = progress * math.pi * 2 * particle.rotationSpeed;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity * 0.8);

      canvas
        ..save()
        ..translate(x + sway, y)
        ..rotate(rotation);

      switch (particle.shape) {
        case 0:
          // Diamond.
          final path = Path()
            ..moveTo(0, -particle.size)
            ..lineTo(particle.size * 0.6, 0)
            ..lineTo(0, particle.size)
            ..lineTo(-particle.size * 0.6, 0)
            ..close();
          canvas.drawPath(path, paint);
        case 1:
          // Circle.
          canvas.drawCircle(Offset.zero, particle.size * 0.5, paint);
        default:
          // Triangle.
          final path = Path()
            ..moveTo(0, -particle.size)
            ..lineTo(particle.size * 0.7, particle.size * 0.5)
            ..lineTo(-particle.size * 0.7, particle.size * 0.5)
            ..close();
          canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _ParticleData {
  _ParticleData({
    required this.startX,
    required this.delay,
    required this.size,
    required this.shape,
    required this.color,
    required this.swayAmount,
    required this.phase,
    required this.rotationSpeed,
  });

  factory _ParticleData.random(int _) {
    final random = ConfettiPainter._random;
    return _ParticleData(
      startX: random.nextDouble(),
      delay: random.nextDouble() * 0.6,
      size: 4.0 + random.nextDouble() * 6,
      shape: random.nextInt(3),
      color: ConfettiPainter._colors[
          random.nextInt(ConfettiPainter._colors.length)],
      swayAmount: 0.3 + random.nextDouble() * 0.7,
      phase: random.nextDouble() * math.pi * 2,
      rotationSpeed: 0.5 + random.nextDouble() * 1.5,
    );
  }

  final double startX;
  final double delay;
  final double size;
  final int shape;
  final Color color;
  final double swayAmount;
  final double phase;
  final double rotationSpeed;
}
