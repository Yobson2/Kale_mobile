import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/app_database.dart' show AppDatabase;
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/sync/sync_config.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/profile/domain/repositories/profile_repository.dart';
import 'package:kale/features/profile/domain/usecases/change_base_currency_usecase.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
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
/// operations: the repositories, [sync], [online] and [restartApp].
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

  final FakeNetworkInfo _network = FakeNetworkInfo();
  late ProviderContainer _container;

  /// Whether the device has connectivity. Setting it emits a
  /// connectivity change, like the OS would.
  bool get online => _network.online;
  set online(bool value) => _network.online = value;

  /// The transactions repository, as the feature's use cases get it.
  TransactionsRepository get transactions =>
      _container.read(transactionsRepositoryProvider);

  /// The budgets repository, as the feature's use cases get it.
  BudgetsRepository get budgets => _container.read(budgetsRepositoryProvider);

  /// The profile repository (base currency), as the use cases get it.
  ProfileRepository get profile => _container.read(profileRepositoryProvider);

  /// The base-currency change rules, as the settings and onboarding
  /// screens run them.
  ChangeBaseCurrencyUseCase get changeBaseCurrency =>
      _container.read(changeBaseCurrencyUseCaseProvider);

  /// The app's sync engine.
  SyncEngine get engine => _container.read(syncEngineProvider);

  /// Runs one sync cycle and waits for it to finish.
  Future<void> sync() => engine.processQueue();

  /// Simulates killing and relaunching the app: every provider (engine,
  /// repositories, handlers) is rebuilt; the database, server and network
  /// state survive. Nothing is read until the test asks for it.
  void restartApp() {
    _container.dispose();
    _container = _newContainer();
  }

  /// Releases the container and closes the database.
  Future<void> dispose() async {
    _container.dispose();
    await _network.close();
    await db.close();
  }

  ProviderContainer _newContainer() => ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          networkInfoProvider.overrideWithValue(_network),
          syncConfigProvider.overrideWithValue(
            const SyncConfig(initialBackoffMs: 0),
          ),
          transactionsRemoteDataSourceProvider
              .overrideWithValue(server.transactions),
          budgetsRemoteDataSourceProvider.overrideWithValue(server.budgets),
          profileRemoteDataSourceProvider.overrideWithValue(server.profile),
        ],
      );
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

  @override
  Future<bool> get isConnected async => _online;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _changes.stream;

  Future<void> close() => _changes.close();
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
