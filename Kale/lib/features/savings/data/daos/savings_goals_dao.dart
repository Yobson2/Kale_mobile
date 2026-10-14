import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/savings/data/tables/savings_goals_table.dart';

part 'savings_goals_dao.g.dart';

/// DAO for savings goals.
///
/// Every read excludes soft-deleted rows (`deletedAt` set).
@DriftAccessor(tables: [SavingsGoals])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  /// Creates a [SavingsGoalsDao].
  SavingsGoalsDao(super.db);

  /// Watches all live goals, optionally filtered by [status].
  Stream<List<SavingsGoal>> watchAll({String? status}) =>
      _live(status: status).watch();

  /// Gets all live goals, optionally filtered by [status].
  Future<List<SavingsGoal>> getAll({String? status}) =>
      _live(status: status).get();

  SimpleSelectStatement<$SavingsGoalsTable, SavingsGoal> _live({
    String? status,
  }) {
    final query = select(savingsGoals)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    return query;
  }

  /// Gets a single live goal by [id].
  Future<SavingsGoal?> getById(String id) => (select(savingsGoals)
        ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
      .getSingleOrNull();

  /// Inserts or updates a goal.
  Future<void> upsert(SavingsGoalsCompanion entry) =>
      into(savingsGoals).insertOnConflictUpdate(entry);

  /// Soft-deletes a live goal: sets `deletedAt` and `updatedAt` to [at] and
  /// marks it unsynced. Returns the deleted row, or null if no live goal
  /// has this [id].
  Future<SavingsGoal?> markDeleted(String id, DateTime at) {
    return transaction(() async {
      final count = await (update(savingsGoals)
            ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
          .write(
        SavingsGoalsCompanion(
          deletedAt: Value(at),
          updatedAt: Value(at),
          isSynced: const Value(false),
        ),
      );
      if (count == 0) return null;
      return (select(savingsGoals)..where((t) => t.id.equals(id))).getSingle();
    });
  }

  /// The merge state of the rows with these [ids], deleted ones included.
  Future<Map<String, LocalRowState>> statesByIds(Iterable<String> ids) async {
    final rows =
        await (select(savingsGoals)..where((t) => t.id.isIn(ids))).get();
    return {
      for (final row in rows)
        row.id: (updatedAt: row.updatedAt, isSynced: row.isSynced),
    };
  }

  /// Inserts or replaces [entries] (rows pulled from the server).
  Future<void> upsertAll(List<SavingsGoalsCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(savingsGoals, entries));

  /// Marks a goal as synced.
  Future<void> markSynced(String id, {String? serverId}) =>
      (update(savingsGoals)..where((t) => t.id.equals(id))).write(
        SavingsGoalsCompanion(
          isSynced: const Value(true),
          serverId: serverId != null ? Value(serverId) : const Value.absent(),
        ),
      );
}
