import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:meta/meta.dart';

/// Builds a CSV of the user's live transactions (decision Q20: free basic
/// export). Read from the device, so it works offline; built off the main
/// isolate, so 10,000 rows never block the UI.
class ExportTransactionsCsvUseCase
    extends UseCase<String, ExportTransactionsCsvParams> {
  /// Creates an [ExportTransactionsCsvUseCase].
  const ExportTransactionsCsvUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, String>> call(
    ExportTransactionsCsvParams params,
  ) async {
    final result = await _repository.getTransactions(
      startDate: params.startDate,
      endDate: params.endDate,
    );
    return result.fold(Left.new, (transactions) async {
      final csv = await Isolate.run(
        () => buildTransactionsCsv(
          transactions,
          labels: params.labels,
          categoryNames: params.categoryNames,
          currency: params.currency,
        ),
      );
      return Right(csv);
    });
  }
}

/// Parameters for [ExportTransactionsCsvUseCase].
class ExportTransactionsCsvParams {
  /// Creates [ExportTransactionsCsvParams].
  const ExportTransactionsCsvParams({
    required this.labels,
    required this.categoryNames,
    required this.currency,
    this.startDate,
    this.endDate,
  });

  /// Header and value texts, in the app's language.
  final CsvLabels labels;

  /// Category names by id.
  final Map<String, String> categoryNames;

  /// The account's base currency: amounts are in it.
  final Currency currency;

  /// First day included, or from the first transaction when null.
  final DateTime? startDate;

  /// Last instant included, or up to now when null.
  final DateTime? endDate;
}

/// The texts of an export, in the app's language.
@immutable
class CsvLabels {
  /// Creates [CsvLabels].
  const CsvLabels({
    required this.date,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.mobileMoneyProvider,
    required this.types,
    required this.paymentMethods,
  });

  /// Column headers.
  final String date;
  final String type;
  final String category;
  final String description;
  final String amount;
  final String currency;
  final String paymentMethod;
  final String mobileMoneyProvider;

  /// The name of each transaction type.
  final Map<TransactionType, String> types;

  /// The name of each payment method.
  final Map<PaymentMethod, String> paymentMethods;
}

/// The CSV text for [transactions], newest first: RFC 4180 (comma
/// separated, fields quoted when needed, CRLF line ends), a header row,
/// ISO dates (`YYYY-MM-DD`), and amounts written exactly from their minor
/// units with [currency]'s decimal places and a `.` (`1050` EUR minor
/// units → `10.50`, `1500` XOF → `1500`). Never goes through a float.
String buildTransactionsCsv(
  List<Transaction> transactions, {
  required CsvLabels labels,
  required Map<String, String> categoryNames,
  required Currency currency,
}) {
  final rows = [...transactions]..sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.id.compareTo(a.id);
    });
  final buffer = StringBuffer();
  void writeRow(List<String> fields) {
    buffer
      ..write(fields.map(_csvField).join(','))
      ..write('\r\n');
  }

  writeRow([
    labels.date,
    labels.type,
    labels.category,
    labels.description,
    labels.amount,
    labels.currency,
    labels.paymentMethod,
    labels.mobileMoneyProvider,
  ]);
  for (final t in rows) {
    writeRow([
      _isoDate(t.date),
      labels.types[t.type] ?? t.type.name,
      categoryNames[t.categoryId] ?? t.categoryId,
      t.description ?? '',
      decimalAmount(t.amountMinor, currency.decimalPlaces),
      currency.code,
      labels.paymentMethods[t.paymentMethod] ?? t.paymentMethod.name,
      t.mobileMoneyProvider ?? '',
    ]);
  }
  return buffer.toString();
}

/// [minorUnits] as a plain decimal with [decimalPlaces] digits after a
/// `.` and no grouping: `1050`, 2 → `10.50`; `-5`, 2 → `-0.05`.
@visibleForTesting
String decimalAmount(int minorUnits, int decimalPlaces) {
  final sign = minorUnits < 0 ? '-' : '';
  final digits = minorUnits.abs().toString();
  if (decimalPlaces == 0) return '$sign$digits';
  final padded = digits.padLeft(decimalPlaces + 1, '0');
  final split = padded.length - decimalPlaces;
  return '$sign${padded.substring(0, split)}.${padded.substring(split)}';
}

String _isoDate(DateTime date) {
  final local = date.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}-${two(local.month)}-'
      '${two(local.day)}';
}

/// Quotes [value] when it holds a comma, a quote or a line break, doubling
/// inner quotes (RFC 4180).
String _csvField(String value) {
  if (!value.contains(RegExp(r'[",\r\n]'))) return value;
  return '"${value.replaceAll('"', '""')}"';
}
