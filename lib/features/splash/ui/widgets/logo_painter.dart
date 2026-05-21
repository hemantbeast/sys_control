import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sys_control/app/themes/colors.dart';

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dot = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: size.width, height: size.height),
      pi * 0.75,
      pi * 1.5,
      false,
      stroke,
    );

    canvas.drawPath(
      Path()
        ..moveTo(cx + 2, cy - 7)
        ..lineTo(cx - 4, cy)
        ..lineTo(cx + 4, cy)
        ..lineTo(cx - 2, cy + 7),
      stroke,
    );

    canvas.drawCircle(Offset(cx + 2, cy - 7), 2.2, dot);
    canvas.drawCircle(Offset(cx - 2, cy + 7), 2.2, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
