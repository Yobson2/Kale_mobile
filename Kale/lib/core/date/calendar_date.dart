import 'package:meta/meta.dart';

/// A day on the calendar (year, month, day) with no time and no time zone.
///
/// Pure Dart, usable from the domain layer. Use it for anything that names
/// days rather than instants, such as budget periods: a change of the
/// device's time zone or clock can't move it to another day, because there
/// is no instant to convert. Stored and transferred as `YYYY-MM-DD`.
@immutable
class CalendarDate implements Comparable<CalendarDate> {
  /// Creates the date [year]-[month]-[day], which must be a real date.
  /// Use [CalendarDate.rollover] for values that may be out of range.
  const CalendarDate(this.year, this.month, this.day)
      : assert(month >= 1 && month <= 12, 'month is 1 to 12'),
        assert(day >= 1 && day <= 31, 'day is 1 to 31');

  /// Creates a date from values that may be out of range, rolling them over
  /// like [DateTime] does (month 13 is January of the next year, day 0 the
  /// last day of the previous month).
  factory CalendarDate.rollover(int year, int month, int day) {
    final normalized = DateTime.utc(year, month, day);
    return CalendarDate(normalized.year, normalized.month, normalized.day);
  }

  /// The wall-clock day of [dateTime], read in its own time zone (local or
  /// UTC). The value is never converted between zones.
  factory CalendarDate.fromDateTime(DateTime dateTime) =>
      CalendarDate(dateTime.year, dateTime.month, dateTime.day);

  /// Today, by the device's clock and time zone.
  factory CalendarDate.today() => CalendarDate.fromDateTime(DateTime.now());

  /// Parses `YYYY-MM-DD`. Anything after the date part (a time or an
  /// offset, as a server timestamp has) is ignored.
  factory CalendarDate.parse(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(value);
    if (match == null) {
      throw FormatException('Not a calendar date', value);
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) {
      throw FormatException('Not a calendar date', value);
    }
    return CalendarDate(year, month, day);
  }

  final int year;

  /// 1 (January) to 12.
  final int month;

  /// 1 to 31.
  final int day;

  /// The ISO weekday: 1 (Monday) to 7 (Sunday).
  int get weekday => DateTime.utc(year, month, day).weekday;

  /// How many days [month] of [year] has.
  static int daysInMonth(int year, int month) =>
      DateTime.utc(year, month + 1, 0).day;

  /// The date [days] calendar days later (earlier if negative).
  CalendarDate addDays(int days) =>
      CalendarDate.rollover(year, month, day + days);

  /// The first instant of this day in the device's current time zone.
  DateTime startOfDayLocal() => DateTime(year, month, day);

  bool isBefore(CalendarDate other) => compareTo(other) < 0;
  bool isAfter(CalendarDate other) => compareTo(other) > 0;

  /// `YYYY-MM-DD`.
  String toIso() => '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  @override
  int compareTo(CalendarDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is CalendarDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}
