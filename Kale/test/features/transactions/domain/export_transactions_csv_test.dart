import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/usecases/export_transactions_csv_usecase.dart';

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
    types: {
      TransactionType.income: 'Income',
      TransactionType.expense: 'Expense',
    },
    paymentMethods: {
      PaymentMethod.cash: 'Cash',
      PaymentMethod.mobileMoney: 'Mobile Money',
    },
  );

  Transaction tx(
    String id,
    int amountMinor, {
    DateTime? date,
    String? description,
    TransactionType type = TransactionType.expense,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    String? provider,
  }) =>
      Transaction(
        id: id,
        amountMinor: amountMinor,
        type: type,
        categoryId: 'cat_food',
        date: date ?? DateTime(2026, 10, 2, 13, 45),
        paymentMethod: paymentMethod,
        description: description,
        mobileMoneyProvider: provider,
        createdAt: DateTime(2026, 10, 2),
        updatedAt: DateTime(2026, 10, 2),
      );

  List<String> lines(String csv) => csv.split('\r\n')..removeLast();

  test('writes a header row, ISO dates and exact XOF amounts', () {
    final csv = buildTransactionsCsv(
      [
        tx(
          't1',
          1500,
          description: 'Lunch',
          paymentMethod: PaymentMethod.mobileMoney,
          provider: 'Orange Money',
        ),
      ],
      labels: labels,
      categoryNames: {'cat_food': 'Food'},
      currency: Currencies.xof,
    );

    const header = 'Date,Type,Category,Description,Amount,Currency,'
        'Payment method,Mobile money provider';
    expect(lines(csv), [
      header,
      '2026-10-02,Expense,Food,Lunch,1500,XOF,Mobile Money,Orange Money',
    ]);
  });

  test('writes EUR amounts with their two decimals, exactly', () {
    final csv = buildTransactionsCsv(
      [tx('t1', 1050), tx('t2', 5, date: DateTime(2026, 10)), tx('t3', 100000)],
      labels: labels,
      categoryNames: const {},
      currency: Currencies.eur,
    );

    expect(
      lines(csv).skip(1).map((l) => l.split(',')[4]),
      // t1 and t3 share a date; ties go by id, highest first.
      ['1000.00', '10.50', '0.05'],
    );
  });

  test('quotes fields with commas, quotes or line breaks', () {
    final csv = buildTransactionsCsv(
      [tx('t1', 100, description: 'Rice, oil and "sugar"\nfor the week')],
      labels: labels,
      categoryNames: {'cat_food': 'Food'},
      currency: Currencies.xof,
    );

    expect(
      csv,
      contains('"Rice, oil and ""sugar""\nfor the week"'),
    );
  });

  test('lists the newest transactions first', () {
    final csv = buildTransactionsCsv(
      [
        tx('old', 1, date: DateTime(2026)),
        tx('new', 2, date: DateTime(2026, 12)),
      ],
      labels: labels,
      categoryNames: const {},
      currency: Currencies.xof,
    );

    expect(lines(csv)[1], startsWith('2026-12-01'));
    expect(lines(csv)[2], startsWith('2026-01-01'));
  });

  group('decimalAmount', () {
    test('handles zero decimals, padding and negatives', () {
      expect(decimalAmount(1500, 0), '1500');
      expect(decimalAmount(1050, 2), '10.50');
      expect(decimalAmount(5, 2), '0.05');
      expect(decimalAmount(0, 2), '0.00');
      expect(decimalAmount(-5, 2), '-0.05');
    });
  });
}
