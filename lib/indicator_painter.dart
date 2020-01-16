import 'package:analog_clock/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// Draws small indicators for every minute, starting at [circleExpand] to the end of the circle (360°, e.g.  60 minutes).
class IndicatorPainter extends CustomPainter {
  /// Create a const [CustomPainter]
  ///
  /// All of the parameters are required and must not be null.
  const IndicatorPainter({
    @required this.circleExpand,
    @required this.color,
  })  : assert(circleExpand != null),
        assert(color != null);

  /// The radians the circle has already progressed.
  final double circleExpand;

  /// The [Color] of the indicators.
  final Color color;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final fullMinutesPaint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // only draw the inidicators left to fill the circle.
    // with an offset of two (to prevent collision with minutes text)
    for (double value = circleExpand - math.pi * 0.5 + radiansPerTick * 2;
        value <= math.pi * 2 - math.pi * 0.5 + radiansPerTick * 2;
        value += radiansPerTick) {
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
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return oldDelegate.circleExpand != circleExpand ||
        oldDelegate.color != color;
  }
}
