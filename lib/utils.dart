import 'package:vector_math/vector_math_64.dart' show radians;

/// Rounds an integer to the closest multiple of 5.
///
/// For example:
///   19 -> 20
///   17 -> 15
int round(int number) {
  int temp = number % 5;
  if (temp < 3) {
    return number - temp;
  } else {
    return number + 5 - temp;
  }
}

/// Calculates the last day of the given month
int lastDayOfMonth(DateTime date) {
  return (date.month < 12)
      ? new DateTime(date.year, date.month + 1, 1)
          .subtract(Duration(days: 1))
          .day
      : new DateTime(date.year + 1, 1, 1).subtract(Duration(days: 1)).day;
}

/*
/// Calculates a opacity value based on the given [highestTemperature] of the day.
double getHighestOpacityPercentage(int highestTemperature) {
  var highestPercentage = 1.0;
  if (highestTemperature <= 15) {
    highestPercentage = 0.4;
  } else if (highestTemperature <= 20) {
    highestPercentage = 0.6;
  } else if (highestTemperature <= 25) {
    highestPercentage = 0.8;
  }

  return highestPercentage;
}

/// Calculates a opacity value based on the given [lowestTemperature] of the day.
double getLowestOpacityPercentage(int lowestTemperature) {
  var lowestPercentage = 0.2;
  if (lowestTemperature >= 10) {
    lowestPercentage = 1.0;
  } else if (lowestTemperature >= 5) {
    lowestPercentage = 0.8;
  } else if (lowestTemperature >= 0) {
    lowestPercentage = 0.6;
  } else if (lowestTemperature >= -5) {
    lowestPercentage = 0.4;
  }
  return lowestPercentage;
}
*/
final radiansPerTick = radians(360 / 60);
