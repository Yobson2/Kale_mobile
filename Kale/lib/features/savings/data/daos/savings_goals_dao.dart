import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/savings/data/tables/savings_goals_table.dart';

part 'savings_goals_dao.g.dart';

/// DAO for savings goals CRUD operations.
@DriftAccessor(tables: [SavingsGoals])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  /// Creates a [SavingsGoalsDao].
  SavingsGoalsDao(super.db);

  /// Watches all goals, optionally filtered by [status].
  Stream<List<SavingsGoal>> watchAll({String? status}) {
    var query = select(savingsGoals)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (status != null) {
      query = query..where((t) => t.status.equals(status));
    }
    return query.watch();
  }

  /// Gets all goals, optionally filtered by [status].
  Future<List<SavingsGoal>> getAll({String? status}) {
    var query = select(savingsGoals)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (status != null) {
      query = query..where((t) => t.status.equals(status));
    }
    return query.get();
  }

  /// Gets a single goal by [id].
  Future<SavingsGoal?> getById(String id) =>
      (select(savingsGoals)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts or updates a goal.
  Future<void> upsert(SavingsGoalsCompanion entry) =>
      into(savingsGoals).insertOnConflictUpdate(entry);

  /// Deletes a goal by [id].
  Future<void> deleteById(String id) =>
      (delete(savingsGoals)..where((t) => t.id.equals(id))).go();

  /// Updates the current amount for a goal.
  Future<void> updateCurrentAmount(String id, double amount) =>
      (update(savingsGoals)..where((t) => t.id.equals(id))).write(
        SavingsGoalsCompanion(
          currentAmount: Value(amount),
          updatedAt: Value(DateTime.now()),
        ),
      );

  /// Marks a goal as synced.
  Future<void> markSynced(String id, {String? serverId}) =>
      (update(savingsGoals)..where((t) => t.id.equals(id))).write(
        SavingsGoalsCompanion(
          isSynced: const Value(true),
          serverId:
              serverId != null ? Value(serverId) : const Value.absent(),
        ),
      );

  /// Replaces all goals (used during server refresh).
  Future<void> replaceAll(List<SavingsGoalsCompanion> entries) {
    return transaction(() async {
      await delete(savingsGoals).go();
      await batch((b) => b.insertAll(savingsGoals, entries));
    });
  }
}
