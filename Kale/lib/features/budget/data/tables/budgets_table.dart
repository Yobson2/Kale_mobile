import 'package:drift/drift.dart';
import 'package:kale/core/date/calendar_date.dart';

/// Drift table definition for budgets.
///
/// Amounts are integer minor units in the account's base currency (see
/// `features/profile`). The period is stored as calendar dates
/// (`YYYY-MM-DD` text), so no time-zone or clock change can shift it.
class Budgets extends Table {
  /// Client-generated UUID.
  TextColumn get id => text()();

  /// Server-assigned ID. Null until first sync.
  TextColumn get serverId => text().nullable()();

  /// Budget name (e.g., "February 2026 Budget").
  TextColumn get name => text()();

  /// Strategy: 'fiftyThirtyTwenty', 'eightyTwenty', 'envelope', 'custom'.
  TextColumn get strategy => text()();

  /// Period: 'weekly', 'biWeekly', 'monthly'.
  TextColumn get period => text()();

  /// First day of the period (included).
  TextColumn get startDate => text().map(const CalendarDateConverter())();

  /// Last day of the period (included).
  TextColumn get endDate => text().map(const CalendarDateConverter())();

  /// The day periods start on: day of the month for monthly budgets,
  /// ISO weekday for weekly ones. See `BudgetPeriodRange.containing`.
  IntColumn get periodStartDay => integer().withDefault(const Constant(1))();

  /// Total expected income for this period, in minor units (optional).
  IntColumn get totalIncomeMinor => integer().nullable()();

  /// Whether allocations are percentage-based (for irregular income).
  BoolColumn get isPercentageBased =>
      boolean().withDefault(const Constant(true))();

  /// When the budget was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the budget was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft-delete marker. Every read excludes rows where it is set.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Whether synced to server.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stores a [CalendarDate] as `YYYY-MM-DD` text, which sorts and compares
/// in date order.
class CalendarDateConverter extends TypeConverter<CalendarDate, String> {
  const CalendarDateConverter();

  @override
  CalendarDate fromSql(String fromDb) => CalendarDate.parse(fromDb);

  @override
  String toSql(CalendarDate value) => value.toIso();
}
