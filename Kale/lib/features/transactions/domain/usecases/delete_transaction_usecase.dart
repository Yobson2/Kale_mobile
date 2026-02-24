import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Deletes a transaction by ID.
class DeleteTransactionUseCase extends UseCase<void, String> {
  const DeleteTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.deleteTransaction(params);
  }
}
