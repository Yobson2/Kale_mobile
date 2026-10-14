import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/usecases/create_budget_usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  const october = (CalendarDate(2026, 10, 1), CalendarDate(2026, 10, 31));

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

  group('amounts', () {
    test('spent and remaining are exact in minor units', () async {
      const eur = Currencies.eur;
      await harness.chooseBaseCurrency(eur);
      final budget = await harness.addBudget(
        totalIncomeMinor: 50000,
        categories: [
          allocation('cat_food', 150),
          allocation('cat_rent', 40000),
        ],
      );
      // Ten expenses of 0.10 EUR. Summed as doubles, 0.1 ten times is
      // 0.9999999999999999, not 1.
      for (var i = 0; i < 10; i++) {
        await harness.addTransaction(
          amountMinor: 10,
          date: DateTime(2026, 10, 5 + i),
        );
      }
      // Rent's spending counts toward rent only. Income and a day outside
      // the period count toward nothing.
      await harness.addTransaction(amountMinor: 999, categoryId: 'cat_rent');
      await harness.addTransaction(
        amountMinor: 7,
        type: TransactionType.income,
        date: DateTime(2026, 10, 6),
      );
      await harness.addTransaction(
        amountMinor: 5,
        date: DateTime(2026, 11, 2),
      );

      final read = await readBudget(budget.id);
      final food =
          read.categories.singleWhere((c) => c.categoryId == 'cat_food');

      expect(food.allocatedMinor, 150);
      expect(food.spentMinor, 100);
      expect(food.remainingMinor, 50);
      expect(read.totalAllocatedMinor, 40150);
      expect(read.totalSpentMinor, 1099);
      expect(read.remainingMinor, 39051);
      expect(read.totalIncomeIn(eur), const Money.fromMinorUnits(50000, eur));
      expect(food.spentIn(eur).format(locale: 'fr'), '1,00 €');
      expect(food.remainingIn(eur).format(locale: 'fr'), '0,50 €');
    });

    test('overspending leaves a negative remainder, exactly', () async {
      final budget = await harness.addBudget(
        categories: [allocation('cat_food', 5000)],
      );
      await harness.addTransaction(amountMinor: 5001);

      final food = (await readBudget(budget.id)).categories.single;

      expect(food.remainingMinor, -1);
    });

    test('create then sync sends integer minor units to the server', () async {
      final budget = await harness.addBudget(totalIncomeMinor: 250000);

      await harness.sync();

      final pushed = harness.server.budgets.rows[budget.id]!.toJson();
      expect(pushed['total_income_minor'], 250000);
      expect(pushed['total_income_minor'], isA<int>());
      expect(pushed, isNot(contains('total_income')));
    });
  });

  group('period dates', () {
    test('every moment of the first and last day counts, nothing outside',
        () async {
      final budget = await harness.addBudget(
        categories: [allocation('cat_food', 100000)],
      );
      await harness.addTransaction(amountMinor: 1, date: DateTime(2026, 10));
      await harness.addTransaction(
        amountMinor: 20,
        date: DateTime(2026, 10, 31, 23, 59, 30),
      );
      await harness.addTransaction(
        amountMinor: 300,
        date: DateTime(2026, 9, 30, 23, 59, 59),
      );
      await harness.addTransaction(amountMinor: 4000, date: DateTime(2026, 11));

      final food = (await readBudget(budget.id)).categories.single;

      expect(food.spentMinor, 21);
    });

    test('periods reach the server as plain dates, with no time or offset',
        () async {
      final budget = await harness.addBudget();

      await harness.sync();

      final pushed = harness.server.budgets.rows[budget.id]!.toJson();
      expect(pushed['start_date'], '2026-10-01');
      expect(pushed['end_date'], '2026-10-31');
    });

    test('a time-zone or clock change does not shift the days a budget covers',
        () async {
      // Dart can't switch a running process to another time zone, so this
      // restores the backup on a second device and changes its clock: the
      // stored period has no instant in it that either could shift.
      final created = await harness.addBudget();
      await harness.sync();
      final backedUp = harness.server.budgets.rows[created.id]!;
      final elsewhere = SyncHarness();
      addTearDown(elsewhere.dispose);
      elsewhere.server.budgets.rows[created.id] = backedUp;

      await elsewhere.budgets.refreshFromServer();
      // The device clock jumps to another day and the app restarts.
      elsewhere
        ..clock.moveTo(DateTime(2026, 11, 1, 13))
        ..restartApp();

      final restored = (await elsewhere.budgets.getBudgets())
          .fold((f) => throw StateError('$f'), (b) => b)
          .single;
      expect(restored.startDate, october.$1);
      expect(restored.endDate, october.$2);

      Future<String?> activeOn(CalendarDate day) async =>
          (await elsewhere.budgets.getActiveBudget(today: day))
              .fold((f) => throw StateError('$f'), (b) => b?.id);
      expect(await activeOn(const CalendarDate(2026, 9, 30)), isNull);
      expect(await activeOn(const CalendarDate(2026, 10, 1)), created.id);
      expect(await activeOn(const CalendarDate(2026, 10, 31)), created.id);
      expect(await activeOn(const CalendarDate(2026, 11, 1)), isNull);
    });
  });

  group('period start day', () {
    Future<Budget> create({
      required CalendarDate today,
      int? periodStartDay,
    }) async {
      final params = periodStartDay == null
          ? CreateBudgetParams(
              name: 'Budget',
              strategy: BudgetStrategy.custom,
              period: BudgetPeriod.monthly,
              today: today,
              categories: const [],
            )
          : CreateBudgetParams(
              name: 'Budget',
              strategy: BudgetStrategy.custom,
              period: BudgetPeriod.monthly,
              today: today,
              periodStartDay: periodStartDay,
              categories: const [],
            );
      final result = await harness.createBudget(params);
      return result.fold((f) => throw StateError('$f'), (b) => b);
    }

    test('by default a monthly budget covers the calendar month', () async {
      final budget = await create(today: const CalendarDate(2026, 10, 14));

      final read = await readBudget(budget.id);
      expect(read.periodStartDay, 1);
      expect((read.startDate, read.endDate), october);
    });

    test('a start day of 25 is stored, synced and used for the period',
        () async {
      final budget = await create(
        today: const CalendarDate(2026, 10, 14),
        periodStartDay: 25,
      );
      await harness.sync();

      final read = await readBudget(budget.id);
      expect(read.periodStartDay, 25);
      expect(read.startDate, const CalendarDate(2026, 9, 25));
      expect(read.endDate, const CalendarDate(2026, 10, 24));
      final pushed = harness.server.budgets.rows[budget.id]!.toJson();
      expect(pushed['period_start_day'], 25);
    });
  });
}
