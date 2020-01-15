// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/clock_widget.dart';
import 'package:analog_clock/date_widget.dart';
import 'package:analog_clock/utils.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

class TableClock extends StatefulWidget {
  const TableClock(this.model);

  final ClockModel model;

  @override
  _TableClockState createState() => _TableClockState();
}

class _TableClockState extends State<TableClock> with TickerProviderStateMixin {
  var _now = DateTime.now();
  var _temperature = '';
  var _condition = '';

  var minuteSimulator = 0;

  var _weatherGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xff2196F3), //INVERTED for DARK MODE: 0xffde690c
      //Color(0xff4CAF50),
      //Color(0xffFFEB3B),
      //Color(0xffFF5722),
      Color(0xffE91E63), //INVERTED for DARK MODE: 0xff16e19c
      //Color(0xff9E9E9E),
    ],
  );
  Timer _timer;

  @override
  void initState() {
    super.initState();
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
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;

      //setting the color gradient based on the highest and lowest temperature
      final highestOpacityPercentage =
          getHighestOpacityPercentage(round(widget.model.high.round()));
      final lowestOpacityPercentage =
          getLowestOpacityPercentage(round(widget.model.low.round()));

      List<Color> weatherColors = [];
      weatherColors.add(
        Color(0xff2196F3).withOpacity(lowestOpacityPercentage),
      );
      weatherColors.add(
        Color(0xffE91E63).withOpacity(highestOpacityPercentage),
      );

      _weatherGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: weatherColors,
      );

      _condition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      //minuteSimulator += 1;

      _now = DateTime.now()
          .add(Duration(minutes: minuteSimulator, days: minuteSimulator));
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
    final theme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            canvasColor: Color(0xff8a8a8a),
          )
        : Theme.of(context).copyWith(
            canvasColor: Color(0xff757575),
          );

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Circle clock with time $time',
        value: time,
      ),
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ClockWidget(
                date: _now,
                gradient: _weatherGradient,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.height * 0.5,
                model: widget.model,
                indicatorsColor: theme.canvasColor,
                textColor: theme.textTheme.body1.color,
              ),
              DateWidget(
                date: _now,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.height * 0.25,
                textColor: theme.textTheme.body1.color,
                circleColor: theme.canvasColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
