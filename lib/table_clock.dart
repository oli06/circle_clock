// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flare_flutter/flare_actor.dart';

import 'container_hand.dart';
import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);
final hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

/// A basic analog clock.
///
/// You can do better than this!
class TableClock extends StatefulWidget {
  const TableClock(this.model);

  final ClockModel model;

  @override
  _TableClockState createState() => _TableClockState();
}

class _TableClockState extends State<TableClock> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _secondsAnimationController;
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(minutes: 60), value: _now.minute / 60);
    _secondsAnimationController = AnimationController(
        vsync: this, duration: Duration(seconds: 60), value: _now.second / 60);

    //_animationController.forward();
    _animationController.repeat();
    _secondsAnimationController.repeat();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(TableClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _secondsAnimationController.dispose();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [TableClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Colors.green,
            // Minute hand.
            highlightColor: Color(0xFF8AB4F8),
            // Second hand.
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFD2E3FC),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    final isPm = _now.hour > 12;
    var currentHour = _now.hour;
    if (isPm) {
      currentHour = currentHour - 12;
    }

    /*final minuteContent = Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        CustomPaint(
          painter: MinutePainter(_animationController),
          size: MediaQuery.of(context).size,
        ),
        CustomPaint(
            painter: SecondPainter(_secondsAnimationController),
            size: MediaQuery.of(context).size),
        Text(
          stringMinutes[_now.minute].toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 30,
          ),
        ),
      ],
    );*/

    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: _now.hour.toString(),
        style: TextStyle(fontSize: 140, fontWeight: FontWeight.w200),
      ),
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(BoxConstraints());
    double textWidth = renderParagraph.getMinIntrinsicWidth(120).ceilToDouble();
    double textHeight =
        renderParagraph.getMinIntrinsicHeight(120).ceilToDouble();

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Center(
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            _now.hour.toString(),
            style: TextStyle(fontSize: 140, fontWeight: FontWeight.w200),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25 + textHeight * 0.3,
            left: MediaQuery.of(context).size.height * 0.25 - textWidth * 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: FlareActor("assets/rain.flr",
                      animation: "Untitled", color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Text(
                    _temperature,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: IndicatorPainter(),
            size: Size(MediaQuery.of(context).size.height * 0.5,
                MediaQuery.of(context).size.height * 0.5),
          ),
          CustomPaint(
            painter: CirclePainter(_animationController),
            size: Size(MediaQuery.of(context).size.height * 0.5,
                MediaQuery.of(context).size.height * 0.5),
          ),
        ],
      )),
    );
  }
}

class SecondPainter extends CustomPainter {
  final Animation<double> _animation;

  SecondPainter(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4;
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          0,
          size.height - 16,
          _animation.value * size.width,
          size.height - 14,
          topLeft: Radius.circular(2),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  final Animation<double> _animation;

  CirclePainter(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xff2196F3),
        Color(0xff4CAF50),
        Color(0xffFFEB3B),
        Color(0xffFF5722),
        Color(0xffE91E63),
        Color(0xff9E9E9E),
      ],
    );

    circlePaint.shader = gradient
        .createShader(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      math.pi * 2 * _animation.value,
      false,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class IndicatorPainter extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final fullMinutesPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawLine(
        Offset(
            math.cos(-45 * math.pi / 180) * size.width * 0.5 + size.width * 0.5,
            math.sin(-45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 +
                4),
        Offset(
            math.cos(-45 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(-45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        fullMinutesPaint);

    canvas.drawLine(Offset(size.width - 5, size.height / 2),
        Offset(size.width, size.height / 2), fullMinutesPaint);

    canvas.drawLine(
        Offset(
            math.cos(135 * math.pi / 180) * size.width * 0.5 + size.width * 0.5,
            math.sin(135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 +
                4),
        Offset(
            math.cos(135 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        fullMinutesPaint);

    canvas.drawLine(
        Offset(
            math.cos(45 * math.pi / 180) * size.width * 0.5 + size.width * 0.5,
            math.sin(45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 -
                4),
        Offset(
            math.cos(45 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(45 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        fullMinutesPaint);

    canvas.drawLine(
        Offset(
            math.cos(-135 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5,
            math.sin(-135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5),
        Offset(
            math.cos(-135 * math.pi / 180) * size.width * 0.5 +
                size.width * 0.5 +
                4,
            math.sin(-135 * math.pi / 180) * size.height * 0.5 +
                size.height * 0.5 +
                4),
        fullMinutesPaint);

    canvas.drawLine(Offset(size.width / 2, size.height - 5),
        Offset(size.width / 2, size.height), fullMinutesPaint);

    canvas.drawLine(Offset(0, size.height / 2), Offset(5, size.height / 2),
        fullMinutesPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

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
