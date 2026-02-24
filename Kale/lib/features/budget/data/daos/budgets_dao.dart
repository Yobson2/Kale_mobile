import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/budget/data/tables/budgets_table.dart';

part 'budgets_dao.g.dart';

/// DAO for budgets table operations.
@DriftAccessor(tables: [Budgets])
class BudgetsDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  /// Watches all budgets ordered by creation date descending.
  Stream<List<Budget>> watchAll() {
    return (select(budgets)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Gets all budgets.
  Future<List<Budget>> getAll() {
    return (select(budgets)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Gets the active budget (where today falls within start/end dates).
  Future<Budget?> getActive() {
    final now = DateTime.now();
    return (select(budgets)
          ..where((t) => t.startDate.isSmallerOrEqualValue(now))
          ..where((t) => t.endDate.isBiggerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Gets a single budget by ID.
  Future<Budget?> getById(String id) {
    return (select(budgets)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts or replaces a budget.
  Future<void> upsert(BudgetsCompanion entry) {
    return into(budgets).insertOnConflictUpdate(entry);
  }

  /// Deletes a budget by ID.
  Future<void> deleteById(String id) {
    return (delete(budgets)..where((t) => t.id.equals(id))).go();
  }

  /// Marks a budget as synced.
  Future<void> markSynced(String id, {String? serverId}) {
    return (update(budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        isSynced: const Value(true),
        serverId:
            serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }

  /// Replaces all budgets from server.
  Future<void> replaceAll(List<BudgetsCompanion> serverBudgets) {
    return transaction(() async {
      await delete(budgets).go();
      await batch((b) => b.insertAll(budgets, serverBudgets));
    });
  }
}
