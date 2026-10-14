import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

import '../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  BudgetCategoryAllocation allocation(String categoryId, int allocatedMinor) =>
      BudgetCategoryAllocation(
        id: '',
        budgetId: '',
        categoryId: categoryId,
        groupName: 'Needs',
        allocatedMinor: allocatedMinor,
        spentMinor: 0,
        createdAt: DateTime(2026, 10),
      );

  Future<List<Budget>> listBudgets() async =>
      (await harness.budgets.getBudgets())
          .fold((f) => throw StateError('$f'), (b) => b);

  void expectNothingLeftToBackUp() {
    expect(harness.backupStatus.pendingCount, 0);
    expect(harness.backupStatus.stuckCount, 0);
  }

  group('a delete is synced as an update carrying deleted_at', () {
    test('transaction', () async {
      final transaction = await harness.addTransaction();
      await harness.sync();

      await harness.transactions.deleteTransaction(transaction.id);
      await harness.sync();

      expect(harness.server.transactions.calls, [
        RemoteCall.create(transaction.id),
        RemoteCall.update(transaction.id),
      ]);
      expect(
        harness.server.transactions.rows[transaction.id]!.deletedAt,
        isNotNull,
      );
      expectNothingLeftToBackUp();
    });

    test('budget, with each of its allocations', () async {
      final budget = await harness.addBudget(
        categories: [allocation('cat_food', 100), allocation('cat_rent', 200)],
      );
      await harness.sync();
      harness.server.budgets.calls.clear();
      harness.server.budgetCategories.calls.clear();

      await harness.budgets.deleteBudget(budget.id);
      await harness.sync();

      expect(harness.server.budgets.calls, [RemoteCall.update(budget.id)]);
      expect(harness.server.budgets.rows[budget.id]!.deletedAt, isNotNull);
      expect(
        harness.server.budgetCategories.calls,
        unorderedEquals([
          for (final c in budget.categories) RemoteCall.update(c.id),
        ]),
      );
      expect(
        harness.server.budgetCategories.rows.values.map((r) => r.deletedAt),
        everyElement(isNotNull),
      );
      expect(await listBudgets(), isEmpty);
      expectNothingLeftToBackUp();
    });

    test('savings goal, with each of its contributions', () async {
      final goal = await harness.addSavingsGoal();
      final first = await harness.contribute(goal.id, amountMinor: 500);
      final second = await harness.contribute(goal.id, amountMinor: 700);
      await harness.sync();
      harness.server.savingsGoals.calls.clear();
      harness.server.savingsContributions.calls.clear();

      await harness.savings.deleteSavingsGoal(goal.id);
      await harness.sync();

      expect(harness.server.savingsGoals.calls, [RemoteCall.update(goal.id)]);
      expect(harness.server.savingsGoals.rows[goal.id]!.deletedAt, isNotNull);
      expect(
        harness.server.savingsContributions.calls,
        unorderedEquals([
          RemoteCall.update(first.id),
          RemoteCall.update(second.id),
        ]),
      );
      expect(
        harness.server.savingsContributions.rows.values.map((r) => r.deletedAt),
        everyElement(isNotNull),
      );
      final goals = (await harness.savings.getSavingsGoals())
          .fold((f) => throw StateError('$f'), (g) => g);
      expect(goals, isEmpty);
      expect(await harness.listContributions(goal.id), isEmpty);
      expectNothingLeftToBackUp();
    });
  });

  test('a delete made offline syncs after a relaunch', () async {
    final transaction = await harness.addTransaction();
    await harness.sync();
    harness.online = false;
    await harness.transactions.deleteTransaction(transaction.id);

    harness
      ..restartApp()
      ..online = true;
    await harness.sync();

    expect(
      harness.server.transactions.rows[transaction.id]!.deletedAt,
      isNotNull,
    );
    expectNothingLeftToBackUp();
  });

  test('deleting an already deleted entry fails without queueing anything',
      () async {
    final transaction = await harness.addTransaction();
    await harness.transactions.deleteTransaction(transaction.id);

    final again = await harness.transactions.deleteTransaction(transaction.id);

    expect(again.isLeft(), isTrue);
    await harness.sync();
    expect(harness.server.transactions.calls, [
      RemoteCall.create(transaction.id),
      RemoteCall.update(transaction.id),
    ]);
  });

  group('creating then deleting before any sync', () {
    test('leaves a tombstone on the server, with no error', () async {
      harness.online = false;
      final transaction = await harness.addTransaction();
      await harness.transactions.deleteTransaction(transaction.id);
      final budget =
          await harness.addBudget(categories: [allocation('cat_food', 100)]);
      await harness.budgets.deleteBudget(budget.id);
      final goal = await harness.addSavingsGoal();
      final contribution = await harness.contribute(goal.id, amountMinor: 50);
      await harness.savings.deleteSavingsGoal(goal.id);

      harness.online = true;
      await harness.sync();

      expect(
        harness.server.transactions.rows[transaction.id]!.deletedAt,
        isNotNull,
      );
      expect(harness.server.budgets.rows[budget.id]!.deletedAt, isNotNull);
      expect(
        harness.server.budgetCategories.rows[budget.categories.single.id]!
            .deletedAt,
        isNotNull,
      );
      expect(harness.server.savingsGoals.rows[goal.id]!.deletedAt, isNotNull);
      expect(
        harness.server.savingsContributions.rows[contribution.id]!.deletedAt,
        isNotNull,
      );
      expectNothingLeftToBackUp();
    });
  });

  group('deleted entries are left out of', () {
    late String deletedId;

    setUp(() async {
      await harness.addTransaction(amountMinor: 300);
      await harness.addTransaction(
        amountMinor: 2000,
        type: TransactionType.income,
        categoryId: 'cat_salary',
      );
      final deleted = await harness.addTransaction(amountMinor: 900);
      deletedId = deleted.id;
      await harness.transactions.deleteTransaction(deletedId);
    });

    test('the transaction list and lookups', () async {
      expect(
        (await harness.listTransactions()).map((t) => t.id),
        isNot(contains(deletedId)),
      );
      expect(
        (await harness.transactions.getTransactionById(deletedId)).isLeft(),
        isTrue,
      );
      expect(
        (await harness.transactions.countTransactions())
            .fold((f) => throw StateError('$f'), (n) => n),
        2,
      );
    });

    test('period totals and category totals', () async {
      final start = DateTime(2026, 9);
      final end = DateTime(2026, 11);
      final expenses = await harness.transactions.getTotalForPeriod(
        startDate: start,
        endDate: end,
        type: TransactionType.expense,
      );
      expect(expenses.fold((f) => throw StateError('$f'), (t) => t), 300);
      final byCategory = await harness.transactions.getCategoryTotals(
        startDate: start,
        endDate: end,
        type: TransactionType.expense,
      );
      expect(
        byCategory.fold((f) => throw StateError('$f'), (t) => t),
        {'cat_food': 300},
      );
    });

    test('the dashboard summary', () async {
      final summary = await harness.dashboardSummary(
        start: DateTime(2026, 9),
        end: DateTime(2026, 11),
      );

      expect(summary.totalExpenses.minorUnits, 300);
      expect(summary.totalIncome.minorUnits, 2000);
      expect(
        summary.topExpenseCategories.map((k, v) => MapEntry(k, v.minorUnits)),
        {'cat_food': 300},
      );
      expect(
        summary.recentTransactions.map((t) => t.id),
        isNot(contains(deletedId)),
      );
    });

    test("a budget's spent amount", () async {
      final budget =
          await harness.addBudget(categories: [allocation('cat_food', 5000)]);

      expect(budget.categories.single.spentMinor, 300);
    });
  });
}
