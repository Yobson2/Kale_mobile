import 'package:drift/drift.dart';
import 'package:kale/core/constants/default_categories.dart';
import 'package:kale/core/database/daos/pull_cursors_dao.dart';
import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/database/tables/pull_cursors_table.dart';
import 'package:kale/core/database/tables/sync_queue_table.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/features/budget/data/daos/budget_categories_dao.dart';
import 'package:kale/features/budget/data/daos/budgets_dao.dart';
import 'package:kale/features/budget/data/tables/budget_categories_table.dart';
import 'package:kale/features/budget/data/tables/budgets_table.dart';
import 'package:kale/features/profile/data/daos/profile_dao.dart';
import 'package:kale/features/profile/data/tables/profiles_table.dart';
import 'package:kale/features/savings/data/daos/savings_contributions_dao.dart';
import 'package:kale/features/savings/data/daos/savings_goals_dao.dart';
import 'package:kale/features/savings/data/tables/savings_contributions_table.dart';
import 'package:kale/features/savings/data/tables/savings_goals_table.dart';
import 'package:kale/features/transactions/data/daos/categories_dao.dart';
import 'package:kale/features/transactions/data/daos/transactions_dao.dart';
import 'package:kale/features/transactions/data/tables/categories_table.dart';
import 'package:kale/features/transactions/data/tables/transactions_table.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

