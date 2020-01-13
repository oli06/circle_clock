import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class CirclePainter extends CustomPainter {
  final double value;
  final LinearGradient gradient;
  final String textValue;

  CirclePainter(this.value, this.gradient, this.textValue);

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

    final textStyle = TextStyle(
        color: Colors.black, fontSize: 32, fontWeight: FontWeight.w300);
    final textSpan = TextSpan(text: textValue, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    canvas.save();

    final minute = int.tryParse(textValue);
    if (minute == null) {
      return;
    }

    //TODO: better calculation (including text size)!
    //compute the radians based on the current minute added by 2.5
    //to prevent collision with the circle
    num radians = 0;
    if (minute >= 58) {
      //57th minute looks great
      radians = value - 0.5 * math.pi;
    } else if (minute == 0) {
      //cant divide by zero
      return;
    } else {
      radians = (minute + 2.5) * value / minute - 0.5 * math.pi;
    }

    canvas.translate(size.width * 0.5 + radius * math.cos(radians),
        size.height * 0.5 + radius * math.sin(radians));

    textPainter.layout();

    textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
