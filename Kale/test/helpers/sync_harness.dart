import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/app_database.dart' show AppDatabase;
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/last_backup_store.dart';
import 'package:kale/core/sync/sync_clock.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kale/features/auth/data/models/tokens_model.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_providers.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/profile/domain/repositories/profile_repository.dart';
import 'package:kale/features/profile/domain/usecases/change_base_currency_usecase.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';

import 'fake_remote.dart';

export 'fake_remote.dart';

/// The primary data-layer test seam.
///
/// Wires the real provider graph (repositories, local datasources, DAOs,
/// sync handlers, [SyncEngine]) against an in-memory Drift database, with
/// a [FakeServer] in place of Supabase. Tests drive it only through public
/// operations: the repositories, [sync], [online], [restartApp],
/// [resumeApp], [retry] and [elapse].
///
/// Time is fake: debounce and backoff timers fire only when the test
/// calls [elapse]. Like the app, the harness starts the engine at launch
/// (and after [restartApp]), which runs a first sync; call [settle] when a
/// test needs that run out of the way.
///
/// ```dart
/// late SyncHarness harness;
/// setUp(() => harness = SyncHarness());
/// tearDown(() => harness.dispose());
///
/// test('...', () async {
///   await harness.transactions.createTransaction(...);
///   await harness.sync();
///   expect(harness.server.transactions.calls, [RemoteCall.create(id)]);
/// });
/// ```
class SyncHarness {
  /// Creates a fresh app: empty database, empty server, online.
  SyncHarness() : db = AppDatabase(NativeDatabase.memory()) {
    // Restarting the app opens a second container on the same database.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    _container = _newContainer();
  }

  /// The device database. Prefer asserting through repositories.
  final AppDatabase db;

  /// The fake backend. Inspect `calls`, seed `rows`, or `failNextCall`.
  final FakeServer server = FakeServer();

  /// The fake time source, shared by every app session.
  final FakeSyncClock clock = FakeSyncClock();

  final FakeNetworkInfo _network = FakeNetworkInfo();

  /// The device's cached session; survives [restartApp] like
  /// SharedPreferences and the keychain do.
  final InMemoryAuthLocalDataSource _authStorage =
      InMemoryAuthLocalDataSource();
  final InMemoryLastBackupStore _lastBackupStore = InMemoryLastBackupStore();
  late ProviderContainer _container;
  StreamSubscription<BackupStatus>? _statusSubscription;
  int _syncRuns = 0;

  /// Whether the device has connectivity. Setting it emits a
  /// connectivity change, like the OS would.
  bool get online => _network.online;
  set online(bool value) => _network.online = value;

  /// Restores connectivity without a connectivity change reaching the
  /// app, as when the network returns while the app is in the background.
  void reconnectWhileInBackground() => _network.setOnlineSilently();

  /// The transactions repository, as the feature's use cases get it.
  TransactionsRepository get transactions =>
      _container.read(transactionsRepositoryProvider);

  /// The budgets repository, as the feature's use cases get it.
  BudgetsRepository get budgets => _container.read(budgetsRepositoryProvider);

  /// The savings repository (goals and contributions), as the feature's
  /// use cases get it.
  SavingsRepository get savings => _container.read(savingsRepositoryProvider);

  /// The profile repository (base currency), as the use cases get it.
  ProfileRepository get profile => _container.read(profileRepositoryProvider);

  /// The base-currency change rules, as the settings and onboarding
  /// screens run them.
  ChangeBaseCurrencyUseCase get changeBaseCurrency =>
      _container.read(changeBaseCurrencyUseCaseProvider);

  /// The auth notifier, as the app's pages get it.
  AuthNotifier get auth => _container.read(authNotifierProvider.notifier);

  /// The current auth state.
  AuthState get authState => _container.read(authNotifierProvider);

  /// The app's sync engine.
  SyncEngine get engine => _container.read(syncEngineProvider);

  /// Runs one sync cycle and waits for it to finish.
  Future<void> sync() => engine.processQueue();

  /// The engine's current backup status.
  BackupStatus get backupStatus => engine.currentBackupStatus;

  /// How many sync runs have pushed something since the harness was
  /// created, across restarts.
  int get syncRuns => _syncRuns;

  /// Simulates the app returning to the foreground, and waits for the
  /// push it triggers.
  Future<void> resumeApp() async {
    engine.onAppResumed();
    await settle();
  }

  /// Simulates the user tapping "Retry", and waits for the push.
  Future<void> retry() => engine.retry();

