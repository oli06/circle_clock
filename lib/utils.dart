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
