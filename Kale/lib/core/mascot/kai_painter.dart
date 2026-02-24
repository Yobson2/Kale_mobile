import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Custom painter that draws Kai the Chameleon mascot.
///
/// A stylized geometric chameleon with Adinkra crest patterns,
/// Ndebele-inspired body markings, and Maasai wristband accents.
/// Drawn entirely with Flutter's canvas API — no external assets.
class KaiPainter extends CustomPainter {
  KaiPainter({
    required this.pose,
    this.colorTint,
  });

  final KaiPose pose;

  /// Optional color override for contextual states (amber for warning, etc.).
  final Color? colorTint;

  Color get _bodyColor => colorTint ?? AppColors.kaiBody;
  Color get _bellyColor => AppColors.kaiBelly;
  Color get _crestColor => AppColors.kaiCrest;
  Color get _eyeColor => AppColors.kaiEye;
  Color get _markingsColor => AppColors.kaiMarkings;
  Color get _accentBlue => AppColors.kaiAccentBlue;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 200;
    final sy = size.height / 200;
    canvas
      ..save()
      ..scale(sx, sy);

    switch (pose) {
      case KaiPose.welcome:
        _paintWelcome(canvas);
      case KaiPose.celebration:
        _paintCelebration(canvas);
      case KaiPose.thinking:
        _paintThinking(canvas);
      case KaiPose.warning:
        _paintWarning(canvas);
      case KaiPose.idle:
        _paintIdle(canvas);
    }