  /// Moves fake time forward by [duration], firing due debounce and
  /// backoff timers in order, and waits for the pushes they start.
  Future<void> elapse(Duration duration) async {
    final end = clock.now().add(duration);
    await settle();
    while (clock.fireNextTimerDueBy(end)) {
      await settle();
    }
    clock.moveTo(end);
  }

  /// Lets pending database notifications arrive and waits for any sync
  /// run they started.
  Future<void> settle() async {
    for (var i = 0; i < 3; i++) {
      await Future<void>.delayed(Duration.zero);
      await engine.idle;
    }
  }

  /// Simulates killing and relaunching the app: every provider (engine,
  /// repositories, handlers) is rebuilt and pending timers are dropped;
  /// the database, server, network state and persisted preferences
  /// survive. The new engine starts right away, as the app's root widget
  /// starts it on launch.
  void restartApp() {
    _disposeContainer();
    _container = _newContainer();
  }

  /// Releases the container and closes the database.
  Future<void> dispose() async {
    await engine.idle;
    _disposeContainer();
    await _network.close();
    await db.close();
  }

  void _disposeContainer() {
    unawaited(_statusSubscription?.cancel());
    clock.cancelAll();
    _container.dispose();
  }

  ProviderContainer _newContainer() {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        networkInfoProvider.overrideWithValue(_network),
        syncClockProvider.overrideWithValue(clock),
        lastBackupStoreProvider.overrideWithValue(_lastBackupStore),
        transactionsRemoteDataSourceProvider
            .overrideWithValue(server.transactions),
        budgetsRemoteDataSourceProvider.overrideWithValue(server.budgets),
        profileRemoteDataSourceProvider.overrideWithValue(server.profile),
        savingsRemoteDataSourceProvider.overrideWithValue(server.savingsGoals),
        savingsContributionsRemoteDataSourceProvider
            .overrideWithValue(server.savingsContributions),
        authRemoteDataSourceProvider.overrideWithValue(server.auth),
        authLocalDataSourceProvider.overrideWithValue(_authStorage),
      ],
    );
    var wasSyncing = false;
    _statusSubscription =
        container.read(syncEngineProvider).watchBackupStatus().listen((status) {
      if (status.isSyncing && !wasSyncing) _syncRuns++;
      wasSyncing = status.isSyncing;
    });
    return container;
  }
}

/// Device-side session cache kept in memory.
class InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  UserModel? _user;
  TokensModel? _tokens;

  @override
  Future<void> cacheUser(UserModel user) async => _user = user;

  @override
  Future<UserModel> getCachedUser() async =>
      _user ?? (throw const CacheException(message: 'No cached user found'));

  @override
  Future<void> cacheTokens(TokensModel tokens) async => _tokens = tokens;

  @override
  Future<bool> hasToken() async => _tokens != null;

  @override
  Future<void> clearAll() async {
    _user = null;
    _tokens = null;
  }
}

/// A [NetworkInfo] whose connectivity the test controls.
class FakeNetworkInfo implements NetworkInfo {
  final _changes = StreamController<List<ConnectivityResult>>.broadcast();
  bool _online = true;

  bool get online => _online;
  set online(bool value) {
    _online = value;
    _changes.add([
      if (value) ConnectivityResult.wifi else ConnectivityResult.none,
    ]);
  }

  /// Goes online without emitting a connectivity change.
  void setOnlineSilently() => _online = true;

  @override
  Future<bool> get isConnected async => _online;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _changes.stream;

  Future<void> close() => _changes.close();
}

/// A [SyncClock] whose time moves only when the test says so.
class FakeSyncClock extends SyncClock {
  DateTime _now = DateTime(2026, 10, 13, 9);
  final List<_FakeTimer> _timers = [];

  @override
  DateTime now() => _now;

  @override
  Timer timer(Duration duration, void Function() callback) {
    final timer = _FakeTimer(_now.add(duration), callback, _timers.remove);
    _timers.add(timer);
    return timer;
  }

  /// Fires the earliest timer due at or before [end], moving time to its
  /// due time. Returns false when no timer is due.
  bool fireNextTimerDueBy(DateTime end) {
    final due = _timers.where((t) => !t.dueAt.isAfter(end)).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    if (due.isEmpty) return false;
    final next = due.first;
    _timers.remove(next);
    if (next.dueAt.isAfter(_now)) _now = next.dueAt;
    next.fire();
    return true;
  }

  /// Moves time forward to [time] without firing anything.
  void moveTo(DateTime time) {
    if (time.isAfter(_now)) _now = time;
  }

  /// Drops every scheduled timer (the app was killed).
  void cancelAll() {
    for (final timer in List.of(_timers)) {
      timer.cancel();
    }
  }
}

