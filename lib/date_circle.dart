import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' show radians;

class DateCircle extends StatelessWidget {
  const DateCircle({
    @required this.color,
    @required this.textColor,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.min,
    @required this.max,
    @required this.value,
  });

  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final String text;
  final int min;
  final int max;
  final int value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _StaticCirclePainter(
        color: color,
        textColor: textColor,
        text: text,
        value: value,
        min: min,
        max: max,
      ),
    );
  }
}

class _StaticCirclePainter extends CustomPainter {
  _StaticCirclePainter({
    @required this.color,
    @required this.text,
    @required this.min,
    @required this.max,
    @required this.value,
    @required this.textColor,
  });

  final Color color;
  final Color textColor;
  final String text;

  final int min;
  final int max;
  final int value;

  double get quarter => max / 4;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.5;
    final origin = math.Point(size.width * 0.5, size.height * 0.5);

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 9;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      value * radians(360 / max),
      false,
      circlePaint,
    );

    final textStyle = TextStyle(
      color: textColor,
      fontSize: 36,
      fontWeight: FontWeight.w300,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    canvas.save();

    textPainter.layout();
    var adjustY =
        textPainter.height * (0.5 - 0.5 * math.sin(value * radians(360 / max)));
    var adjustX =
        textPainter.width * (0.5 - 0.5 * math.cos(value * radians(360 / max)));
    if (value >= max - 1) {
      adjustY = 0;
      if (value == max) {
        adjustX = textPainter.width * 0.5;
      }
    }
    canvas.translate(
        origin.x +
            radius * math.cos(value * radians(360 / max) - math.pi / 2) -
            adjustX,
        origin.y +
            radius * math.sin(value * radians(360 / max) - math.pi / 2) -
            adjustY);
    textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StaticCirclePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.max != max ||
        oldDelegate.min != min;
  }
}
