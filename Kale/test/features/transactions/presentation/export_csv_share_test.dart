import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/providers/share_provider.dart';
import 'package:kale/core/services/share_service.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:kale/features/transactions/domain/usecases/export_transactions_csv_usecase.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_notifier.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';

import 'package:mocktail/mocktail.dart';

/// Never called: [_FakeExport] answers directly.
class _UnusedRepository extends Mock implements TransactionsRepository {}

class _FakeExport extends ExportTransactionsCsvUseCase {
  _FakeExport(this.csv) : super(_UnusedRepository());

  final String csv;

  @override
  Future<Either<Failure, String>> call(
    ExportTransactionsCsvParams params,
  ) async =>
      Right(csv);
}

class _FakeShare implements ShareService {
  final shared = <({String fileName, String content, String mimeType})>[];

  @override
  Future<void> shareTextFile({
    required String fileName,
    required String content,
    required String mimeType,
  }) async =>
      shared.add((fileName: fileName, content: content, mimeType: mimeType));
}

void main() {
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

  late _FakeShare share;

  ProviderContainer container(String csv) {
    share = _FakeShare();
    final c = ProviderContainer(
      overrides: [
        exportTransactionsCsvUseCaseProvider
            .overrideWithValue(_FakeExport(csv)),
        shareServiceProvider.overrideWithValue(share),
        categoriesStreamProvider.overrideWith((ref) => Stream.value(const [])),
        baseCurrencyProvider.overrideWithValue(Currencies.xof),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('opens the share sheet with the CSV file', () async {
    const csv = 'Date,Amount\r\n2026-10-02,1500\r\n2026-10-01,200\r\n';
    final c = container(csv);

    final count = await c.read(transactionsNotifierProvider.notifier).exportCsv(
          labels: labels,
          fileName: 'kale-transactions-2026-10-14.csv',
        );

    expect(count, 2);
    expect(share.shared.single.fileName, 'kale-transactions-2026-10-14.csv');
    expect(share.shared.single.content, csv);
    expect(share.shared.single.mimeType, 'text/csv');
  });

  test('does not open the share sheet when there is nothing to export',
      () async {
    final c = container('Date,Amount\r\n');

    final count = await c
        .read(transactionsNotifierProvider.notifier)
        .exportCsv(labels: labels, fileName: 'kale-transactions.csv');

    expect(count, 0);
    expect(share.shared, isEmpty);
  });
}
