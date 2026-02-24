import 'package:drift/drift.dart';

/// Drift table definition for budget category allocations.
class BudgetCategories extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// FK to budget.
  TextColumn get budgetId => text()();

  /// FK to category.
  TextColumn get categoryId => text()();

  /// Group name (e.g., "Needs", "Wants", "Savings").
  TextColumn get groupName => text()();

  /// Allocated fixed amount.
  RealColumn get allocatedAmount => real()();

  /// Allocated percentage of income (nullable, used when percentage-based).
  RealColumn get allocatedPercentage => real().nullable()();

  /// When this allocation was created.
  DateTimeColumn get createdAt => dateTime()();

  /// Whether synced to server.
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
