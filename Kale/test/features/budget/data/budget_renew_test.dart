import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/usecases/get_budget_to_renew_usecase.dart';
import 'package:kale/features/budget/domain/usecases/renew_budget_usecase.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  const today = CalendarDate(2026, 10, 13);

  RenewBudgetUseCase renew() => RenewBudgetUseCase(harness.budgets);
  GetBudgetToRenewUseCase toRenew() => GetBudgetToRenewUseCase(harness.budgets);

  BudgetCategoryAllocation allocation(String categoryId, int minor) =>
      BudgetCategoryAllocation(
        id: '',
        budgetId: '',
        categoryId: categoryId,
        groupName: 'Needs',
        allocatedMinor: minor,
        spentMinor: 0,
        createdAt: DateTime(2026, 9),
      );

  /// A budget that ran from [start] to [end].
  Future<Budget> pastBudget({
    required CalendarDate start,
    required CalendarDate end,
    String name = 'Pay month',
    BudgetPeriod period = BudgetPeriod.monthly,
    int startDay = 1,
  }) async {
    final result = await harness.budgets.createBudget(
      name: name,
      strategy: BudgetStrategy.custom,
      period: period,
      startDate: start,
      endDate: end,
      periodStartDay: startDay,
      totalIncomeMinor: 200000,
      isPercentageBased: false,
      categories: [
        allocation('cat_food', 50000),
        allocation('cat_rent', 80000),
      ],
    );
    return result.fold((f) => throw StateError('$f'), (b) => b);
  }

  Future<Budget?> budgetToRenew() async =>
      (await toRenew()(today)).fold((f) => throw StateError('$f'), (b) => b);

  test(
      'renewing starts the same budget for the period containing today, '
      'from its start day, and it syncs', () async {
    final ended = await pastBudget(
      start: const CalendarDate(2026, 8, 25),
      end: const CalendarDate(2026, 9, 24),
      startDay: 25,
    );
    await harness.sync();
    harness.server.budgets.calls.clear();
    harness.server.budgetCategories.calls.clear();

    final result =
        await renew()(RenewBudgetParams(budget: ended, today: today));

    final renewed = result.fold((f) => throw StateError('$f'), (b) => b);
    expect(renewed.id, isNot(ended.id));
    expect(renewed.startDate, const CalendarDate(2026, 9, 25));
    expect(renewed.endDate, const CalendarDate(2026, 10, 24));
    expect(renewed.name, ended.name);
    expect(renewed.periodStartDay, 25);
    expect(renewed.totalIncomeMinor, 200000);
    expect(
      {for (final c in renewed.categories) c.categoryId: c.allocatedMinor},
      {'cat_food': 50000, 'cat_rent': 80000},
    );
    expect(
      renewed.categories.map((c) => c.id).toSet(),
      isNot(containsAll(ended.categories.map((c) => c.id))),
    );

    await harness.sync();
    expect(harness.server.budgets.calls, [RemoteCall.create(renewed.id)]);
    expect(
      harness.server.budgetCategories.calls,
      [for (final c in renewed.categories) RemoteCall.create(c.id)],
    );
  });

  test('a weekly budget renews into the week containing today', () async {
    final ended = await pastBudget(
      start: const CalendarDate(2026, 9, 26),
      end: const CalendarDate(2026, 10, 2),
      period: BudgetPeriod.weekly,
      startDay: 6, // Saturday
    );

    final renewed =
        (await renew()(RenewBudgetParams(budget: ended, today: today)))
            .fold((f) => throw StateError('$f'), (b) => b);

    // 13 Oct 2026 is a Tuesday: the week runs Saturday 10th to Friday 16th.
    expect(renewed.startDate, const CalendarDate(2026, 10, 10));
    expect(renewed.endDate, const CalendarDate(2026, 10, 16));
  });

  test('a period cannot be renewed twice', () async {
    final ended = await pastBudget(
      start: const CalendarDate(2026, 9, 1),
      end: const CalendarDate(2026, 9, 30),
    );
    await renew()(RenewBudgetParams(budget: ended, today: today));

    final again = await renew()(RenewBudgetParams(budget: ended, today: today));

    expect(again.fold((f) => f, (_) => null), isA<ValidationFailure>());
    final budgets = (await harness.budgets.getBudgets())
        .fold((f) => throw StateError('$f'), (b) => b);
    expect(budgets, hasLength(2));
  });

  group('the budget offered for renewal', () {
    test('is the one that ended most recently', () async {
      await pastBudget(
        start: const CalendarDate(2026, 8, 1),
        end: const CalendarDate(2026, 8, 31),
        name: 'August',
      );
      await pastBudget(
        start: const CalendarDate(2026, 9, 1),
        end: const CalendarDate(2026, 9, 30),
        name: 'September',
      );

      expect((await budgetToRenew())?.name, 'September');
    });

    test('is none while a budget covers today', () async {
      await pastBudget(
        start: const CalendarDate(2026, 9, 1),
        end: const CalendarDate(2026, 9, 30),
      );
      await pastBudget(
        start: const CalendarDate(2026, 10, 1),
        end: const CalendarDate(2026, 10, 31),
      );

      expect(await budgetToRenew(), isNull);
    });

    test('is none once the ended budget was renewed', () async {
      final ended = await pastBudget(
        start: const CalendarDate(2026, 9, 1),
        end: const CalendarDate(2026, 9, 30),
      );
      await renew()(RenewBudgetParams(budget: ended, today: today));

      expect(await budgetToRenew(), isNull);
    });

    test('is none when there has never been a budget', () async {
      expect(await budgetToRenew(), isNull);
    });
  });
}
