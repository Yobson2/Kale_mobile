import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';

part 'transactions_state.freezed.dart';

/// Represents the state of transaction operations (create, update, delete).
@freezed
sealed class TransactionsState with _$TransactionsState {
  /// Initial state before any operation.
  const factory TransactionsState.initial() = TransactionsInitial;

  /// Loading state during an operation.
  const factory TransactionsState.loading() = TransactionsLoading;

  /// An operation completed successfully.
  const factory TransactionsState.success({String? message}) =
      TransactionsSuccess;

  /// A single transaction was loaded.
  const factory TransactionsState.loaded(Transaction transaction) =
      TransactionsLoaded;

  /// An error occurred during an operation.
  const factory TransactionsState.error(String message) = TransactionsError;
}
