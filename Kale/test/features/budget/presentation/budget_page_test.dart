import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/presentation/pages/budget_page.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  BudgetCategoryAllocation food({required int allocated, required int spent}) =>
      BudgetCategoryAllocation(
        id: 'a1',
        budgetId: 'b1',
        categoryId: 'cat_food',
        groupName: 'Needs',
        allocatedMinor: allocated,
        spentMinor: spent,
        createdAt: DateTime(2026, 10),
      );

  Budget budget(List<BudgetCategoryAllocation> categories) => Budget(
        id: 'b1',
        name: 'October 2026 Budget',
        strategy: BudgetStrategy.custom,
        period: BudgetPeriod.monthly,
        startDate: const CalendarDate(2026, 10, 1),
        endDate: const CalendarDate(2026, 10, 31),
        categories: categories,
        createdAt: DateTime(2026, 10),
        updatedAt: DateTime(2026, 10),
      );

  Future<void> pumpPage(
    WidgetTester tester, {
    required Budget active,
    required Currency currency,
  }) async {
    await tester.pumpWidget(
      createTestApp(
        child: const BudgetPage(),
        overrides: [
          activeBudgetProvider.overrideWith((ref) async => active),
          baseCurrencyProvider.overrideWithValue(currency),
          categoryNamesProvider
              .overrideWith((ref) async => {'cat_food': 'Food'}),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('amounts are shown exactly, in the base currency format',
      (tester) async {
    await pumpPage(
      tester,
      active: budget([food(allocated: 15050, spent: 1005)]),
      currency: Currencies.eur,
    );

    // The test app runs in English: symbol first, two decimals.
    expect(find.text('€10.05'), findsOneWidget);
    expect(find.text('of €150.50 budget'), findsOneWidget);
    expect(find.text('€10.05 / €150.50'), findsNWidgets(2));
  });

  testWidgets('a currency without minor units shows no decimals',
      (tester) async {
    await pumpPage(
      tester,
      active: budget([food(allocated: 150000, spent: 25000)]),
      currency: Currencies.xof,
    );

    expect(find.text('FCFA 25,000'), findsOneWidget);
    expect(find.text('of FCFA 150,000 budget'), findsOneWidget);
  });
}
