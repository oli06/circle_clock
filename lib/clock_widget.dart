import 'dart:developer';

import 'package:analog_clock/indicator_painter.dart';
import 'package:analog_clock/time_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flare_flutter/flare_actor.dart';

class ClockWidget extends StatelessWidget {
  final radiansPerTick = radians(360 / 60);
  final double height;
  final double width;
  final DateTime date;
  final ClockModel model;
  final LinearGradient gradient;

  ClockWidget({
    Key key,
    @required this.height,
    @required this.width,
    @required this.date,
    @required this.gradient,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPm = date.hour > 12;

    String hourString = "";
    String timeIndicator = "";

    if (model.is24HourFormat) {
      hourString = date.hour.toString();
    } else {
      if (isPm) {
        hourString = (date.hour - 12).toString();
        timeIndicator = "pm";
      } else {
        hourString = date.hour.toString();
        timeIndicator = "am";
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              hourString,
              style: TextStyle(fontSize: 140, fontWeight: FontWeight.w200),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                timeIndicator,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 245,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  "assets/thunder.png",
                ),
              ),

              /*Container(
                        height: 50,
                        width: 50,
                        child: FlareActor("assets/rain.flr",
                            animation: "Untitled", color: Colors.black),
                      ),*/
              Text(
                model.temperatureString,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
              ),
              model.low < 0
                  ? Container(
                      height: 50,
                      width: 50,
                      child: FlareActor(
                        "assets/rain.flr",
                        animation: "FREEZING COLD",
                        color: Colors.black,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        CustomPaint(
          painter: IndicatorPainter(),
          size: Size(width, height),
        ),
        TimeCircle(
          height: height,
          width: width,
          gradient: gradient,
          value: radiansPerTick * date.minute,
          text: date.minute.toString(),
        )
      ],
    );
  }
}