/// Central Drift database aggregating all tables and DAOs.
@DriftDatabase(
  tables: [
    SyncQueueEntries,
    Transactions,
    Categories,
    Budgets,
    BudgetCategories,
    SavingsGoals,
    SavingsContributions,
    Profiles,
    PullCursors,
  ],
  daos: [
    SyncQueueDao,
    TransactionsDao,
    CategoriesDao,
    BudgetsDao,
    BudgetCategoriesDao,
    SavingsGoalsDao,
    SavingsContributionsDao,
    ProfileDao,
    PullCursorsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the given query executor.
  AppDatabase(super.e);

  @override
  int get schemaVersion => 7;

  /// PRE-RELEASE ONLY: any [schemaVersion] change (up or down) drops every
  /// table and recreates the schema, wiping all local data, including
  /// changes not yet synced.
  ///
  /// This lets tables be reset one feature at a time while no external
  /// users exist. Replace it with real `onUpgrade` steps before the first
  /// public release.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
        onUpgrade: (m, from, to) async {
          await _dropAllTables(m);
          await m.createAll();
          await _seedDefaultCategories();
        },
      );

  /// Drops every user table in the file, including ones that no longer
  /// exist in the current schema.
  Future<void> _dropAllTables(Migrator m) async {
    final names = await customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table' "
      "AND name NOT LIKE 'sqlite_%'",
    ).map((row) => row.read<String>('name')).get();
    for (final name in names) {
      await m.deleteTable(name);
    }
  }

  /// Deletes all user-generated data from every table.
  ///
  /// Called on logout to prevent the next user from seeing stale data.
  /// Default categories are re-seeded after clearing.
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(syncQueueEntries).go();
      await delete(savingsContributions).go();
      await delete(savingsGoals).go();
      await delete(budgetCategories).go();
      await delete(budgets).go();
      await delete(transactions).go();
      await delete(categories).go();
      await delete(profiles).go();
      await delete(pullCursors).go();
    });
    await _seedDefaultCategories();
  }

  /// Whether the device holds any of the user's own data: a synced entry
  /// (live or deleted) or a change waiting to be pushed. The profile and
  /// the seeded categories don't count. Restore runs only when this is
  /// false (decision Q8).
  Future<bool> hasUserData() async {
    for (final table in <TableInfo<Table, Object?>>[
      syncQueueEntries,
      transactions,
      budgets,
      budgetCategories,
      savingsGoals,
      savingsContributions,
    ]) {
      final row = await customSelect(
        'SELECT 1 FROM ${table.actualTableName} LIMIT 1',
        readsFrom: {table},
      ).getSingleOrNull();
      if (row != null) return true;
    }
    return false;
  }

  /// How many of the user's entries are on the device: live transactions,
  /// budgets and savings goals (allocations and contributions belong to
  /// their budget or goal and are not counted).
  Future<int> countEntries() async {
    final row = await customSelect(
      'SELECT '
      '(SELECT COUNT(*) FROM transactions WHERE deleted_at IS NULL) + '
      '(SELECT COUNT(*) FROM budgets WHERE deleted_at IS NULL) + '
      '(SELECT COUNT(*) FROM savings_goals WHERE deleted_at IS NULL) '
      'AS n',
      readsFrom: {transactions, budgets, savingsGoals},
    ).getSingle();
    return row.read<int>('n');
  }

  /// Prepares the device's data to move to another account: every live
  /// row gets a new id (children follow their parent's), becomes unsynced
  /// with no server id, and deletion markers are dropped. The sync queue
  /// and the pull cursors are cleared, and the profile is marked synced so
  /// the other account's profile replaces it on the next pull.
  ///
  /// New ids are needed because the old ones stay taken on the server by
  /// the account the data leaves. The caller then queues every row as a
  /// create (`SyncHandler.requeueAllAsCreates`).
  Future<void> rekeyForAnotherAccount() {
    const uuid = Uuid();
    return transaction(() async {
      const synced = [
        'transactions',
        'budgets',
        'budget_categories',
        'savings_goals',
        'savings_contributions',
      ];
      for (final table in synced) {
        await customStatement(
          'DELETE FROM $table WHERE deleted_at IS NOT NULL',
        );
      }

      Future<void> rekey(
        String table, {
        String? child,
        String? childKey,
      }) async {
        final ids = await customSelect('SELECT id FROM $table')
            .map((row) => row.read<String>('id'))
            .get();
        for (final id in ids) {
          final newId = uuid.v4();
          await customStatement(
            'UPDATE $table SET id = ? WHERE id = ?',
            [newId, id],
          );
          if (child != null) {
            await customStatement(
              'UPDATE $child SET $childKey = ? WHERE $childKey = ?',
              [newId, id],
            );
          }
        }
      }

      await rekey('budgets', child: 'budget_categories', childKey: 'budget_id');
      await rekey(
        'savings_goals',
        child: 'savings_contributions',
        childKey: 'goal_id',
      );
      await rekey('budget_categories');
      await rekey('savings_contributions');
      await rekey('transactions');

      for (final table in synced) {
        await customStatement('UPDATE $table SET is_synced = 0');
      }
      for (final table in [
        'transactions',
        'budgets',
        'savings_goals',
        'savings_contributions',
      ]) {
        await customStatement('UPDATE $table SET server_id = NULL');
      }
      await customStatement('UPDATE profiles SET is_synced = 1');
      await delete(syncQueueEntries).go();
      await delete(pullCursors).go();
    });
  }

  /// Seeds the database with default Africa-relevant categories.
  Future<void> _seedDefaultCategories() async {
    final now = DateTime.now();
    var sortOrder = 0;

    for (final cat in DefaultCategories.expenseCategories) {
      await into(categories).insertOnConflictUpdate(
        CategoriesCompanion(
          id: Value(cat['id']!),
          name: Value(cat['name']!),
          icon: Value(cat['icon']!),
          color: Value(cat['color']!),
          type: const Value('expense'),
          isDefault: const Value(true),
          sortOrder: Value(sortOrder++),
          createdAt: Value(now),
          isSynced: const Value(true),
        ),
      );
    }

    for (final cat in DefaultCategories.incomeCategories) {
      await into(categories).insertOnConflictUpdate(
        CategoriesCompanion(
          id: Value(cat['id']!),
          name: Value(cat['name']!),
          icon: Value(cat['icon']!),
          color: Value(cat['color']!),
          type: const Value('income'),
          isDefault: const Value(true),
          sortOrder: Value(sortOrder++),
          createdAt: Value(now),
          isSynced: const Value(true),
        ),
      );
    }
  }
}
