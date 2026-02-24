import 'package:drift/drift.dart';

/// Drift table definition for budgets.
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

  /// Start date of the budget period.
  DateTimeColumn get startDate => dateTime()();

  /// End date of the budget period.
  DateTimeColumn get endDate => dateTime()();

  /// Total expected income for this period (optional).
  RealColumn get totalIncome => real().nullable()();

  /// Whether allocations are percentage-based (for irregular income).
  BoolColumn get isPercentageBased =>
      boolean().withDefault(const Constant(true))();

  /// When the budget was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the budget was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  /// Whether synced to server.
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
