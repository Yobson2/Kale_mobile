import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/presentation/pages/budget_setup_page.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  final existing = Budget(
    id: 'b1',
    name: 'October 2026 Budget',
    strategy: BudgetStrategy.custom,
    period: BudgetPeriod.monthly,
    startDate: const CalendarDate(2026, 10, 1),
    endDate: const CalendarDate(2026, 10, 31),
    totalIncomeMinor: 150050,
    categories: [
      BudgetCategoryAllocation(
        id: 'a1',
        budgetId: 'b1',
        categoryId: 'cat_food',
        groupName: 'Needs',
        allocatedMinor: 40025,
        spentMinor: 0,
        createdAt: DateTime(2026, 10),
      ),
    ],
    createdAt: DateTime(2026, 10),
    updatedAt: DateTime(2026, 10),
  );

  Future<void> pumpSetup(WidgetTester tester) async {
    await tester.pumpWidget(
      createTestApp(
        child: BudgetSetupPage(existingBudget: existing),
        overrides: [baseCurrencyProvider.overrideWithValue(Currencies.eur)],
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> continueToNextStep(WidgetTester tester) async {
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
  }

  testWidgets('the money to budget is entered in the base currency',
      (tester) async {
    await pumpSetup(tester);
    await continueToNextStep(tester);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, '1,500.50');
    expect(field.decoration!.prefixText, '€ ');
  });

  testWidgets('allocations add up exactly in the base currency format',
      (tester) async {
    await pumpSetup(tester);
    await continueToNextStep(tester);
    await tester.enterText(find.byType(TextField), '1000.10');
    await continueToNextStep(tester);

    // The custom strategy starts with no amounts; allocate 0.10 + 0.20.
    final rows = find.byType(TextField);
    await tester.enterText(rows.at(0), '0.10');
    await tester.enterText(rows.at(1), '0.20');
    await tester.pumpAndSettle();

    expect(find.text('€999.80'), findsOneWidget);
    expect(find.text('€0.30 / €1,000.10'), findsOneWidget);
  });
}
