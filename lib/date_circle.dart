import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' show radians;

/// A widget maintaining the drawn circle with [CustomPainter]
///
/// The [height] and [width] are used for the diameter of the circle.
/// [value] indicates the current state of the circle and must be between [min] and [max], where [max] is a full circle (360°).
class DateCircle extends StatelessWidget {
  /// [value] must be between [min] and [max].
  /// [color], [width], [height], [min], [max], [value] must not be null.
  const DateCircle({
    @required this.color,
    @required this.textColor,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.min,
    @required this.max,
    @required this.value,
  })  : assert(color != null),
        assert(width != null),
        assert(height != null),
        assert(min != null),
        assert(max != null),
        assert(value != null),
        assert(value <= max, "value out of range!"),
        assert(value >= min, "value out of range!");

  /// The vertical diameter of the circle.
  final double height;

  /// The horizontal diameter of the circle.
  final double width;

  /// The [Color] of the circle.
  final Color color;

  /// Equals 0° of the circle.
  final int min;

  /// Equals 360° of the circle.
  final int max;

  /// Indicats the current state of the circle.
  final int value;

  /// The [Color] which is drawn at the end of the circle.
  final Color textColor;

  /// The text, which is drawn at the end of the circle.
  final String text;

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

/// [CustomPainter] that draws a circle with custom [color] and [text].
class _StaticCirclePainter extends CustomPainter {
  /// Create a const [CustomPainter].
  const _StaticCirclePainter({
    @required this.color,
    @required this.text,
    @required this.min,
    @required this.max,
    @required this.value,
    @required this.textColor,
  })  : assert(color != null),
        assert(min != null),
        assert(max != null),
        assert(value != null),
        assert(value <= max, "value out of range!"),
        assert(value >= min, "value out of range!");

  final Color color;
  final Color textColor;
  final String text;
  final int min;
  final int max;
  final int value;

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

    if (text == null) {
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
    final radiansPerStep = radians(360 / max);

    // Save the current canvas state.
    canvas.save();

    // Call layout to compute the textPainter width and height.
    textPainter.layout();

    // Adjust x and y of the drawn text to prevent "overlapping-collision" between text and circle.
    var adjustY =
        textPainter.height * (0.5 - 0.5 * math.sin(value * radiansPerStep));
    var adjustX =
        textPainter.width * (0.5 - 0.5 * math.cos(value * radiansPerStep));

    // The last two steps overlap the circle.
    // Place them under 0°.
    if (value >= max - 1) {
      adjustY = 0;
      if (value == max) {
        adjustX = textPainter.width * 0.5;
      }
    }

    canvas.translate(
        origin.x +
            radius * math.cos(value * radiansPerStep - math.pi / 2) -
            adjustX,
        origin.y +
            radius * math.sin(value * radiansPerStep - math.pi / 2) -
            adjustY);

    textPainter.paint(canvas, Offset(0, 0));

    // Restore the old canvas state.
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StaticCirclePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.max != max ||
        oldDelegate.min != min ||
        oldDelegate.color != color ||
        oldDelegate.text != text ||
        oldDelegate.textColor != textColor;
  }
}
