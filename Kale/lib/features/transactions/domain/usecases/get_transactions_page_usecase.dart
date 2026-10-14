import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction_page.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Loads one page of the transaction list (newest first, keyset-paged), so
/// the list never holds more than what the user has scrolled through.
class GetTransactionsPageUseCase
    extends UseCase<TransactionPage, GetTransactionsPageParams> {
  /// Creates a [GetTransactionsPageUseCase].
  const GetTransactionsPageUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, TransactionPage>> call(
    GetTransactionsPageParams params,
  ) =>
      _repository.getTransactionsPage(
        filter: params.filter,
        limit: params.limit,
        after: params.after,
        until: params.until,
      );
}

/// Parameters for [GetTransactionsPageUseCase].
class GetTransactionsPageParams {
  /// Creates [GetTransactionsPageParams].
  const GetTransactionsPageParams({
    required this.filter,
    required this.limit,
    this.after,
    this.until,
  });

  /// What the list shows.
  final TransactionListFilter filter;

  /// Rows per page.
  final int limit;

  /// The last row already loaded; null for the first page.
  final TransactionCursor? after;

  /// The last row to include, to reload exactly what is already shown.
  final TransactionCursor? until;
}
