import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FanPainter extends CustomPainter {
  FanPainter({
    required this.activeColor,
    required this.trackColor,
  });

  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final hubRadius = radius * 0.12;
    final bladeLength = radius * 0.45;
    final bladeWidth = radius * 0.18;

    for (var i = 0; i < 3; i++) {
      final angle = i * 2 * math.pi / 3;
      _drawBlade(canvas, center, angle, bladeLength, bladeWidth, trackColor.withValues(alpha: 0.3));
    }

    for (var i = 0; i < 3; i++) {
      final angle = i * 2 * math.pi / 3;
      _drawBlade(canvas, center, angle, bladeLength, bladeWidth, activeColor);
    }

    _drawHub(canvas, center, hubRadius);
  }

  void _drawBlade(Canvas canvas, Offset center, double angle, double length, double width, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);

    final tipX = center.dx + length * cosA;
    final tipY = center.dy + length * sinA;

    final perpX = -sinA;
    final perpY = cosA;

    final startX = center.dx + (length * 0.08) * cosA;
    final startY = center.dy + (length * 0.08) * sinA;

    final cp1X = center.dx + (length * 0.35) * cosA + perpX * width * 0.7;
    final cp1Y = center.dy + (length * 0.35) * sinA + perpY * width * 0.7;

    final cp2X = center.dx + (length * 0.7) * cosA + perpX * width * 0.5;
    final cp2Y = center.dy + (length * 0.7) * sinA + perpY * width * 0.5;

    final cp3X = center.dx + (length * 0.7) * cosA - perpX * width * 0.3;
    final cp3Y = center.dy + (length * 0.7) * sinA - perpY * width * 0.3;

    final cp4X = center.dx + (length * 0.35) * cosA - perpX * width * 0.4;
    final cp4Y = center.dy + (length * 0.35) * sinA - perpY * width * 0.4;

    path.moveTo(startX, startY);
    path.cubicTo(cp1X, cp1Y, cp2X, cp2Y, tipX, tipY);
    path.cubicTo(cp3X, cp3Y, cp4X, cp4Y, startX, startY);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawHub(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, radius * 1.8, glowPaint);

    final hubPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [activeColor.withValues(alpha: 0.9), activeColor.withValues(alpha: 0.6)],
      );
    canvas.drawCircle(center, radius, hubPaint);

    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawCircle(center, radius * 0.35, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant FanPainter oldDelegate) {
    return oldDelegate.activeColor != activeColor || oldDelegate.trackColor != trackColor;
  }
}
