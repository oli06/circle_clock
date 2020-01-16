import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// Maintains the drawn circle with [CustomPainter]
///
/// The [height] and [width] are used for the diameter of the circle.
class TimeCircle extends StatelessWidget {
  /// Create a const [TimeCircle].
  ///
  /// All of the parameters are required and must not be null.
  const TimeCircle({
    @required this.gradient,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.value,
    @required this.textColor,
  })  : assert(gradient != null),
        assert(width != null),
        assert(height != null),
        assert(text != null),
        assert(value != null),
        assert(textColor != null);

  /// The vertical diameter of the circle.
  final double height;

  /// The horizontal diameter of the circle.
  final double width;

  /// The radians of the circle (e.g. the minutes).
  final double value;

  /// The [LinearGradient] of the circle.
  final LinearGradient gradient;

  /// The text, which is drawn at the end of the circle.
  final String text;

  /// The [Color] which is drawn at the end of the circle.
  final Color textColor;

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

/// [CustomPainter] that draws a circle with custom [LinearGradient] and text / color.
class _CirclePainter extends CustomPainter {
  /// Create a const [CustomPainter].
  const _CirclePainter({
    @required this.value,
    @required this.gradient,
    @required this.text,
    @required this.textColor,
  })  : assert(gradient != null),
        assert(text != null),
        assert(value != null),
        assert(textColor != null);

  final LinearGradient gradient;
  final double value;
  final String text;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    final radius = size.width * 0.5;

    circlePaint.shader = gradient
        .createShader(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    // draw the circle, starting at the top
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

    // Save the current canvas state.
    canvas.save();

    // Call layout to compute the textPainter width and height.
    textPainter.layout();

    // Adjust x and y of the drawn text to prevent "overlapping-collision" between text and circle.
    var adjustY = textPainter.height * (0.5 - 0.5 * math.sin(value));
    final adjustX = textPainter.width * (0.5 - 0.5 * math.cos(value));

    // minute 59' would overlapwith the circle.
    // Place 59' under the top of the circle.
    if (minute == 59) {
      adjustY = 0;
    }

    final x =
        size.width * 0.5 + radius * (math.cos(value - math.pi / 2)) - adjustX;
    final y =
        size.height * 0.5 + radius * math.sin(value - math.pi / 2) - adjustY;

    canvas.translate(x, y);

    textPainter.paint(canvas, Offset(0, 0));

    // Restore the old canvas state.
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.gradient != gradient ||
        oldDelegate.text != text ||
        oldDelegate.textColor != textColor;
  }
}
