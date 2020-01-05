// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:developer';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'container_hand.dart';
import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);
final hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
final stringHours = [
  "Null",
  "Eins",
  "Zwei",
  "Drei",
  "Vier",
  "Fünf",
  "Sechs",
  "Sieben",
  "Acht",
  "Neun",
  "Zehn",
  "Elf",
];
final stringMinutes = [
  "Null",
  "Eins",
  "Zwei",
  "Drei",
  "Vier",
  "Fünf",
  "Sechs",
  "Sieben",
  "Acht",
  "Neun",
  "Zehn",
  "Elf",
  "Zwölf",
  "Dreizehn",
  "Vierzehn",
  "Fünfzehn",
  "Sechzehn",
  "Siebzehn",
  "Achtzehn",
  "Neunzehn",
  "Zwanzig",
  "Einundzwanzig",
  "Zweiundzwanzig",
  "Dreiundzwanzig",
  "Vierundzwanzig",
  "Fünfundzwanzig",
  "Sechsundzwanzig",
  "Siebenundzwanzig",
  "Achtundzwanzig",
  "Neunundzwanzig",
  "Dreißig",
  "Einundreißig",
  "Zweiunddreißig",
  "Dreiunddreißig",
  "Vierunddreißig",
  "Fünfunddreißig",
  "Sechsunddreißig",
  "Siebenunddreißig",
  "Achtunddreißig",
  "Neununddreißig",
  "Vierzig",
  "Einundvierzig",
  "Zweiundvierzig",
  "Dreiundvierzig",
  "Vierundvierzig",
  "Fünfundvierzig",
  "Sechsundvierzig",
  "Siebenundvierzig",
  "Achtundvierzig",
  "Neunundvierzig",
  "Fünfzig",
  "Einundfünfzig",
  "Zweiundfünfzig",
  "Dreiundfünfzig",
  "Vierundfünfzig",
  "Fünfundfünzig",
  "Sechsundfünfzig",
  "Siebenundfünfzig",
  "Achtundfünfzig",
  "Neunundfünfzig",
];

final stringTenMinutes = [
  "Zehn","Zwanzig","Dreißig","Vierzig","Fünfzig",
];

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

    final minuteContent = Stack(
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
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: hours.reversed.map((h) {
                      TextPainter _painter;
                      if (currentHour == h) {
                        _painter = TextPainter(
                            text: TextSpan(
                                text: stringHours[currentHour].toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 26,
                                )),
                            textDirection: ui.TextDirection.rtl);
                        // Call layout method so width and height of this text widget get measured
                        _painter.layout();
                      }

                      return Expanded(
                        child: Container(
                          decoration: currentHour == h
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Color(0xffB85B00)),
                                )
                              : null,
                          constraints: BoxConstraints.expand(),
                          child: Center(
                            child: currentHour == h
                                ? CustomPaint(
                                    size: _painter.size,
                                    painter: _GradientTextPainter(
                                      text: stringHours[h].toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 26,
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          Color(0xFFF4D467),
                                          Color(0xFFCB6A00)
                                        ],
                                      ),
                                    ),
                                  )
                                : Text(
                                    stringHours[h].toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 26,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
            VerticalDivider(
              width: 1,
              endIndent: MediaQuery.of(context).size.height / 12 * currentHour,
            ),
            VerticalDivider(
              width: 1,
              indent:
                  MediaQuery.of(context).size.height / 12 * (currentHour + 1),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: hours.reversed
                      .map(
                        (h) => Expanded(
                          child: Container(
                            decoration: currentHour == h
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border:
                                        Border.all(color: Color(0xffB85B00)),
                                  )
                                : null,
                            child:
                                currentHour == h ? minuteContent : Container(),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MinutePainter extends CustomPainter {
  final Animation<double> _animation;

  MinutePainter(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4;
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(size.width - _animation.value * size.width,
            size.height * 0.6, size.width, size.height,
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SecondPainter extends CustomPainter {
  final Animation<double> _animation;

  SecondPainter(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 4;
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(size.width - _animation.value * size.width,
            size.height - 3, size.width, size.height,
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
