import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Gets transactions with optional filters.
class GetTransactionsUseCase
    extends UseCase<List<Transaction>, GetTransactionsParams> {
  const GetTransactionsUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(
    GetTransactionsParams params,
  ) {
    return _repository.getTransactions(
      startDate: params.startDate,
      endDate: params.endDate,
      type: params.type,
      categoryId: params.categoryId,
      paymentMethod: params.paymentMethod,
    );
  }
}

/// Parameters for [GetTransactionsUseCase].
class GetTransactionsParams {
  const GetTransactionsParams({
    this.startDate,
    this.endDate,
    this.type,
    this.categoryId,
    this.paymentMethod,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? type;
  final String? categoryId;
  final PaymentMethod? paymentMethod;
}
