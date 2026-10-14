import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';

void main() {
  BudgetPeriodRange monthly(CalendarDate day, {int startDay = 1}) =>
      BudgetPeriodRange.containing(
        day,
        period: BudgetPeriod.monthly,
        startDay: startDay,
      );

  group('monthly', () {
    test('the default start day is the calendar month', () {
      final range = monthly(const CalendarDate(2026, 10, 14));

      expect(range.start, const CalendarDate(2026, 10, 1));
      expect(range.end, const CalendarDate(2026, 10, 31));
    });

    test('a calendar month in February of a leap year ends on the 29th', () {
      final range = monthly(const CalendarDate(2028, 2, 10));

      expect(range.start, const CalendarDate(2028, 2, 1));
      expect(range.end, const CalendarDate(2028, 2, 29));
    });

    test('a start day of 25 runs from the 25th to the 24th', () {
      expect(
        monthly(const CalendarDate(2026, 10, 25), startDay: 25),
        const BudgetPeriodRange(
          CalendarDate(2026, 10, 25),
          CalendarDate(2026, 11, 24),
        ),
      );
      expect(
        monthly(const CalendarDate(2026, 10, 24), startDay: 25),
        const BudgetPeriodRange(
          CalendarDate(2026, 9, 25),
          CalendarDate(2026, 10, 24),
        ),
      );
    });

    test('a period across the new year', () {
      expect(
        monthly(const CalendarDate(2027, 1, 3), startDay: 25),
        const BudgetPeriodRange(
          CalendarDate(2026, 12, 25),
          CalendarDate(2027, 1, 24),
        ),
      );
    });

    test('a start day past the end of a short month starts on its last day',
        () {
      // Start day 31: February has no 31st, so its period starts on the
      // 28th, and January's period ends the day before.
      expect(
        monthly(const CalendarDate(2027, 2, 28), startDay: 31),
        const BudgetPeriodRange(
          CalendarDate(2027, 2, 28),
          CalendarDate(2027, 3, 30),
        ),
      );
      expect(
        monthly(const CalendarDate(2027, 2, 27), startDay: 31),
        const BudgetPeriodRange(
          CalendarDate(2027, 1, 31),
          CalendarDate(2027, 2, 27),
        ),
      );
    });
  });

  group('weekly', () {
    test('the default start day is Monday', () {
      // 2026-10-14 is a Wednesday.
      final range = BudgetPeriodRange.containing(
        const CalendarDate(2026, 10, 14),
        period: BudgetPeriod.weekly,
      );

      expect(range.start, const CalendarDate(2026, 10, 12));
      expect(range.end, const CalendarDate(2026, 10, 18));
    });

    test('a start day of 6 runs Saturday to Friday', () {
      final range = BudgetPeriodRange.containing(
        const CalendarDate(2026, 10, 14),
        period: BudgetPeriod.weekly,
        startDay: 6,
      );

      expect(range.start, const CalendarDate(2026, 10, 10));
      expect(range.end, const CalendarDate(2026, 10, 16));
    });
  });

  test('bi-weekly runs fourteen days from the given day', () {
    final range = BudgetPeriodRange.containing(
      const CalendarDate(2026, 12, 25),
      period: BudgetPeriod.biWeekly,
    );

    expect(range.start, const CalendarDate(2026, 12, 25));
    expect(range.end, const CalendarDate(2027, 1, 7));
  });

  test('a range covers its first and last day, and nothing outside', () {
    const range = BudgetPeriodRange(
      CalendarDate(2026, 10, 1),
      CalendarDate(2026, 10, 31),
    );

    expect(range.contains(const CalendarDate(2026, 10, 1)), isTrue);
    expect(range.contains(const CalendarDate(2026, 10, 31)), isTrue);
    expect(range.contains(const CalendarDate(2026, 9, 30)), isFalse);
    expect(range.contains(const CalendarDate(2026, 11, 1)), isFalse);
  });

  group('CalendarDate', () {
    test('is written and read as a plain ISO date', () {
      expect(const CalendarDate(2026, 3, 9).toIso(), '2026-03-09');
      expect(CalendarDate.parse('2026-03-09'), const CalendarDate(2026, 3, 9));
    });

    test('reads a server date or timestamp by its date part only', () {
      // A timestamp written by a device in another time zone keeps its day.
      expect(
        CalendarDate.parse('2026-10-01T00:00:00+14:00'),
        const CalendarDate(2026, 10, 1),
      );
    });

    test('takes the wall-clock day of a DateTime in its own time zone', () {
      // The same instant is a different day in UTC and in UTC+14; each
      // DateTime is read by its own wall clock, never converted.
      final instant = DateTime.utc(2026, 9, 30, 12);
      final kiritimati = instant.add(const Duration(hours: 14));

      expect(
        CalendarDate.fromDateTime(instant),
        const CalendarDate(2026, 9, 30),
      );
      expect(
        CalendarDate.fromDateTime(kiritimati),
        const CalendarDate(2026, 10, 1),
      );
    });

    test('day arithmetic is calendar arithmetic, not 24-hour steps', () {
      // Adding days never lands on the wrong day across a DST change.
      expect(
        const CalendarDate(2026, 3, 28).addDays(2),
        const CalendarDate(2026, 3, 30),
      );
      expect(
        const CalendarDate(2026, 10, 24).addDays(2),
        const CalendarDate(2026, 10, 26),
      );
      expect(
        const CalendarDate(2026, 3, 1).addDays(-1),
        const CalendarDate(2026, 2, 28),
      );
    });
  });
}
