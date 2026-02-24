import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Gets the total amount for a period and type.
class GetPeriodSummaryUseCase
    extends UseCase<double, GetPeriodSummaryParams> {
  const GetPeriodSummaryUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, double>> call(GetPeriodSummaryParams params) {
    return _repository.getTotalForPeriod(
      startDate: params.startDate,
      endDate: params.endDate,
      type: params.type,
    );
  }
}

/// Parameters for [GetPeriodSummaryUseCase].
class GetPeriodSummaryParams {
  const GetPeriodSummaryParams({
    required this.startDate,
    required this.endDate,
    required this.type,
  });

  final DateTime startDate;
  final DateTime endDate;
  final TransactionType type;
}
