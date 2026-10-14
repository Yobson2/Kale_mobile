import 'dart:math' as math;

import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:meta/meta.dart';

/// The days a budget covers: [start] to [end], both included.
///
/// Made of [CalendarDate]s, so a change of the device's time zone or clock
/// never shifts which days it covers.
@immutable
class BudgetPeriodRange {
  const BudgetPeriodRange(this.start, this.end);

  /// The period of kind [period] that contains [day].
  ///
  /// [startDay] is the budget's period start day (default 1):
  /// * [BudgetPeriod.monthly]: the day of the month a period starts on
  ///   (1 to 31). In a month too short for it, the period starts on the
  ///   month's last day. The default is the calendar month.
  /// * [BudgetPeriod.weekly]: the ISO weekday a period starts on, 1
  ///   (Monday, the default) to 7 (Sunday).
  /// * [BudgetPeriod.biWeekly]: not used; the period is the fourteen days
  ///   starting on [day].
  factory BudgetPeriodRange.containing(
    CalendarDate day, {
    required BudgetPeriod period,
    int startDay = defaultStartDay,
  }) {
    switch (period) {
      case BudgetPeriod.monthly:
        final dayOfMonth = startDay.clamp(1, 31);
        var start = _monthlyStart(day.year, day.month, dayOfMonth);
        if (day.isBefore(start)) {
          start = _monthlyStart(day.year, day.month - 1, dayOfMonth);
        }
        final next = _monthlyStart(start.year, start.month + 1, dayOfMonth);
        return BudgetPeriodRange(start, next.addDays(-1));
      case BudgetPeriod.weekly:
        final weekday = startDay.clamp(1, 7);
        final start = day.addDays(-((day.weekday - weekday) % 7));
        return BudgetPeriodRange(start, start.addDays(6));
      case BudgetPeriod.biWeekly:
        return BudgetPeriodRange(day, day.addDays(13));
    }
  }

  /// The start day used when the user hasn't chosen one: the 1st of the
  /// month (calendar months) or Monday (weeks).
  static const defaultStartDay = 1;

  /// First day covered.
  final CalendarDate start;

  /// Last day covered.
  final CalendarDate end;

  /// Whether [day] falls within this period.
  bool contains(CalendarDate day) => !day.isBefore(start) && !day.isAfter(end);

  /// The start of the month period on [dayOfMonth] in [month] of [year]
  /// (rolled over), clamped to the month's last day.
  static CalendarDate _monthlyStart(int year, int month, int dayOfMonth) {
    final first = CalendarDate.rollover(year, month, 1);
    final last = CalendarDate.daysInMonth(first.year, first.month);
    return CalendarDate(first.year, first.month, math.min(dayOfMonth, last));
  }

  @override
  bool operator ==(Object other) =>
      other is BudgetPeriodRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'BudgetPeriodRange($start..$end)';
}
