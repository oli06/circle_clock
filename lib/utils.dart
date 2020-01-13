/// Rounds an integer to the closest multiple of 5.
/// number = 19 -> 20, number = 17 -> 15
int round(int number) {
  int temp = number % 5;
  if (temp < 3) {
    return number - temp;
  } else {
    return number + 5 - temp;
  }
}

///calculates the last day of the month
int lastDayOfMonth(DateTime date) {
  return (date.month < 12)
      ? new DateTime(date.year, date.month + 1, 1)
          .subtract(Duration(days: 1))
          .day
      : new DateTime(date.year + 1, 1, 1).subtract(Duration(days: 1)).day;
}

double getHighestOpacityPercentage(int highest) {
  var highestPercentage = 1.0;
  if (highest <= 15) {
    highestPercentage = 0.4;
  } else if (highest <= 20) {
    highestPercentage = 0.6;
  } else if (highest <= 25) {
    highestPercentage = 0.8;
  }

  return highestPercentage;
}

double getLowestOpacityPercentage(int lowest) {
  var lowestPercentage = 0.2;
  if (lowest >= 10) {
    lowestPercentage = 1.0;
  } else if (lowest >= 5) {
    lowestPercentage = 0.8;
  } else if (lowest >= 0) {
    lowestPercentage = 0.6;
  } else if (lowest >= -5) {
    lowestPercentage = 0.4;
  }
  return lowestPercentage;
}
