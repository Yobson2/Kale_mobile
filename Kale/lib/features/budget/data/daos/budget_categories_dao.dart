import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/sync/pull.dart';
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

  /// Soft-deletes the live allocations matching [filter]: sets `deletedAt`
  /// and `updatedAt` to [at] and marks them unsynced. Returns the deleted
  /// rows.
  Future<List<BudgetCategory>> _markDeleted(
    Expression<bool> Function($BudgetCategoriesTable t) filter,
    DateTime at,
  ) {
    return transaction(() async {
      final ids = await (selectOnly(budgetCategories)
            ..addColumns([budgetCategories.id])
            ..where(filter(budgetCategories))
            ..where(budgetCategories.deletedAt.isNull()))
          .map((row) => row.read(budgetCategories.id)!)
          .get();
      if (ids.isEmpty) return const [];
      await (update(budgetCategories)..where((t) => t.id.isIn(ids))).write(
        BudgetCategoriesCompanion(
          deletedAt: Value(at),
          updatedAt: Value(at),
          isSynced: const Value(false),
        ),
      );
      return (select(budgetCategories)..where((t) => t.id.isIn(ids))).get();
    });
  }

  /// Soft-deletes every live allocation of a budget, as [_markDeleted].
  Future<List<BudgetCategory>> markDeletedByBudgetId(
    String budgetId,
    DateTime at,
  ) =>
      _markDeleted((t) => t.budgetId.equals(budgetId), at);

  /// Soft-deletes one live allocation, as [_markDeleted]. Returns null if
  /// no live allocation has this [id].
  Future<BudgetCategory?> markDeleted(String id, DateTime at) async =>
      (await _markDeleted((t) => t.id.equals(id), at)).firstOrNull;

  /// The merge state of the rows with these [ids], deleted ones included.
  Future<Map<String, LocalRowState>> statesByIds(Iterable<String> ids) async {
    final rows =
        await (select(budgetCategories)..where((t) => t.id.isIn(ids))).get();
    return {
      for (final row in rows)
        row.id: (updatedAt: row.updatedAt, isSynced: row.isSynced),
    };
  }

  /// Inserts or replaces [entries] (rows pulled from the server).
  Future<void> upsertAll(List<BudgetCategoriesCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(budgetCategories, entries));

  /// Marks an allocation as synced.
  Future<void> markSynced(String id) =>
      (update(budgetCategories)..where((t) => t.id.equals(id))).write(
        const BudgetCategoriesCompanion(isSynced: Value(true)),
      );
}
