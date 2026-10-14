import 'package:flutter/foundation.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kale/features/auth/data/models/tokens_model.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_remote_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:kale/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_remote_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';
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
enum RemoteOperation { fetchPage, fetch, create, update }

/// One call received by a [FakeRemote], successful or not.
@immutable
class RemoteCall {
  const RemoteCall(this.operation, [this.entityId]);

  /// A pull page request; [afterId] is the cursor's id (null: from the
  /// start).
  const RemoteCall.fetchPage([String? afterId])
      : this(RemoteOperation.fetchPage, afterId);
  const RemoteCall.fetch(String id) : this(RemoteOperation.fetch, id);
  const RemoteCall.create(String id) : this(RemoteOperation.create, id);
  const RemoteCall.update(String id) : this(RemoteOperation.update, id);

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

  /// Lets [after] more calls succeed, then makes the one after throw
  /// [failure] (e.g. the connection drops in the middle of a restore).
  void failCall({required int after, required SimulatedFailure failure}) =>
      _delayedFailures[calls.length + after] = failure;

  final Map<int, SimulatedFailure> _delayedFailures = {};

  /// Records [call], throws a queued failure if any, else runs [respond].
  @protected
  Future<T> handle<T>(RemoteCall call, T Function() respond) async {
    final delayed = _delayedFailures.remove(calls.length);
    if (delayed != null) _failures.insert(0, delayed);
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

  /// Each row's `server_updated_at`, stamped on every write like the real
  /// trigger. Rows put straight into [rows] are stamped when first paged,
  /// in insertion order.
  final Map<String, DateTime> stampedAt = {};

  /// One server clock for every table, so stamps never repeat.
  static int _ticks = 0;
  static DateTime _nextStamp() =>
      DateTime.utc(2026, 10, 13).add(Duration(microseconds: ++_ticks));

  /// Stores [model] under [id], owned by the signed-in user.
  @protected
  M put(String id, M model) {
    owners[id] = session?.currentUserId;
    stampedAt[id] = _nextStamp();
    return rows[id] = model;
  }

  /// Writes [model] on the server as another device of the same user
  /// would: the row is stamped, so the next pull picks it up.
  void seed(String id, M model) {
    stampedAt[id] = _nextStamp();
    rows[id] = model;
  }

  /// A pull page: the visible rows after [after] in
  /// `(server_updated_at, id)` order, at most [limit].
  @protected
  Future<RemotePage<M>> fetchPageOf(PullCursor? after, int limit) =>
      handle(RemoteCall.fetchPage(after?.id), () {
        for (final id in rows.keys) {
          stampedAt[id] ??= _nextStamp();
        }
        final keys = [
          for (final id in rows.keys)
            if (visible(id)) PullCursor(stampedAt[id]!, id),
        ]..sort((a, b) {
            final byTime = a.at.compareTo(b.at);
            return byTime != 0 ? byTime : a.id.compareTo(b.id);
          });
        final page = keys
            .where(
              (k) =>
                  after == null ||
                  k.at.isAfter(after.at) ||
                  (k.at == after.at && k.id.compareTo(after.id) > 0),
            )
            .take(limit)
            .toList();
        return RemotePage<M>(
          [for (final k in page) rows[k.id] as M],
          last: page.isEmpty ? null : page.last,
        );
      });

  /// Replaces row [id] with [model], like `UPDATE … RETURNING` with
  /// `.single()`: throws if the signed-in user has no such row.
  @protected
  M replace(String id, M model) {
    findOrThrow(id);
    return put(id, model);
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
  Future<RemotePage<TransactionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) =>
      fetchPageOf(after, limit);

  @override
  Future<TransactionModel> createTransaction(TransactionModel model) =>
      handle(RemoteCall.create(model.id), () => put(model.id, model));

  @override
  Future<TransactionModel> updateTransaction(TransactionModel model) =>
      handle(RemoteCall.update(model.id), () => replace(model.id, model));
}

/// Fake server table for budgets.
class FakeBudgetsRemote extends FakeRemote<BudgetModel>
    implements BudgetsRemoteDataSource {
  @override
  Future<RemotePage<BudgetModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) =>
      fetchPageOf(after, limit);

