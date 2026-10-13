import 'package:flutter/foundation.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:kale/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';

/// The kinds of failure a [FakeRemote] can be told to produce.
enum SimulatedFailure {
  /// The call throws [NetworkException] (connection lost mid-call).
  network,

  /// The call throws [ServerException] with status 500.
  server,
}

/// What a remote datasource was asked to do.
enum RemoteOperation { fetchAll, fetch, create, update, delete }

/// One call received by a [FakeRemote], successful or not.
@immutable
class RemoteCall {
  const RemoteCall(this.operation, [this.entityId]);

  const RemoteCall.fetchAll() : this(RemoteOperation.fetchAll);
  const RemoteCall.fetch(String id) : this(RemoteOperation.fetch, id);
  const RemoteCall.create(String id) : this(RemoteOperation.create, id);
  const RemoteCall.update(String id) : this(RemoteOperation.update, id);
  const RemoteCall.delete(String id) : this(RemoteOperation.delete, id);

  final RemoteOperation operation;
  final String? entityId;

  @override
  bool operator ==(Object other) =>
      other is RemoteCall &&
      other.operation == operation &&
      other.entityId == entityId;

  @override
  int get hashCode => Object.hash(operation, entityId);

  @override
  String toString() => 'RemoteCall.${operation.name}(${entityId ?? ''})';
}

/// An in-memory stand-in for one Supabase table.
///
/// * [calls] records every call in order, including calls that failed.
/// * [rows] is what the server currently holds, keyed by client id.
///   Seed it to simulate data already on the server.
/// * [failNextCall] makes the next call fail; queue several to fail
///   several calls in a row. Calls after the queue empties succeed.
abstract class FakeRemote<M> {
  final List<RemoteCall> calls = [];
  final Map<String, M> rows = {};
  final List<SimulatedFailure> _failures = [];

  /// Makes the next not-yet-failed call throw [failure].
  void failNextCall(SimulatedFailure failure) => _failures.add(failure);

  /// Records [call], throws a queued failure if any, else runs [respond].
  @protected
  Future<T> handle<T>(RemoteCall call, T Function() respond) async {
    calls.add(call);
    if (_failures.isNotEmpty) {
      switch (_failures.removeAt(0)) {
        case SimulatedFailure.network:
          throw const NetworkException(message: 'Simulated network error');
        case SimulatedFailure.server:
          throw const ServerException(
            message: 'Simulated server error',
            statusCode: 500,
          );
      }
    }
    return respond();
  }

  @protected
  M findOrThrow(String id) =>
      rows[id] ??
      (throw const ServerException(message: 'Not found', statusCode: 404));
}

/// Fake server table for transactions.
class FakeTransactionsRemote extends FakeRemote<TransactionModel>
    implements TransactionsRemoteDataSource {
  @override
  Future<List<TransactionModel>> getAllTransactions() =>
      handle(const RemoteCall.fetchAll(), () => rows.values.toList());

  @override
  Future<TransactionModel> getTransactionById(String id) =>
      handle(RemoteCall.fetch(id), () => findOrThrow(id));

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) =>
      handle(RemoteCall.create(model.id), () => rows[model.id] = model);

  @override
  Future<TransactionModel> updateTransaction(TransactionModel model) =>
      handle(RemoteCall.update(model.id), () => rows[model.id] = model);

  @override
  Future<void> deleteTransaction(String id) =>
      handle(RemoteCall.delete(id), () => rows.remove(id));
}

/// Fake server table for budgets.
class FakeBudgetsRemote extends FakeRemote<BudgetModel>
    implements BudgetsRemoteDataSource {
  @override
  Future<List<BudgetModel>> getAllBudgets() =>
      handle(const RemoteCall.fetchAll(), () => rows.values.toList());

  @override
  Future<BudgetModel> getBudgetById(String id) =>
      handle(RemoteCall.fetch(id), () => findOrThrow(id));

  @override
  Future<BudgetModel> createBudget(BudgetModel model) =>
      handle(RemoteCall.create(model.id), () => rows[model.id] = model);

  @override
  Future<BudgetModel> updateBudget(BudgetModel model) =>
      handle(RemoteCall.update(model.id), () => rows[model.id] = model);

  @override
  Future<void> deleteBudget(String id) =>
      handle(RemoteCall.delete(id), () => rows.remove(id));
}

/// The fake backend: one [FakeRemote] per synced table.
class FakeServer {
  final transactions = FakeTransactionsRemote();
  final budgets = FakeBudgetsRemote();
}
