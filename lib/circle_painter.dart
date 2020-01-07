import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class CirclePainter extends CustomPainter {
  final Animation<double> _animation;
  final LinearGradient gradient;
  final String textValue;

  CirclePainter(this._animation, this.gradient, this.textValue)
      : super(repaint: _animation);

  final circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 9;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.5;
    final origin = math.Point(size.width * 0.5, size.height * 0.5);

    circlePaint.shader = gradient
        .createShader(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      math.pi * 2 * _animation.value,
      false,
      circlePaint,
    );

    final textStyle = TextStyle(color: Colors.black, fontSize: 24);
    final textSpan = TextSpan(
        text: (_animation.value * 60).toStringAsFixed(0), style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    canvas.save();

    if (_animation.value < 0.25) {
      canvas.translate(
          origin.x +
              radius *
                  math.cos(-360 * (0.25 - _animation.value) * math.pi / 180) +
              10,
          origin.y +
              radius *
                  math.sin(-360 * (0.25 - _animation.value) * math.pi / 180) +
              10);
      canvas.rotate(math.pi * _animation.value * 2);
    } else if (_animation.value < 0.5) {
      canvas.translate(
          origin.x +
              radius *
                  math.cos(360 * (0.25 - _animation.value) * math.pi / 180) +
              10,
          origin.y +
              radius *
                  math.sin(360 * (0.75 - _animation.value) * math.pi / 180) +
              10);
      canvas.rotate(-math.pi * _animation.value * 2);
    } else if (_animation.value < 0.75) {
      canvas.translate(
          origin.x +
              radius *
                  math.cos(360 * (0.25 - _animation.value) * math.pi / 180) -
              10,
          origin.y +
              radius *
                  math.sin(360 * (0.75 - _animation.value) * math.pi / 180) +
              10);
      canvas.rotate(-math.pi * _animation.value * 2);
    } else if (_animation.value < 1) {
      canvas.translate(
          origin.x +
              radius *
                  math.cos(-360 * (0.25 - _animation.value) * math.pi / 180) -
              10,
          origin.y +
              radius *
                  math.sin(-360 * (0.25 - _animation.value) * math.pi / 180) -
              10);
      canvas.rotate(math.pi * _animation.value * 2);
    }

    textPainter.layout();

    textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
