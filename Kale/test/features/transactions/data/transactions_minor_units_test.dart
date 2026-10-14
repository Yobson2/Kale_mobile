import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  test('create then sync sends minor units, and no currency, to the server',
      () async {
    final created = await harness.addTransaction(amountMinor: 1050);

    await harness.sync();

    final pushed = harness.server.transactions.rows[created.id]!.toJson();
    expect(pushed['amount_minor'], 1050);
    expect(pushed['amount_minor'], isA<int>());
    expect(pushed, isNot(contains('amount')));
    expect(pushed, isNot(contains('currency_code')));
  });

  test('list and dashboard totals are exact', () async {
    const eur = Currencies.eur;
    await harness.chooseBaseCurrency(eur);
    // Ten expenses of 0.10 EUR. Summed as doubles (in Dart or in SQLite's
    // REAL `sum`), 0.1 ten times is 0.9999999999999999, not 1.
    for (var i = 0; i < 10; i++) {
      await harness.addTransaction(
        amountMinor: 10,
        date: DateTime(2026, 10, 5),
      );
    }
    await harness.addTransaction(
      amountMinor: 30,
      type: TransactionType.income,
      categoryId: 'cat_salary',
      date: DateTime(2026, 10, 6),
    );

    final listed = await harness.listTransactions();
    expect(
      Money.sum(listed.map((t) => t.amountIn(eur)), eur),
      const Money.fromMinorUnits(130, eur),
    );

    final summary = await harness.dashboardSummary(
      start: DateTime(2026, 10),
      end: DateTime(2026, 11),
    );
    expect(summary.totalExpenses, const Money.fromMinorUnits(100, eur));
    expect(summary.totalIncome, const Money.fromMinorUnits(30, eur));
    expect(summary.netCashFlow, const Money.fromMinorUnits(-70, eur));
    expect(summary.topExpenseCategories, {
      'cat_food': const Money.fromMinorUnits(100, eur),
    });
    expect(summary.totalExpenses.format(locale: 'fr'), '1,00 €');
  });

  test('a soft-deleted transaction is left out of lists and totals', () async {
    final kept = await harness.addTransaction(amountMinor: 700);
    await harness.sync();
    final deleted = harness.server.transactions.rows[kept.id]!.copyWith(
      id: 'deleted-elsewhere',
      amountMinor: 999,
      deletedAt: DateTime(2026, 10, 2),
    );
    harness.server.transactions.rows[deleted.id] = deleted;

    await harness.transactions.refreshFromServer();

    expect((await harness.listTransactions()).map((t) => t.id), [kept.id]);
    final summary = await harness.dashboardSummary(
      start: DateTime(2026, 9),
      end: DateTime(2026, 11),
    );
    expect(summary.totalExpenses.minorUnits, 700);
  });
}