    canvas.restore();
  }

  // ── Welcome Pose ───────────────────────────────────────────

  void _paintWelcome(Canvas canvas) {
    _drawTail(canvas, curled: false, tailAngle: -0.4);
    _drawBody(canvas);
    _drawArm(canvas, isLeft: true, angle: -1.2);
    _drawArm(canvas, isLeft: false, angle: 1.2);
    _drawWristband(canvas, isLeft: true, armAngle: -1.2);
    _drawWristband(canvas, isLeft: false, armAngle: 1.2);
    _drawHead(canvas);
    _drawCrest(canvas);
    _drawEyes(canvas, happy: true);
    _drawMouth(canvas, open: true);
    _drawPendant(canvas);
    _drawBodyMarkings(canvas);
  }

  // ── Celebration Pose ───────────────────────────────────────

  void _paintCelebration(Canvas canvas) {
    _drawTail(canvas, curled: false, tailAngle: -0.8, star: true);

    canvas
      ..save()
      ..translate(0, -12);

    _drawBody(canvas);
    _drawArm(canvas, isLeft: true, angle: -2.4);
    _drawArm(canvas, isLeft: false, angle: 2.4);
    _drawWristband(canvas, isLeft: true, armAngle: -2.4);
    _drawWristband(canvas, isLeft: false, armAngle: 2.4);
    _drawHead(canvas, tilt: -0.1);
    _drawCrest(canvas, tilt: -0.1);
    _drawEyes(canvas, happy: true, closed: true);
    _drawMouth(canvas, open: true);
    _drawPendant(canvas);
    _drawBodyMarkings(canvas);

    canvas.restore();

    _drawSparkles(canvas);
  }

  // ── Thinking Pose ──────────────────────────────────────────

  void _paintThinking(Canvas canvas) {
    _drawTail(canvas, curled: true, tailAngle: 0.2, questionMark: true);
    _drawBody(canvas, lean: 0.05);
    _drawArm(canvas, isLeft: true, angle: -0.3);
    _drawArm(canvas, isLeft: false, angle: 0.3);
    _drawWristband(canvas, isLeft: true, armAngle: -0.3);
    _drawWristband(canvas, isLeft: false, armAngle: 0.3);
    _drawHead(canvas, tilt: 0.15);
    _drawCrest(canvas, tilt: 0.15);
    _drawEyes(canvas, leftAngle: 0.3, rightAngle: -0.2);
    _drawMouth(canvas);
    _drawPendant(canvas);
    _drawBodyMarkings(canvas);
  }

  // ── Warning Pose ───────────────────────────────────────────

  void _paintWarning(Canvas canvas) {
    _drawTail(canvas, curled: false, rigid: true);
    _drawBody(canvas);
    _drawArm(canvas, isLeft: true, angle: -0.8, palmOut: true);
    _drawArm(canvas, isLeft: false, angle: 0.8, palmOut: true);
    _drawWristband(canvas, isLeft: true, armAngle: -0.8);
    _drawWristband(canvas, isLeft: false, armAngle: 0.8);
    _drawHead(canvas);
    _drawCrest(canvas);
    _drawEyes(canvas, concerned: true);
    _drawMouth(canvas, smile: false);
    _drawPendant(canvas);
    _drawBodyMarkings(canvas);
    _drawWarningTriangles(canvas);
  }

  // ── Idle Pose ──────────────────────────────────────────────

  void _paintIdle(Canvas canvas) {
    _drawTail(canvas, curled: true, tailAngle: 0.3);

    canvas
      ..save()
      ..translate(0, 8);

    _drawBody(canvas, sitting: true);
    _drawArm(canvas, isLeft: true, angle: -0.2);
    _drawArm(canvas, isLeft: false, angle: 0.8);
    _drawWristband(canvas, isLeft: true, armAngle: -0.2);
    _drawWristband(canvas, isLeft: false, armAngle: 0.8);
    _drawHead(canvas, tilt: 0.1);
    _drawCrest(canvas, tilt: 0.1);
    _drawEyes(canvas, leftAngle: 0.1, happy: true);
    _drawMouth(canvas);
    _drawPendant(canvas);
    _drawBodyMarkings(canvas);

    canvas.restore();
  }

  // ── Drawing Primitives ─────────────────────────────────────

  void _drawBody(Canvas canvas, {double lean = 0, bool sitting = false}) {
    final bodyPaint = Paint()..color = _bodyColor;
    final bellyPaint = Paint()..color = _bellyColor;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(100 + lean * 20, sitting ? 120 : 115),
        width: 52,
        height: sitting ? 50 : 60,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    final bellyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(100 + lean * 20, sitting ? 118 : 113),
        width: 32,
        height: sitting ? 30 : 38,
      ),
      const Radius.circular(14),
    );
    canvas.drawRRect(bellyRect, bellyPaint);

    if (sitting) {
      _drawSittingLegs(canvas, lean: lean);
    } else {
      _drawLegs(canvas, lean: lean);
    }
  }

  void _drawLegs(Canvas canvas, {double lean = 0}) {
    final legPaint = Paint()
      ..color = _bodyColor
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(
        Offset(88 + lean * 20, 140),
        Offset(82 + lean * 10, 168),
        legPaint,
      )
      ..drawLine(
        Offset(112 + lean * 20, 140),
        Offset(118 + lean * 10, 168),
        legPaint,
      );

    _drawFoot(canvas, Offset(82 + lean * 10, 168), isLeft: true);
    _drawFoot(canvas, Offset(118 + lean * 10, 168), isLeft: false);
  }

  void _drawSittingLegs(Canvas canvas, {double lean = 0}) {
    final legPaint = Paint()
      ..color = _bodyColor
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(
        Offset(88 + lean * 20, 140),
        const Offset(78, 158),
        legPaint,
      )
      ..drawLine(
        Offset(112 + lean * 20, 140),
        const Offset(122, 158),
        legPaint,
      );

    _drawFoot(canvas, const Offset(78, 158), isLeft: true);
    _drawFoot(canvas, const Offset(122, 158), isLeft: false);
  }

  void _drawFoot(Canvas canvas, Offset position, {required bool isLeft}) {
    final footPaint = Paint()
      ..color = _bodyColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dir = isLeft ? -1.0 : 1.0;

    canvas
      ..drawLine(position, position + Offset(dir * -6, 5), footPaint)
      ..drawLine(position, position + Offset(dir * 6, 5), footPaint);
  }

  void _drawArm(
    Canvas canvas, {
    required bool isLeft,
    required double angle,
    bool palmOut = false,
  }) {
    final armPaint = Paint()
      ..color = _bodyColor
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final shoulderX = isLeft ? 76.0 : 124.0;
    const shoulderY = 100.0;
    const armLength = 30.0;

    final endX = shoulderX + armLength * math.sin(angle);
    final endY = shoulderY - armLength * math.cos(angle);

    canvas.drawLine(
      Offset(shoulderX, shoulderY),
      Offset(endX, endY),
      armPaint,
    );

    _drawHand(canvas, Offset(endX, endY), angle, palmOut: palmOut);
  }

  void _drawHand(
    Canvas canvas,
    Offset position,
    double angle, {
    bool palmOut = false,
  }) {
    final handPaint = Paint()
      ..color = _bodyColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (palmOut) {
      final perpAngle = angle + math.pi / 2;
      for (var i = -1; i <= 1; i += 2) {
        canvas.drawLine(
          position,
          position +
              Offset(
                8 * math.cos(perpAngle) * i + 4 * math.sin(angle),
                8 * math.sin(perpAngle) * i - 4 * math.cos(angle),
              ),
          handPaint,
        );
      }
    } else {
      canvas
        ..drawLine(
          position,
          position +
              Offset(
                5 * math.sin(angle - 0.4),
                -5 * math.cos(angle - 0.4),
              ),
          handPaint,
        )
        ..drawLine(
          position,
          position +
              Offset(
                5 * math.sin(angle + 0.4),
                -5 * math.cos(angle + 0.4),
              ),
          handPaint,
        );
    }
  }

  void _drawWristband(
    Canvas canvas, {
    required bool isLeft,
    required double armAngle,
  }) {
    final shoulderX = isLeft ? 76.0 : 124.0;
    const shoulderY = 100.0;
    const armLength = 30.0;

    final bandX = shoulderX + armLength * 0.65 * math.sin(armAngle);
    final bandY = shoulderY - armLength * 0.65 * math.cos(armAngle);

    final bandPaint = Paint()
      ..color = _bodyColor.withValues(alpha: 0.8)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final perp = armAngle + math.pi / 2;
    canvas.drawLine(
      Offset(bandX - 4 * math.cos(perp), bandY - 4 * math.sin(perp)),
      Offset(bandX + 4 * math.cos(perp), bandY + 4 * math.sin(perp)),
      bandPaint,
    );

    final stripePaint = Paint()
      ..color = _eyeColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(bandX - 4 * math.cos(perp), bandY - 4 * math.sin(perp)),
      Offset(bandX + 4 * math.cos(perp), bandY + 4 * math.sin(perp)),
      stripePaint,
    );
  }

  void _drawHead(Canvas canvas, {double tilt = 0}) {
    final headPaint = Paint()..color = _bodyColor;

    canvas
      ..save()
      ..translate(100, 72)
      ..rotate(tilt)
      ..drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: 44,
          height: 38,
        ),
        headPaint,
      )
      ..restore();
  }

  void _drawCrest(Canvas canvas, {double tilt = 0}) {
    final crestPaint = Paint()..color = _crestColor;

    canvas
      ..save()
      ..translate(100, 72)
      ..rotate(tilt);

    // Triangular crest — Adinkra "Aya" fern shape.
    final crestPath = Path()
      ..moveTo(0, -22)
      ..lineTo(-8, -8)
      ..lineTo(-4, -10)
      ..lineTo(-2, -4)
      ..lineTo(0, -14)
      ..lineTo(2, -4)
      ..lineTo(4, -10)
      ..lineTo(8, -8)
      ..close();

    canvas.drawPath(crestPath, crestPaint);

    // Geometric line details (Adinkra pattern).
    final patternPaint = Paint()
      ..color = _bodyColor.withValues(alpha: 0.6)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(const Offset(-3, -12), const Offset(3, -12), patternPaint)
      ..drawLine(const Offset(-2, -8), const Offset(2, -8), patternPaint)
      ..restore();
  }

  void _drawEyes(
    Canvas canvas, {
    double leftAngle = 0,
    double rightAngle = 0,
    bool happy = false,
    bool closed = false,
    bool concerned = false,
  }) {
    const leftCenter = Offset(86, 68);
    const rightCenter = Offset(114, 68);

    _drawSingleEye(
      canvas,
      leftCenter,
      leftAngle,
      happy: happy,
      closed: closed,
      wide: concerned,
    );
    _drawSingleEye(
      canvas,
      rightCenter,
      rightAngle,
      happy: happy,
      closed: closed,
      narrow: concerned,
    );
  }

  void _drawSingleEye(
    Canvas canvas,
    Offset center,
    double lookAngle, {
    bool happy = false,
    bool closed = false,
    bool wide = false,
    bool narrow = false,
  }) {
    final domePaint = Paint()..color = Colors.white;
    final domeOutline = Paint()
      ..color = _crestColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final eyeRadius = wide ? 10.0 : (narrow ? 7.0 : 9.0);

    canvas
      ..drawCircle(center, eyeRadius, domePaint)
      ..drawCircle(center, eyeRadius, domeOutline);

    if (closed) {
      final closedPaint = Paint()
        ..color = _crestColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(center.dx - 6, center.dy)
        ..quadraticBezierTo(
          center.dx,
          center.dy - 4,
          center.dx + 6,
          center.dy,
        );

      canvas.drawPath(path, closedPaint);
      return;
    }

    final irisPaint = Paint()..color = _eyeColor;
    final irisCenter = center + Offset(3 * math.sin(lookAngle), 0);
    canvas.drawCircle(irisCenter, 4.5, irisPaint);

    final pupilPaint = Paint()..color = _crestColor;
    canvas.drawCircle(irisCenter, 2, pupilPaint);

    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      irisCenter + const Offset(-1.5, -1.5),
      1.2,
      highlightPaint,
    );
  }

  void _drawMouth(
    Canvas canvas, {
    bool smile = true,
    bool open = false,
  }) {
    final mouthPaint = Paint()
      ..color = _crestColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (open) {
      final path = Path()
        ..moveTo(90, 82)
        ..quadraticBezierTo(100, 92, 110, 82);
      canvas.drawPath(path, mouthPaint);
    } else if (smile) {
      final path = Path()
        ..moveTo(93, 80)
        ..quadraticBezierTo(100, 86, 107, 80);
      canvas.drawPath(path, mouthPaint);
    } else {
      canvas.drawLine(
        const Offset(94, 82),
        const Offset(106, 82),
        mouthPaint,
      );
    }
  }

  void _drawPendant(Canvas canvas) {
    final pendantBg = Paint()..color = _bodyColor;
    final pendantStroke = Paint()
      ..color = _crestColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const center = Offset(100, 92);
    canvas
      ..drawCircle(center, 6, pendantBg)
      ..drawCircle(center, 6, pendantStroke);

    // White K.
    final kPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(
        center + const Offset(-2, -3),
        center + const Offset(-2, 3),
        kPaint,
      )
      ..drawLine(
        center + const Offset(-2, 0),
        center + const Offset(2, -3),
        kPaint,
      )
      ..drawLine(
        center + const Offset(-2, 0),
        center + const Offset(2, 3),
        kPaint,
      );
  }

  void _drawTail(
    Canvas canvas, {
    required bool curled,
    double tailAngle = 0,
    bool star = false,
    bool questionMark = false,
    bool rigid = false,
  }) {
    final tailPaint = Paint()
      ..color = _bodyColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (rigid) {
      path
        ..moveTo(126, 120)
        ..lineTo(170, 120);
    } else if (questionMark) {
      path
        ..moveTo(126, 120)
        ..cubicTo(150, 110, 160, 80, 145, 60)
        ..cubicTo(135, 48, 125, 55, 130, 65);
    } else if (curled) {
      path.moveTo(126, 120);
      var x = 126.0;
      var y = 120.0;
      var angle = tailAngle;
      var radius = 20.0;

      for (var i = 0; i < 12; i++) {
        angle += 0.5;
        radius *= 0.88;
        x += radius * math.cos(angle) * 0.5;
        y += radius * math.sin(angle) * 0.5 - 2;
        path.lineTo(x, y);
      }
    } else {
      path
        ..moveTo(126, 120)
        ..cubicTo(
          150,
          110 + tailAngle * 30,
          155,
          70 + tailAngle * 20,
          145,
          45,
        );
    }

    canvas.drawPath(path, tailPaint);

    if (star) {
      _drawStar(canvas, const Offset(145, 42), 6);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius) {
    final starPaint = Paint()..color = _eyeColor;
    final path = Path();

    for (var i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 5;

      final ox = center.dx + radius * math.cos(outerAngle);
      final oy = center.dy + radius * math.sin(outerAngle);
      final ix = center.dx + radius * 0.4 * math.cos(innerAngle);
      final iy = center.dy + radius * 0.4 * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, starPaint);
  }

  void _drawBodyMarkings(Canvas canvas) {
    final markPaint = Paint()
      ..color = _markingsColor.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Left shoulder — Ndebele concentric angular shape.
    final leftMark = Path()
      ..moveTo(76, 100)
      ..lineTo(70, 106)
      ..lineTo(76, 112)
      ..lineTo(82, 106)
      ..close();
    canvas.drawPath(leftMark, markPaint);

    // Right shoulder.
    final rightMark = Path()
      ..moveTo(124, 100)
      ..lineTo(118, 106)
      ..lineTo(124, 112)
      ..lineTo(130, 106)
      ..close();
    canvas.drawPath(rightMark, markPaint);
  }

  void _drawSparkles(Canvas canvas) {
    final sparkleColors = [_bodyColor, _eyeColor, _accentBlue, Colors.white];

    const positions = [
      Offset(30, 35),
      Offset(60, 20),
      Offset(150, 25),
      Offset(170, 50),
      Offset(40, 130),
      Offset(165, 120),
      Offset(25, 80),
      Offset(175, 80),
    ];

    for (var i = 0; i < positions.length; i++) {
      final color = sparkleColors[i % sparkleColors.length];
      final size = 3.0 + (i % 3) * 2;
      final paint = Paint()..color = color;

      if (i % 3 == 0) {
        final path = Path()
          ..moveTo(positions[i].dx, positions[i].dy - size)
          ..lineTo(positions[i].dx + size * 0.6, positions[i].dy)
          ..lineTo(positions[i].dx, positions[i].dy + size)
          ..lineTo(positions[i].dx - size * 0.6, positions[i].dy)
          ..close();
        canvas.drawPath(path, paint);
      } else if (i % 3 == 1) {
        canvas.drawCircle(positions[i], size * 0.5, paint);
      } else {
        final path = Path()
          ..moveTo(positions[i].dx, positions[i].dy - size)
          ..lineTo(
            positions[i].dx + size * 0.7,
            positions[i].dy + size * 0.5,
          )
          ..lineTo(
            positions[i].dx - size * 0.7,
            positions[i].dy + size * 0.5,
          )
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawWarningTriangles(Canvas canvas) {
    final warningPaint = Paint()..color = _eyeColor.withValues(alpha: 0.6);

    const positions = [
      Offset(45, 55),
      Offset(160, 60),
      Offset(50, 140),
      Offset(155, 135),
    ];

    for (final pos in positions) {
      final path = Path()
        ..moveTo(pos.dx, pos.dy - 6)
        ..lineTo(pos.dx + 5, pos.dy + 4)
        ..lineTo(pos.dx - 5, pos.dy + 4)
        ..close();
      canvas.drawPath(path, warningPaint);
    }
  }

  @override
  bool shouldRepaint(covariant KaiPainter oldDelegate) =>
      pose != oldDelegate.pose || colorTint != oldDelegate.colorTint;
}
