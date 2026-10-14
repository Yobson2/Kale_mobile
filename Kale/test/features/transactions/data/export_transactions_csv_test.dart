import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';
import 'package:kale/features/transactions/domain/usecases/export_transactions_csv_usecase.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  const labels = CsvLabels(
    date: 'Date',
    type: 'Type',
    category: 'Category',
    description: 'Description',
    amount: 'Amount',
    currency: 'Currency',
    paymentMethod: 'Payment method',
    mobileMoneyProvider: 'Mobile money provider',
    types: {},
    paymentMethods: {},
  );

  Future<String> export({DateTime? from, DateTime? to}) async {
    final result = await ExportTransactionsCsvUseCase(harness.transactions)(
      ExportTransactionsCsvParams(
        labels: labels,
        categoryNames: const {},
        currency: Currencies.xof,
        startDate: from,
        endDate: to,
      ),
    );
    return result.fold((f) => throw StateError('$f'), (csv) => csv);
  }

  int rows(String csv) => '\r\n'.allMatches(csv).length - 1;

  test('leaves deleted transactions out', () async {
    final kept = await harness.addTransaction(description: 'kept');
    final deleted = await harness.addTransaction(description: 'deleted');
    await harness.transactions.deleteTransaction(deleted.id);

    final csv = await export();

    expect(rows(csv), 1);
    expect(csv, contains(kept.description));
    expect(csv, isNot(contains('deleted')));
  });

  test('a date range keeps only the transactions within it', () async {
    await harness.addTransaction(date: DateTime(2026, 9, 30));
    await harness.addTransaction(date: DateTime(2026, 10, 15));
    await harness.addTransaction(date: DateTime(2026, 11));

    final csv = await export(
      from: DateTime(2026, 10),
      to: DateTime(2026, 10, 31, 23, 59, 59),
    );

    expect(rows(csv), 1);
    expect(csv, contains('2026-10-15'));
  });

  test('exports 10,000 transactions', () async {
    await harness.db.transactionsDao.upsertAll([
      for (var i = 0; i < 10000; i++)
        TransactionModel(
          id: 'tx-$i',
          amountMinor: i + 1,
          type: 'expense',
          categoryId: 'cat_food',
          date: DateTime(2026).add(Duration(hours: i)),
          paymentMethod: 'cash',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ).toDriftCompanion(isSynced: true),
    ]);

    final csv = await export();

    expect(rows(csv), 10000);
  });
}
