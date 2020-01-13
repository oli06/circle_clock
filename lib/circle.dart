import 'package:analog_clock/circle_painter.dart';
import 'package:analog_clock/indicator_painter.dart';
import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  final double width;
  final double height;

  final LinearGradient gradient;
  final bool showIndicators;
  final List<Widget> content;
  final String circleLineContent;
  final double value;

  Circle({
    Key key,
    this.width,
    this.height,
    this.gradient,
    this.circleLineContent,
    this.content,
    this.showIndicators = false,
    this.value,
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
          size: Size(widget.width, widget.height),
        ),
      );
    }
    children.add(
      CustomPaint(
        painter: CirclePainter(
            widget.value, widget.gradient, widget.circleLineContent),
        size: Size(widget.width, widget.height),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: children,
    );
  }
}