class _FakeTimer implements Timer {
  _FakeTimer(this.dueAt, this._callback, this._onCancel);

  final DateTime dueAt;
  final void Function() _callback;
  final bool Function(_FakeTimer) _onCancel;
  bool _active = true;

  void fire() {
    _active = false;
    _callback();
  }

  @override
  void cancel() {
    _active = false;
    _onCancel(this);
  }

  @override
  bool get isActive => _active;

  @override
  int get tick => 0;
}

/// Shorthands for creating data through the repositories with sensible
/// defaults, so tests only spell out the fields they care about.
extension SyncHarnessFixtures on SyncHarness {
  /// Creates a transaction through [SyncHarness.transactions].
  Future<Transaction> addTransaction({
    int amountMinor = 1000,
    TransactionType type = TransactionType.expense,
    String categoryId = 'cat_food',
    DateTime? date,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    String? description,
  }) async {
    final result = await transactions.createTransaction(
      amountMinor: amountMinor,
      type: type,
      categoryId: categoryId,
      date: date ?? DateTime(2026, 10),
      paymentMethod: paymentMethod,
      description: description,
    );
    return result.fold((f) => throw StateError('$f'), (t) => t);
  }

  /// Creates a monthly budget with no category allocations through
  /// [SyncHarness.budgets].
  Future<Budget> addBudget({String name = 'October'}) async {
    final result = await budgets.createBudget(
      name: name,
      strategy: BudgetStrategy.custom,
      period: BudgetPeriod.monthly,
      startDate: DateTime(2026, 10),
      endDate: DateTime(2026, 10, 31),
      categories: const [],
    );
    return result.fold((f) => throw StateError('$f'), (b) => b);
  }

  /// Creates a savings goal through [SyncHarness.savings].
  Future<SavingsGoal> addSavingsGoal({
    String name = 'Emergency fund',
    int targetAmountMinor = 100000,
  }) async {
    final result = await savings.createSavingsGoal(
      name: name,
      targetAmountMinor: targetAmountMinor,
    );
    return result.fold((f) => throw StateError('$f'), (g) => g);
  }

  /// Adds a manual contribution to a goal through [SyncHarness.savings].
  Future<SavingsContribution> contribute(
    String goalId, {
    required int amountMinor,
  }) async {
    final result = await savings.contributeToGoal(
      goalId: goalId,
      amountMinor: amountMinor,
      source: ContributionSource.manual,
    );
    return result.fold((f) => throw StateError('$f'), (c) => c);
  }

  /// Reads one savings goal back through the repository.
  Future<SavingsGoal> readSavingsGoal(String id) async {
    final result = await savings.getSavingsGoalById(id);
    return result.fold((f) => throw StateError('$f'), (g) => g);
  }

  /// Lists a goal's contributions through the repository.
  Future<List<SavingsContribution>> listContributions(String goalId) async {
    final result = await savings.getContributions(goalId);
    return result.fold((f) => throw StateError('$f'), (c) => c);
  }

  /// Chooses the base currency the way onboarding does (no relabel
  /// confirmation), and fails the test if the rules refuse it.
  Future<void> chooseBaseCurrency(Currency currency) async {
    final result = await changeBaseCurrency(
      ChangeBaseCurrencyParams(currency: currency),
    );
    final change = result.fold((f) => throw StateError('$f'), (c) => c);
    if (change != BaseCurrencyChange.changed) throw StateError('$change');
  }

  /// The stored base currency, or null if none was chosen.
  Future<Currency?> readBaseCurrency() async {
    final result = await profile.getBaseCurrency();
    return result.fold((f) => throw StateError('$f'), (c) => c);
  }

  /// Lists every transaction through the repository.
  Future<List<Transaction>> listTransactions() async {
    final result = await transactions.getTransactions();
    return result.fold((f) => throw StateError('$f'), (t) => t);
  }

  /// The dashboard summary for [start]..[end], in the stored base currency
  /// (or the default one), as the dashboard screen computes it.
  Future<DashboardSummary> dashboardSummary({
    required DateTime start,
    required DateTime end,
  }) async {
    final result =
        await _container.read(dashboardRepositoryProvider).getDashboardSummary(
              startDate: start,
              endDate: end,
              currency: await readBaseCurrency() ?? defaultBaseCurrency,
            );
    return result.fold((f) => throw StateError('$f'), (s) => s);
  }

  /// Reads one transaction back through the repository.
  Future<Transaction> readTransaction(String id) async {
    final result = await transactions.getTransactionById(id);
    return result.fold((f) => throw StateError('$f'), (t) => t);
  }
}
