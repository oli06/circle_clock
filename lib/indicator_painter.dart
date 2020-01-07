import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class IndicatorPainter extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final fullMinutesPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawLine(
        Offset(
            math.cos(-45 * math.pi / 180) * size.width * 0.5 + size.width * 0.5,
            math.sin(-45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 +
                4),
        Offset(
            math.cos(-45 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(-45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        fullMinutesPaint);

    canvas.drawLine(
        Offset(
            math.cos(135 * math.pi / 180) * size.width * 0.5 + size.width * 0.5,
            math.sin(135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 +
                4),
        Offset(
            math.cos(135 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        fullMinutesPaint);

    canvas.drawLine(
        Offset(
            math.cos(45 * math.pi / 180) * size.width * 0.5 + size.width * 0.5,
            math.sin(45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 -
                4),
        Offset(
            math.cos(45 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        fullMinutesPaint);

    canvas.drawLine(
        Offset(
            math.cos(-135 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5,
            math.sin(-135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        Offset(
            math.cos(-135 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(-135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 +
                4),
        fullMinutesPaint);

    canvas.drawLine(Offset(size.width - 4, size.height / 2),
        Offset(size.width, size.height / 2), fullMinutesPaint);

    canvas.drawLine(Offset(size.width / 2, size.height - 4),
        Offset(size.width / 2, size.height), fullMinutesPaint);

    canvas.drawLine(Offset(0, size.height / 2), Offset(4, size.height / 2),
        fullMinutesPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
