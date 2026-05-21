import 'dart:math' as math;

import 'package:flutter/material.dart';

class ThermostatPainter extends CustomPainter {
  ThermostatPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  final double progress;
  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 16;

    // Define open circle logic: start lower left (-220 degrees), open space at base
    const startAngle = 3 * math.pi / 4;
    const totalSweepAngle = 3 * math.pi / 2;
    final currentSweepAngle = totalSweepAngle * progress.clamp(0.0, 1.0);

    // Base background track painting
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweepAngle,
      false,
      trackPaint,
    );

    // Glow Effect Layer underneath active line
    final glowPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..imageFilter = const ColorFilter.mode(Colors.transparent, BlendMode.srcOver)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentSweepAngle,
      false,
      glowPaint,
    );

    // Active progress arc painting
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentSweepAngle,
      false,
      activePaint,
    );

    // End Thumb handle circle positioning
    final thumbAngle = startAngle + currentSweepAngle;
    final thumbCenter = Offset(
      center.dx + radius * math.cos(thumbAngle),
      center.dy + radius * math.sin(thumbAngle),
    );

    final thumbPaint = Paint()..color = Colors.white;
    canvas.drawCircle(thumbCenter, 10, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant ThermostatPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.activeColor != activeColor || oldDelegate.trackColor != trackColor;
  }
}
