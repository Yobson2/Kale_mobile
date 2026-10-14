import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// Emits whenever stored transactions change (created, edited, deleted,
/// pulled), so the transaction list can refresh the rows it shows.
class WatchTransactionChangesUseCase {
  /// Creates a [WatchTransactionChangesUseCase].
  const WatchTransactionChangesUseCase(this._repository);

  final TransactionsRepository _repository;

  /// The change notifications.
  Stream<void> call() => _repository.watchTransactionChanges();
}
