import 'package:drift/drift.dart';

/// Drift table definition for budget category allocations.
///
/// Owned through their budget. Amounts are integer minor units in the
/// account's base currency.
class BudgetCategories extends Table {
  /// Client-generated UUID.
  TextColumn get id => text()();

  /// FK to budget.
  TextColumn get budgetId => text()();

  /// FK to category.
  TextColumn get categoryId => text()();

  /// Group name (e.g., "Needs", "Wants", "Savings").
  TextColumn get groupName => text()();

  /// Allocated amount, in minor units.
  IntColumn get allocatedMinor => integer()();

  /// Allocated percentage of income (nullable, used when percentage-based).
  /// A share, not money.
  RealColumn get allocatedPercentage => real().nullable()();

  /// When this allocation was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When this allocation was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft-delete marker. Every read excludes rows where it is set.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Whether synced to server.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
