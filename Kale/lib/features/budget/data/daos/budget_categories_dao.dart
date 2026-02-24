import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/budget/data/tables/budget_categories_table.dart';

part 'budget_categories_dao.g.dart';

/// DAO for budget category allocations.
@DriftAccessor(tables: [BudgetCategories])
class BudgetCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetCategoriesDaoMixin {
  BudgetCategoriesDao(super.db);

  /// Watches all allocations for a budget.
  Stream<List<BudgetCategory>> watchByBudgetId(String budgetId) {
    return (select(budgetCategories)
          ..where((t) => t.budgetId.equals(budgetId)))
        .watch();
  }

  /// Gets all allocations for a budget.
  Future<List<BudgetCategory>> getByBudgetId(String budgetId) {
    return (select(budgetCategories)
          ..where((t) => t.budgetId.equals(budgetId)))
        .get();
  }

  /// Inserts or replaces an allocation.
  Future<void> upsert(BudgetCategoriesCompanion entry) {
    return into(budgetCategories).insertOnConflictUpdate(entry);
  }

  /// Inserts multiple allocations at once.
  Future<void> insertAll(List<BudgetCategoriesCompanion> entries) {
    return batch((b) => b.insertAll(budgetCategories, entries));
  }

  /// Deletes all allocations for a budget.
  Future<void> deleteByBudgetId(String budgetId) {
    return (delete(budgetCategories)
          ..where((t) => t.budgetId.equals(budgetId)))
        .go();
  }

  /// Replaces all allocations for a budget.
  Future<void> replaceForBudget(
    String budgetId,
    List<BudgetCategoriesCompanion> entries,
  ) {
    return transaction(() async {
      await deleteByBudgetId(budgetId);
      await batch((b) => b.insertAll(budgetCategories, entries));
    });
  }
}
