import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class TimeCircle extends StatelessWidget {
  const TimeCircle({
    @required this.gradient,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.value,
    @required this.textColor,
  });

  final double width;
  final Color textColor;
  final double height;
  final LinearGradient gradient;
  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _CirclePainter(
        text: text,
        textColor: textColor,
        value: value,
        gradient: gradient,
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double value;
  final LinearGradient gradient;
  final String text;
  final Color textColor;

  _CirclePainter({
    @required this.value,
    @required this.gradient,
    @required this.text,
    @required this.textColor,
  });

  final circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 9;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.5;

    circlePaint.shader = gradient
        .createShader(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      value,
      false,
      circlePaint,
    );

    final minute = int.tryParse(text);
    if (minute == null || minute == 0) {
      return;
    }

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

    var adjustY = textPainter.height * (0.5 - 0.5 * math.sin(value));
    final adjustX = textPainter.width * (0.5 - 0.5 * math.cos(value));

    if (minute == 59) {
      adjustY = 0;
    }

    final x =
        size.width * 0.5 + radius * (math.cos(value - math.pi / 2)) - adjustX;
    final y =
        size.height * 0.5 + radius * math.sin(value - math.pi / 2) - adjustY;

    canvas.translate(x, y);

    textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
