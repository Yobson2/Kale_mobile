import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Creates a new transaction. Works offline via local save + sync queue.
class CreateTransactionUseCase
    extends UseCase<Transaction, CreateTransactionParams> {
  const CreateTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Either<Failure, Transaction>> call(CreateTransactionParams params) {
    return _repository.createTransaction(
      amountMinor: params.amountMinor,
      type: params.type,
      categoryId: params.categoryId,
      date: params.date,
      paymentMethod: params.paymentMethod,
      description: params.description,
      mobileMoneyProvider: params.mobileMoneyProvider,
      mobileMoneyRef: params.mobileMoneyRef,
    );
  }
}

/// Parameters for [CreateTransactionUseCase].
class CreateTransactionParams {
  const CreateTransactionParams({
    required this.amountMinor,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.paymentMethod,
    this.description,
    this.mobileMoneyProvider,
    this.mobileMoneyRef,
  });

  /// Amount in minor units of the base currency.
  final int amountMinor;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final String? description;
  final String? mobileMoneyProvider;
  final String? mobileMoneyRef;
}
