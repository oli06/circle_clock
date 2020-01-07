import 'package:analog_clock/circle_painter.dart';
import 'package:analog_clock/indicator_painter.dart';
import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  final double width;
  final double height;

  final LinearGradient gradient;
  final AnimationController animationController;
  final bool showIndicators;
  final List<Widget> content;
  final String circleLineContent;

  Circle({
    Key key,
    this.width,
    this.height,
    this.gradient,
    this.animationController,
    this.circleLineContent,
    this.content,
    this.showIndicators = false,
  }) : super(key: key);

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    final children = widget.content;

    if (widget.showIndicators) {
      children.add(
        CustomPaint(
          painter: IndicatorPainter(),
          size: Size(MediaQuery.of(context).size.height * 0.5,
              MediaQuery.of(context).size.height * 0.5),
        ),
      );
    }
    children.add(
      CustomPaint(
        painter: CirclePainter(widget.animationController, widget.gradient,
            widget.circleLineContent),
        size: Size(MediaQuery.of(context).size.height * 0.5,
            MediaQuery.of(context).size.height * 0.5),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: children,
    );
  }
}
/*
class _GradientTextPainter extends CustomPainter {
  final Gradient gradient;
  final String text;
  final TextStyle style;

  _GradientTextPainter(
      {Listenable repaint,
      @required this.text,
      @required this.style,
      @required this.gradient})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _gradientShaderPaint = new Paint()
      ..shader = gradient
          .createShader(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final ui.ParagraphBuilder _builder =
        new ui.ParagraphBuilder(ui.ParagraphStyle())
          ..pushStyle(new ui.TextStyle(
            foreground: _gradientShaderPaint,
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            height: style.height,
            decoration: style.decoration,
            decorationColor: style.decorationColor,
            decorationStyle: style.decorationStyle,
            fontStyle: style.fontStyle,
            letterSpacing: style.letterSpacing,
            fontFamily: style.fontFamily,
            locale: style.locale,
            textBaseline: style.textBaseline,
            wordSpacing: style.wordSpacing,
          ))
          ..addText(text);

    final ui.Paragraph _paragraph = _builder.build();
    _paragraph.layout(new ui.ParagraphConstraints(width: size.width));

    canvas.drawParagraph(_paragraph, Offset.zero);
  }

  @override
  bool shouldRepaint(_GradientTextPainter oldDelegate) {
    return gradient != oldDelegate.gradient ||
        text != oldDelegate.text ||
        style != oldDelegate.style;
  }
}
*/
