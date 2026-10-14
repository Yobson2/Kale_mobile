import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';

import '../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  /// A transaction as another device of the same user wrote it.
  TransactionModel serverTransaction(
    String id, {
    int amountMinor = 1000,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      TransactionModel(
        id: id,
        amountMinor: amountMinor,
        type: 'expense',
        categoryId: 'cat_food',
        date: DateTime(2026, 10, 2),
        paymentMethod: 'cash',
        createdAt: DateTime(2026, 10, 2),
        updatedAt: updatedAt ?? DateTime(2026, 10, 2),
        deletedAt: deletedAt,
      );

  /// Seeds [count] transactions on the server, ids `tx-0000`, `tx-0001`…
  /// in write order.
  void seedTransactions(int count) {
    for (var i = 0; i < count; i++) {
      final id = 'tx-${i.toString().padLeft(4, '0')}';
      harness.server.transactions.seed(id, serverTransaction(id));
    }
  }

  Future<int> localCount() async =>
      (await harness.transactions.countTransactions())
          .fold((f) => throw StateError('$f'), (n) => n);

  Iterable<RemoteCall> pageCalls(FakeRemote<Object?> table) =>
      table.calls.where((c) => c.operation == RemoteOperation.fetchPage);

  group('merging a pull', () {
    test('an unsynced local edit survives an older server version', () async {
      final created = await harness.addTransaction(amountMinor: 100);
      await harness.sync();
      harness.online = false;
      await harness.transactions.updateTransaction(
        id: created.id,
        amountMinor: 999,
        type: created.type,
        categoryId: created.categoryId,
        date: created.date,
        paymentMethod: created.paymentMethod,
      );
      harness
        ..reconnectWhileInBackground()
        ..server.transactions.seed(
              created.id,
              serverTransaction(
                created.id,
                amountMinor: 555,
                updatedAt: created.updatedAt,
              ),
            );

      expect(await harness.pull(), PullOutcome.done);

      expect((await harness.readTransaction(created.id)).amountMinor, 999);
    });

    test('a newer server version replaces a synced local row', () async {
      final created = await harness.addTransaction(amountMinor: 100);
      await harness.sync();
      harness.server.transactions.seed(
        created.id,
        serverTransaction(
          created.id,
          amountMinor: 555,
          updatedAt: created.updatedAt.add(const Duration(minutes: 5)),
        ),
      );

      await harness.pull();

      expect((await harness.readTransaction(created.id)).amountMinor, 555);
    });

    test('an older server version does not replace a synced local row',
        () async {
      final created = await harness.addTransaction(amountMinor: 100);
      await harness.sync();
      harness.server.transactions.seed(
        created.id,
        serverTransaction(
          created.id,
          amountMinor: 555,
          updatedAt: created.updatedAt.subtract(const Duration(minutes: 5)),
        ),
      );

      await harness.pull();

      expect((await harness.readTransaction(created.id)).amountMinor, 100);
    });

    test('a server tombstone removes the row locally', () async {
      final created = await harness.addTransaction();
      await harness.sync();
      final later = created.updatedAt.add(const Duration(minutes: 5));
      harness.server.transactions.seed(
        created.id,
        serverTransaction(created.id, updatedAt: later, deletedAt: later),
      );

      await harness.pull();

      expect(await harness.listTransactions(), isEmpty);
    });

    test('a local delete not yet pushed is not resurrected by a pull',
        () async {
      final created = await harness.addTransaction();
      await harness.sync();
      harness.online = false;
      await harness.transactions.deleteTransaction(created.id);
      harness.reconnectWhileInBackground();

      await harness.pull();

      expect(await harness.listTransactions(), isEmpty);
      await harness.sync();
      expect(
        harness.server.transactions.rows[created.id]!.deletedAt,
        isNotNull,
      );
    });

    test('an edit still queued is kept even though the row reads as synced',
        () async {
      // Create and edit are queued; the create's push succeeds and marks
      // the row synced, the edit's push fails. The row says "synced" but
      // its edit is still in the queue: the pull must not overwrite it.
      harness.online = false;
      final created = await harness.addTransaction(amountMinor: 100);
      await harness.transactions.updateTransaction(
        id: created.id,
        amountMinor: 777,
        type: created.type,
        categoryId: created.categoryId,
        date: created.date,
        paymentMethod: created.paymentMethod,
      );
      harness
        ..reconnectWhileInBackground()
        ..server.transactions.failCall(
              after: 1,
              failure: SimulatedFailure.server,
            );
      await harness.sync();
      expect(harness.backupStatus.pendingCount, 1);
      harness.server.transactions.seed(
        created.id,
        serverTransaction(
          created.id,
          amountMinor: 1,
          updatedAt: DateTime(2030),
        ),
      );

      await harness.pull();

      expect((await harness.readTransaction(created.id)).amountMinor, 777);
    });
  });

  group('restore', () {
    test('restores a few thousand rows in pages, with progress', () async {
      seedTransactions(2300);
      final progress = <PullStatus>[];
      final subscription = harness.puller.watchStatus().listen(progress.add);
      addTearDown(subscription.cancel);

      expect(await harness.restoreIfNeeded(), PullOutcome.done);
      await Future<void>.delayed(Duration.zero);

      expect(await localCount(), 2300);
      expect(pageCalls(harness.server.transactions), hasLength(5));
      final restoring = progress.where((s) => s.isPulling && s.isRestore);
      expect(
        restoring.map((s) => s.rowsPulled),
        containsAllInOrder([500, 1000, 1500, 2000, 2300]),
      );
      expect(progress.last.isPulling, isFalse);
    });

    test('an interrupted restore resumes from the last page it saved',
        () async {
      seedTransactions(1200);
      harness.server.transactions.failCall(
        after: 1,
        failure: SimulatedFailure.network,
      );

      expect(await harness.restoreIfNeeded(), PullOutcome.offline);
      expect(await localCount(), 500);

      harness
        ..restartApp()
        ..server.transactions.calls.clear();
      expect(await harness.restoreIfNeeded(), PullOutcome.done);

      expect(await localCount(), 1200);
      expect(
        pageCalls(harness.server.transactions).first,
        const RemoteCall.fetchPage('tx-0499'),
      );
    });

    test('does nothing on a device that already holds data', () async {
      seedTransactions(3);
      await harness.addTransaction();

      expect(await harness.restoreIfNeeded(), isNull);

      expect(pageCalls(harness.server.transactions), isEmpty);
      expect(await localCount(), 1);
    });

    test('does nothing once a restore has finished', () async {
      seedTransactions(3);
      await harness.restoreIfNeeded();
      harness.server.transactions.calls.clear();

      expect(await harness.restoreIfNeeded(), isNull);

      expect(pageCalls(harness.server.transactions), isEmpty);
    });

    test('offline, does nothing and says so', () async {
      seedTransactions(3);
      harness.online = false;

      expect(await harness.restoreIfNeeded(), PullOutcome.offline);

      expect(await localCount(), 0);
    });
  });

  test('pull-to-refresh pulls only what changed since the last pull', () async {
    seedTransactions(3);
    await harness.restoreIfNeeded();
    harness.server.transactions
      ..calls.clear()
      ..seed('tx-new', serverTransaction('tx-new'));

    await harness.pull();

    expect(
      pageCalls(harness.server.transactions),
      [const RemoteCall.fetchPage('tx-0002')],
    );
    expect(await localCount(), 4);
  });

  test('reading data never pulls', () async {
    seedTransactions(3);
    final goal = await harness.addSavingsGoal();
    await harness.addBudget();
    await harness.sync();
    final tables = <FakeRemote<Object?>>[
      harness.server.transactions,
      harness.server.budgets,
      harness.server.budgetCategories,
      harness.server.savingsGoals,
      harness.server.savingsContributions,
    ];
    for (final table in tables) {
      table.calls.clear();
    }
    harness.server.profile.calls.clear();

    await harness.listTransactions();
    await harness.transactions.watchTransactions().first;
    await harness.budgets.getBudgets();
    await harness.savings.getSavingsGoals();
    await harness.listContributions(goal.id);
    await harness.dashboardSummary(
      start: DateTime(2026, 10),
      end: DateTime(2026, 11),
    );
    await harness.settle();

    for (final table in tables) {
      expect(pageCalls(table), isEmpty);
    }
    expect(harness.server.profile.calls, isEmpty);
  });
}
