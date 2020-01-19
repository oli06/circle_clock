import 'package:analog_clock/date_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'utils.dart';

/// A widget which maintains and shows date information based on [date]
///
/// The date information is surrounded by a circle drawn with [CustomPainter]
class DateWidget extends StatelessWidget {
  /// Create a const [DateWidget].
  ///
  /// All of the parameters are required and must not be null.
  const DateWidget({
    Key key,
    @required this.date,
    @required this.height,
    @required this.width,
    @required this.textColor,
    @required this.circleColor,
  })  : assert(date != null),
        assert(height != null),
        assert(width != null),
        assert(textColor != null),
        assert(circleColor != null),
        super(key: key);

  /// The vertical diameter of the circle.
  final double height;

  /// The horizontal diameter of the circle.
  final double width;

  /// The date information is based on this [DateTime] object.
  final DateTime date;

  /// The [Color], which is used for text on the circle´s edge.
  final Color textColor;

  /// The [Color] of the circle.
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        DateCircle(
            color: circleColor,
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
