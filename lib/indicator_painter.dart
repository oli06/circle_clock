import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:developer';

class IndicatorPainter extends CustomPainter {
  final double circleExpand;
  final Color color;

  IndicatorPainter({
    @required this.circleExpand,
    @required this.color,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final fullMinutesPaint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final radiansPerMinute = radians(360 / 60);
    log("repaint");
    //only draw the inidicators left to fill the circle.
    //with an offset of two (to prevent collision with minutes text)
    for (double value = circleExpand - math.pi * 0.5 + radiansPerMinute * 2;
        value <= math.pi * 2 - math.pi * 0.5 + radiansPerMinute * 2;
        value += radiansPerMinute) {
      canvas.drawLine(
          Offset(
              math.cos(value) * size.width * 0.5 +
                  size.width * 0.5 -
                  4 * math.cos(value),
              math.sin(value) * size.height * 0.5 +
                  size.height * 0.5 -
                  4 * math.sin(value)),
          Offset(
              math.cos(value) * size.width * 0.5 +
                  size.width * 0.5 +
                  (4 * math.cos(value)),
              math.sin(value) * size.height * 0.5 +
                  size.height * 0.5 +
                  4 * math.sin(value)),
          fullMinutesPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
