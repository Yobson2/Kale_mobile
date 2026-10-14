import 'package:flutter/foundation.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kale/features/auth/data/models/tokens_model.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:kale/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';
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

  /// Who made each of [calls]: the signed-in user's id, or `null` when
  /// nobody was signed in. Like Supabase stamping `user_id` from the
  /// session.
  final List<String?> callers = [];
  final Map<String, M> rows = {};
  final List<SimulatedFailure> _failures = [];

  /// The session the calls are made under. Set by [FakeServer].
  FakeAuthRemote? session;

  /// Makes the next not-yet-failed call throw [failure].
  void failNextCall(SimulatedFailure failure) => _failures.add(failure);

  /// Records [call], throws a queued failure if any, else runs [respond].
  @protected
  Future<T> handle<T>(RemoteCall call, T Function() respond) async {
    calls.add(call);
    callers.add(session?.currentUserId);
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
      (visible(id) ? rows[id] : null) ??
      (throw const ServerException(message: 'Not found', statusCode: 404));

  /// Who wrote each row, like Supabase stamping `user_id`. Rows seeded
  /// straight into [rows] have no owner and every user sees them.
  final Map<String, String?> owners = {};

  /// Stores [model] under [id], owned by the signed-in user.
  @protected
  M put(String id, M model) {
    owners[id] = session?.currentUserId;
    return rows[id] = model;
  }

  /// Like RLS: whether the signed-in user may read row [id].
  @protected
  bool visible(String id) {
    final owner = owners[id];
    return owner == null || owner == session?.currentUserId;
  }

  /// The rows the signed-in user may read.
  @protected
  List<M> visibleRows() => [
        for (final MapEntry(:key, :value) in rows.entries)
          if (visible(key)) value,
      ];
}

/// Fake server table for transactions.
class FakeTransactionsRemote extends FakeRemote<TransactionModel>
    implements TransactionsRemoteDataSource {
  @override
  Future<List<TransactionModel>> getAllTransactions() =>
      handle(const RemoteCall.fetchAll(), visibleRows);

  @override
  Future<TransactionModel> getTransactionById(String id) =>
      handle(RemoteCall.fetch(id), () => findOrThrow(id));

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) =>
      handle(RemoteCall.create(model.id), () => put(model.id, model));

  @override
  Future<TransactionModel> updateTransaction(TransactionModel model) =>
      handle(RemoteCall.update(model.id), () => put(model.id, model));

  @override
  Future<void> deleteTransaction(String id) =>
      handle(RemoteCall.delete(id), () => rows.remove(id));
}

/// Fake server table for budgets.
class FakeBudgetsRemote extends FakeRemote<BudgetModel>
    implements BudgetsRemoteDataSource {
  @override
  Future<List<BudgetModel>> getAllBudgets() =>
      handle(const RemoteCall.fetchAll(), visibleRows);

  @override
  Future<BudgetModel> getBudgetById(String id) =>
      handle(RemoteCall.fetch(id), () => findOrThrow(id));

  @override
  Future<BudgetModel> createBudget(BudgetModel model) =>
      handle(RemoteCall.create(model.id), () => put(model.id, model));

  @override
  Future<BudgetModel> updateBudget(BudgetModel model) =>
      handle(RemoteCall.update(model.id), () => put(model.id, model));

  @override
  Future<void> deleteBudget(String id) =>
      handle(RemoteCall.delete(id), () => rows.remove(id));
}

/// Fake server `profiles` row of the signed-in user, held in
/// `rows[ProfileModel.localId]`.
class FakeProfileRemote extends FakeRemote<ProfileModel>
    implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel?> getProfile() => handle(
        const RemoteCall.fetch(ProfileModel.localId),
        () => visible(ProfileModel.localId) ? rows[ProfileModel.localId] : null,
      );

  @override
  Future<ProfileModel> updateProfile(ProfileModel model) => handle(
        const RemoteCall.update(ProfileModel.localId),
        () => put(ProfileModel.localId, model),
      );
}

/// Fake Supabase Auth. Only anonymous and email sign-in are implemented;
/// the other flows throw until a test needs them.
class FakeAuthRemote implements AuthRemoteDataSource {
  /// The signed-in user's id, or `null` when signed out.
  String? currentUserId;

  /// How many anonymous users were created.
  int anonymousSignIns = 0;

  /// Signs in a permanent user whose id is derived from [email]. Any
  /// password is accepted.
  @override
  Future<({UserModel user, TokensModel tokens})> login({
    required String email,
    required String password,
  }) async {
    final id = 'user-$email';
    currentUserId = id;
    return (
      user: UserModel(id: id, email: email, name: email.split('@').first),
      tokens: TokensModel(accessToken: 'access-$id', refreshToken: 'r-$id'),
    );
  }

  @override
  Future<({UserModel user, TokensModel tokens})> signInAnonymously() async {
    anonymousSignIns++;
    final id = 'anon-$anonymousSignIns';
    currentUserId = id;
    return (
      user: UserModel(id: id, email: '', name: '', isAnonymous: true),
      tokens: TokensModel(accessToken: 'access-$id', refreshToken: 'r-$id'),
    );
  }

  /// How many times a user signed out.
  int logouts = 0;

  @override
  Future<void> logout() async {
    logouts++;
    currentUserId = null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('FakeAuthRemote: ${invocation.memberName}');
}

/// The fake backend: Auth, plus one [FakeRemote] per synced table.
class FakeServer {
  FakeServer() {
    for (final table in <FakeRemote<Object>>[transactions, budgets, profile]) {
      table.session = auth;
    }
  }

  final auth = FakeAuthRemote();
  final transactions = FakeTransactionsRemote();
  final budgets = FakeBudgetsRemote();
  final profile = FakeProfileRemote();
}
