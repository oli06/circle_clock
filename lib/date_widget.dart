import 'package:analog_clock/date_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'utils.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key key,
    @required this.date,
    @required this.height,
    @required this.width,
    @required this.textColor,
    @required this.circleColor,
  }) : super(key: key);

  final double height;
  final double width;
  final DateTime date;

  final Color textColor;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        DateCircle(
            color:
                circleColor, //Color(0xff8a8a8a), //INVERTED COLOR: 0xff757575
            textColor: textColor,
            min: 1,
            value: date.day,
            max: lastDayOfMonth(date),
            text: date.day.toString(),
            height: height,
            width: width),
        Text(
          date.month.toString(),
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w200,
          ),
        ),
        Positioned(
          top: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Text(
                  DateFormat('yyyy').format(date),
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
