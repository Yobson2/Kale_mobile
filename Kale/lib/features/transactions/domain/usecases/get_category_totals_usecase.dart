import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Gets total amounts grouped by category for a period.
class GetCategoryTotalsUseCase
    extends UseCase<Map<String, double>, GetCategoryTotalsParams> {
  const GetCategoryTotalsUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, Map<String, double>>> call(
    GetCategoryTotalsParams params,
  ) {
    return _repository.getCategoryTotals(
      startDate: params.startDate,
      endDate: params.endDate,
      type: params.type,
    );
  }
}

/// Parameters for [GetCategoryTotalsUseCase].
class GetCategoryTotalsParams {
  const GetCategoryTotalsParams({
    required this.startDate,
    required this.endDate,
    this.type,
  });

  final DateTime startDate;
  final DateTime endDate;
  final TransactionType? type;
}
