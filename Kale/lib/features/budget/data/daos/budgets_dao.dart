import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/budget/data/tables/budgets_table.dart';

part 'budgets_dao.g.dart';

/// DAO for budgets table operations.
///
/// Every read excludes soft-deleted rows (`deletedAt` set).
@DriftAccessor(tables: [Budgets])
class BudgetsDao extends DatabaseAccessor<AppDatabase> with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  /// Watches all budgets ordered by creation date descending.
  Stream<List<Budget>> watchAll() {
    return (select(budgets)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Gets all budgets.
  Future<List<Budget>> getAll() {
    return (select(budgets)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Gets the most recently created budget whose period covers [day].
  Future<Budget?> getActiveOn(CalendarDate day) {
    // ISO dates compare as text in date order.
    final iso = day.toIso();
    return (select(budgets)
          ..where((t) => t.deletedAt.isNull())
          ..where(
            (t) =>
                t.startDate.isSmallerOrEqualValue(iso) &
                t.endDate.isBiggerOrEqualValue(iso),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Gets a single budget by ID.
  Future<Budget?> getById(String id) {
    return (select(budgets)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Inserts or replaces a budget.
  Future<void> upsert(BudgetsCompanion entry) {
    return into(budgets).insertOnConflictUpdate(entry);
  }

  /// Soft-deletes a live budget: sets `deletedAt` and `updatedAt` to [at]
  /// and marks it unsynced. Returns the deleted row, or null if no live
  /// budget has this [id].
  Future<Budget?> markDeleted(String id, DateTime at) {
    return transaction(() async {
      final count = await (update(budgets)
            ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
          .write(
        BudgetsCompanion(
          deletedAt: Value(at),
          updatedAt: Value(at),
          isSynced: const Value(false),
        ),
      );
      if (count == 0) return null;
      return (select(budgets)..where((t) => t.id.equals(id))).getSingle();
    });
  }

  /// The merge state of the rows with these [ids], deleted ones included.
  Future<Map<String, LocalRowState>> statesByIds(Iterable<String> ids) async {
    final rows = await (select(budgets)..where((t) => t.id.isIn(ids))).get();
    return {
      for (final row in rows)
        row.id: (updatedAt: row.updatedAt, isSynced: row.isSynced),
    };
  }

  /// Inserts or replaces [entries] (rows pulled from the server).
  Future<void> upsertAll(List<BudgetsCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(budgets, entries));

  /// Marks a budget as synced.
  Future<void> markSynced(String id, {String? serverId}) {
    return (update(budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        isSynced: const Value(true),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }
}
