import 'package:drift/drift.dart';
import 'package:kale/core/constants/default_categories.dart';
import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/database/tables/sync_queue_table.dart';
import 'package:kale/features/budget/data/daos/budget_categories_dao.dart';
import 'package:kale/features/budget/data/daos/budgets_dao.dart';
import 'package:kale/features/budget/data/tables/budget_categories_table.dart';
import 'package:kale/features/budget/data/tables/budgets_table.dart';
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
  ],
  daos: [
    SyncQueueDao,
    TransactionsDao,
    CategoriesDao,
    BudgetsDao,
    BudgetCategoriesDao,
    SavingsGoalsDao,
    SavingsContributionsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the given query executor.
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(transactions);
            await m.createTable(categories);
            await m.createTable(budgets);
            await m.createTable(budgetCategories);
            // Drop old notes table.
            await m.deleteTable('notes');
            await _seedDefaultCategories();
          }
          if (from < 3) {
            await m.createTable(savingsGoals);
            await m.createTable(savingsContributions);
          }
        },
      );

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
