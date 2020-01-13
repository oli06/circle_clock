import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class DateCircle extends StatelessWidget {
  const DateCircle({
    @required this.color,
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
  });

  final Color color;
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
      math.pi * 2 * value / max,
      false,
      circlePaint,
    );

    final textStyle = TextStyle(
        color: Colors.black, fontSize: 28, fontWeight: FontWeight.w300);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    canvas.save();

    canvas.translate(
        origin.x + radius * math.cos(-2 / max * math.pi * (quarter - value)),
        origin.y + radius * math.sin(-2 / max * math.pi * (quarter - value)));

    textPainter.layout();

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
