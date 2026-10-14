import 'package:drift/drift.dart';
import 'package:kale/core/constants/default_categories.dart';
import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/database/tables/sync_queue_table.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the given query executor.
  AppDatabase(super.e);

  @override
  int get schemaVersion => 4;

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
    });
    await _seedDefaultCategories();
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
