import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/widgets/data_display/app_chip.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/transactions/domain/entities/category.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/entities/transaction_page.dart';
import 'package:kale/features/transactions/domain/usecases/get_transactions_page_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/watch_transaction_changes_usecase.dart';
import 'package:kale/features/transactions/presentation/pages/transactions_page.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';

import '../../../helpers/test_helpers.dart';

/// Serves pages of [all] like the database would: filtered, newest first,
/// after the cursor.
class _FakePages implements GetTransactionsPageUseCase {
  _FakePages(this.all);

  final List<Transaction> all;

  @override
  Future<Either<Failure, TransactionPage>> call(
    GetTransactionsPageParams params,
  ) async {
    final filter = params.filter;
    final rows = all.where((t) {
      if (filter.type != null && t.type != filter.type) return false;
      if (filter.search.isEmpty) return true;
      return (t.description ?? '').toLowerCase().contains(filter.search) ||
          filter.searchCategoryIds.contains(t.categoryId);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final page = rows.take(params.limit).toList();
    return Right(TransactionPage(page, hasMore: page.length == params.limit));
  }
}

class _NoChanges implements WatchTransactionChangesUseCase {
  @override
  Stream<void> call() => const Stream.empty();
}

void main() {
  final now = DateTime.now();

  Transaction tx(
    String id, {
    required DateTime date,
    TransactionType type = TransactionType.expense,
    String categoryId = 'cat_food',
    String? description,
  }) =>
      Transaction(
        id: id,
        amountMinor: 1000,
        type: type,
        categoryId: categoryId,
        date: date,
        paymentMethod: PaymentMethod.cash,
        description: description,
        createdAt: date,
        updatedAt: date,
      );

  final transactions = [
    tx('t1', date: now, description: 'Lunch today'),
    tx(
      't2',
      date: now.subtract(const Duration(days: 1)),
      type: TransactionType.income,
      categoryId: 'cat_salary',
      description: 'Salary yesterday',
    ),
    tx('t3', date: now.subtract(const Duration(days: 3)), description: 'Taxi'),
    tx(
      't4',
      date: now.subtract(const Duration(days: 40)),
      description: 'Old rent',
      categoryId: 'cat_rent',
    ),
  ];

  Future<void> pumpPage(WidgetTester tester) async {
    final overrides = await createTestOverrides();
    await tester.pumpWidget(
      createTestApp(
        child: const TransactionsPage(),
        overrides: [
          ...overrides,
          getTransactionsPageUseCaseProvider
              .overrideWithValue(_FakePages(transactions)),
          watchTransactionChangesUseCaseProvider
              .overrideWithValue(_NoChanges()),
          baseCurrencyProvider.overrideWithValue(Currencies.xof),
          categoriesStreamProvider.overrideWith(
            (ref) => Stream.value([
              for (final (id, name) in [
                ('cat_food', 'Food'),
                ('cat_salary', 'Salary'),
                ('cat_rent', 'Rent'),
              ])
                Category(
                  id: id,
                  name: name,
                  icon: 'restaurant',
                  color: '#000000',
                  type: CategoryType.expense,
                  createdAt: DateTime(2026),
                ),
            ]),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('groups the loaded rows under day headers', (tester) async {
    await pumpPage(tester);

    // Headers are shown in capitals.
    for (final header in ['TODAY', 'YESTERDAY', 'THIS WEEK', 'EARLIER']) {
      expect(find.text(header), findsOneWidget, reason: header);
    }
    for (final description in [
      'Lunch today',
      'Salary yesterday',
      'Taxi',
      'Old rent',
    ]) {
      expect(find.text(description), findsOneWidget, reason: description);
    }
  });

  testWidgets('the type chips filter the list', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(AppChip, 'Income'));
    await tester.pumpAndSettle();

    expect(find.text('Salary yesterday'), findsOneWidget);
    expect(find.text('Lunch today'), findsNothing);
    expect(find.text('Old rent'), findsNothing);
  });

  testWidgets('search matches a description or a category name',
      (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), 'taxi');
    // The search field waits 400 ms before searching.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Taxi'), findsOneWidget);
    expect(find.text('Lunch today'), findsNothing);

    await tester.enterText(find.byType(TextField), 'rent');
    // The search field waits 400 ms before searching.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Old rent'), findsOneWidget);
    expect(find.text('Taxi'), findsNothing);
  });
}
