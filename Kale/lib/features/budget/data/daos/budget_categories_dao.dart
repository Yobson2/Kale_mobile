import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/budget/data/tables/budget_categories_table.dart';

part 'budget_categories_dao.g.dart';

/// DAO for budget category allocations.
///
/// Every read excludes soft-deleted rows (`deletedAt` set).
@DriftAccessor(tables: [BudgetCategories])
class BudgetCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetCategoriesDaoMixin {
  BudgetCategoriesDao(super.db);

  /// Watches all allocations for a budget.
  Stream<List<BudgetCategory>> watchByBudgetId(String budgetId) {
    return (select(budgetCategories)
          ..where((t) => t.budgetId.equals(budgetId) & t.deletedAt.isNull()))
        .watch();
  }

  /// Gets all allocations for a budget.
  Future<List<BudgetCategory>> getByBudgetId(String budgetId) {
    return (select(budgetCategories)
          ..where((t) => t.budgetId.equals(budgetId) & t.deletedAt.isNull()))
        .get();
  }

  /// Inserts or replaces an allocation.
  Future<void> upsert(BudgetCategoriesCompanion entry) {
    return into(budgetCategories).insertOnConflictUpdate(entry);
  }

  /// Deletes all allocations for a budget.
  Future<void> deleteByBudgetId(String budgetId) {
    return (delete(budgetCategories)..where((t) => t.budgetId.equals(budgetId)))
        .go();
  }

  /// Deletes one allocation.
  Future<void> deleteById(String id) =>
      (delete(budgetCategories)..where((t) => t.id.equals(id))).go();

  /// Marks an allocation as synced.
  Future<void> markSynced(String id) =>
      (update(budgetCategories)..where((t) => t.id.equals(id))).write(
        const BudgetCategoriesCompanion(isSynced: Value(true)),
      );

  /// Replaces the synced allocations with the server's copy (server
  /// refresh).
  ///
  /// Allocations not yet pushed are kept as they are.
  Future<void> replaceAll(Iterable<BudgetCategoriesCompanion> entries) {
    return transaction(() async {
      final unsynced = (await (selectOnly(budgetCategories)
                ..addColumns([budgetCategories.id])
                ..where(budgetCategories.isSynced.equals(false)))
              .map((row) => row.read(budgetCategories.id)!)
              .get())
          .toSet();
      await (delete(budgetCategories)..where((t) => t.isSynced.equals(true)))
          .go();
      await batch(
        (b) => b.insertAllOnConflictUpdate(
          budgetCategories,
          entries.where((e) => !unsynced.contains(e.id.value)),
        ),
      );
    });
  }
}