  @override
  Future<BudgetModel> createBudget(BudgetModel model) =>
      handle(RemoteCall.create(model.id), () => put(model.id, model));

  @override
  Future<BudgetModel> updateBudget(BudgetModel model) =>
      handle(RemoteCall.update(model.id), () => replace(model.id, model));
}

/// Fake server table for budget category allocations. Like the real
/// foreign key, it rejects an allocation whose budget is not on the server.
class FakeBudgetCategoriesRemote extends FakeRemote<BudgetCategoryModel>
    implements BudgetCategoriesRemoteDataSource {
  FakeBudgetCategoriesRemote(this._budgets);

  final FakeBudgetsRemote _budgets;

  @override
  Future<RemotePage<BudgetCategoryModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) =>
      fetchPageOf(after, limit);

  @override
  Future<BudgetCategoryModel> createBudgetCategory(
    BudgetCategoryModel model,
  ) =>
      handle(RemoteCall.create(model.id), () {
        if (!_budgets.rows.containsKey(model.budgetId)) {
          throw const ServerException(
            message: 'Foreign key violation: budget not found',
            statusCode: 400,
          );
        }
        return put(model.id, model);
      });

  @override
  Future<BudgetCategoryModel> updateBudgetCategory(
    BudgetCategoryModel model,
  ) =>
      handle(RemoteCall.update(model.id), () => replace(model.id, model));
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

/// Fake server table for savings goals. Like the real schema, it has no
/// trigger: a goal's saved amount is only what the device pushes.
class FakeSavingsGoalsRemote extends FakeRemote<SavingsGoalModel>
    implements SavingsRemoteDataSource {
  @override
  Future<RemotePage<SavingsGoalModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) =>
      fetchPageOf(after, limit);

  @override
  Future<SavingsGoalModel> createSavingsGoal(SavingsGoalModel model) =>
      handle(RemoteCall.create(model.id), () => put(model.id, model));

  @override
  Future<SavingsGoalModel> updateSavingsGoal(SavingsGoalModel model) =>
      handle(RemoteCall.update(model.id), () => replace(model.id, model));
}

/// Fake server table for savings contributions. Like the real foreign
/// key, it rejects a contribution whose goal is not on the server.
class FakeSavingsContributionsRemote
    extends FakeRemote<SavingsContributionModel>
    implements SavingsContributionsRemoteDataSource {
  FakeSavingsContributionsRemote(this._goals);

  final FakeSavingsGoalsRemote _goals;

  @override
  Future<RemotePage<SavingsContributionModel>> fetchPage({
    required PullCursor? after,
    required int limit,
  }) =>
      fetchPageOf(after, limit);

  @override
  Future<SavingsContributionModel> createContribution(
    SavingsContributionModel model,
  ) =>
      handle(RemoteCall.create(model.id), () {
        if (!_goals.rows.containsKey(model.goalId)) {
          throw const ServerException(
            message: 'Foreign key violation: goal not found',
            statusCode: 400,
          );
        }
        return put(model.id, model);
      });

  @override
  Future<SavingsContributionModel> updateContribution(
    SavingsContributionModel model,
  ) =>
      handle(RemoteCall.update(model.id), () => replace(model.id, model));
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
    for (final table in <FakeRemote<Object>>[
      transactions,
      budgets,
      budgetCategories,
      profile,
      savingsGoals,
      savingsContributions,
    ]) {
      table.session = auth;
    }
  }

  final auth = FakeAuthRemote();
  final transactions = FakeTransactionsRemote();
  final budgets = FakeBudgetsRemote();
  late final budgetCategories = FakeBudgetCategoriesRemote(budgets);
  final profile = FakeProfileRemote();
  final savingsGoals = FakeSavingsGoalsRemote();
  late final savingsContributions =
      FakeSavingsContributionsRemote(savingsGoals);
}
