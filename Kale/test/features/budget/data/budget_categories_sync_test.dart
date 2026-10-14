import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  /// An allocation as the budget setup screen sends it: no id yet.
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

  Future<Budget> readBudget(String id) async {
    final budgets = (await harness.budgets.getBudgets())
        .fold((f) => throw StateError('$f'), (b) => b);
    return budgets.singleWhere((b) => b.id == id);
  }

  /// Saves [budget] with [categories], as the setup screen does on edit.
  Future<Budget> editAllocations(
    Budget budget,
    List<BudgetCategoryAllocation> categories,
  ) async {
    final result = await harness.budgets.updateBudget(
      id: budget.id,
      name: budget.name,
      strategy: budget.strategy,
      period: budget.period,
      startDate: budget.startDate,
      endDate: budget.endDate,
      categories: categories,
    );
    return result.fold((f) => throw StateError('$f'), (b) => b);
  }

  Map<String, int> allocatedByCategory(Budget budget) => {
        for (final c in budget.categories) c.categoryId: c.allocatedMinor,
      };

  test(
    'a budget and every allocation reach the server, the budget first',
    () async {
      final budget = await harness.addBudget(
        categories: [
          allocation('cat_food', 15000),
          allocation('cat_rent', 400),
        ],
      );
      final ids = budget.categories.map((c) => c.id).toList();

      await harness.sync();

      expect(harness.server.budgets.calls, [RemoteCall.create(budget.id)]);
      // The fake server, like the real foreign key, refuses an allocation
      // whose budget it does not hold yet: these creates succeeded, so the
      // budget was pushed before them.
      expect(
        harness.server.budgetCategories.calls,
        [for (final id in ids) RemoteCall.create(id)],
      );
      final rows = harness.server.budgetCategories.rows.values;
      expect(rows.map((r) => r.budgetId), everyElement(budget.id));
      expect(
        {for (final r in rows) r.categoryId: r.allocatedMinor},
        {'cat_food': 15000, 'cat_rent': 400},
      );
      expect(harness.backupStatus.pendingCount, 0);
      expect(harness.backupStatus.stuckCount, 0);
    },
  );

  test('allocations are sent as integer minor units, owned by their budget',
      () async {
    final budget =
        await harness.addBudget(categories: [allocation('cat_food', 1050)]);

    await harness.sync();

    final json = harness
        .server.budgetCategories.rows[budget.categories.single.id]!
        .toJson();
    expect(json['allocated_minor'], 1050);
    expect(json['budget_id'], budget.id);
    expect(json, isNot(contains('user_id')));
    expect(json, isNot(contains('allocated_amount')));
  });

  test(
    'editing a budget updates its allocations in place, creates new ones '
    'and deletes dropped ones',
    () async {
      final budget = await harness.addBudget(
        categories: [allocation('cat_food', 100), allocation('cat_rent', 200)],
      );
      await harness.sync();
      final foodId =
          budget.categories.singleWhere((c) => c.categoryId == 'cat_food').id;
      final rentId =
          budget.categories.singleWhere((c) => c.categoryId == 'cat_rent').id;
      harness.server.budgetCategories.calls.clear();

      // The setup screen sends allocations without ids, even when editing.
      final edited = await editAllocations(budget, [
        allocation('cat_food', 150),
        allocation('cat_transport', 50),
      ]);
      await harness.sync();

      final transportId = edited.categories
          .singleWhere((c) => c.categoryId == 'cat_transport')
          .id;
      expect(
        edited.categories.singleWhere((c) => c.categoryId == 'cat_food').id,
        foodId,
      );
      expect(harness.server.budgetCategories.calls, [
        RemoteCall.update(foodId),
        RemoteCall.create(transportId),
        RemoteCall.delete(rentId),
      ]);
      expect(
        {
          for (final r in harness.server.budgetCategories.rows.values)
            r.categoryId: r.allocatedMinor,
        },
        {'cat_food': 150, 'cat_transport': 50},
      );
      expect(allocatedByCategory(await readBudget(budget.id)), {
        'cat_food': 150,
        'cat_transport': 50,
      });
    },
  );

  test('allocations queued offline sync after a relaunch', () async {
    harness.online = false;
    final budget =
        await harness.addBudget(categories: [allocation('cat_food', 700)]);

    harness
      ..restartApp()
      ..online = true;
    await harness.sync();

    expect(
      harness.server.budgetCategories.calls,
      [RemoteCall.create(budget.categories.single.id)],
    );
  });

  test('restoring on an empty device brings allocations back with the budget',
      () async {
    final budget = await harness.addBudget(
      categories: [allocation('cat_food', 1200), allocation('cat_rent', 800)],
    );
    await harness.sync();
    await harness.db.clearAllData();

    final result = await harness.budgets.refreshFromServer();

    expect(result.isRight(), isTrue);
    final restored = await readBudget(budget.id);
    expect(allocatedByCategory(restored), {'cat_food': 1200, 'cat_rent': 800});
    expect(
      restored.categories.map((c) => c.id).toSet(),
      budget.categories.map((c) => c.id).toSet(),
    );
  });

  test('a refresh keeps an allocation edit that is not backed up yet',
      () async {
    final budget =
        await harness.addBudget(categories: [allocation('cat_food', 100)]);
    await harness.sync();
    harness.online = false;
    await editAllocations(budget, [allocation('cat_food', 999)]);
    harness.online = true;

    await harness.budgets.refreshFromServer();

    expect(allocatedByCategory(await readBudget(budget.id)), {'cat_food': 999});
  });

  test('deleting a budget leaves no allocation on the server', () async {
    final budget =
        await harness.addBudget(categories: [allocation('cat_food', 100)]);
    await harness.sync();

    await harness.budgets.deleteBudget(budget.id);
    await harness.sync();

    expect(harness.server.budgets.rows, isEmpty);
    expect(harness.server.budgetCategories.rows, isEmpty);
    expect(harness.backupStatus.stuckCount, 0);
  });
}
