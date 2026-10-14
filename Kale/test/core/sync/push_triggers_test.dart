import 'package:flutter_test/flutter_test.dart';

import '../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() async {
    harness = SyncHarness();
    await harness.settle(); // Let the launch sync finish.
  });
  tearDown(() => harness.dispose());

  group('triggers', () {
    test('a local write is pushed once the debounce window has passed',
        () async {
      final created = await harness.addTransaction();

      await harness.elapse(const Duration(milliseconds: 1999));
      expect(harness.server.transactions.calls, isEmpty);

      await harness.elapse(const Duration(milliseconds: 1));
      expect(
        harness.server.transactions.calls,
        [RemoteCall.create(created.id)],
      );
      expect((await harness.readTransaction(created.id)).isSynced, isTrue);
    });

    test('several writes inside the debounce window go up in one run',
        () async {
      final runsBefore = harness.syncRuns;
      final first = await harness.addTransaction(description: 'first');
      await harness.elapse(const Duration(seconds: 1));
      final second = await harness.addTransaction(description: 'second');
      await harness.elapse(const Duration(seconds: 1));
      final budget = await harness.addBudget();

      await harness.elapse(const Duration(seconds: 2));

      expect(harness.syncRuns - runsBefore, 1);
      expect(harness.server.transactions.calls, [
        RemoteCall.create(first.id),
        RemoteCall.create(second.id),
      ]);
      expect(harness.server.budgets.calls, [RemoteCall.create(budget.id)]);
    });

    test('returning to the foreground pushes pending changes', () async {
      harness.online = false;
      final created = await harness.addTransaction();
      await harness.elapse(const Duration(seconds: 2)); // Offline: no push.
      expect(harness.server.transactions.calls, isEmpty);

      // Connectivity came back while the app was in the background, so no
      // connectivity change reached it.
      harness.reconnectWhileInBackground();
      await harness.resumeApp();

      expect(
        harness.server.transactions.calls,
        [RemoteCall.create(created.id)],
      );
    });

    test('connectivity coming back pushes pending changes', () async {
      harness.online = false;
      final created = await harness.addTransaction();
      await harness.elapse(const Duration(seconds: 2));
      expect(harness.server.transactions.calls, isEmpty);
      expect(harness.backupStatus.isOffline, isTrue);

      harness.online = true;
      await harness.settle();

      expect(
        harness.server.transactions.calls,
        [RemoteCall.create(created.id)],
      );
      expect(harness.backupStatus.isOffline, isFalse);
    });

    test('manual retry pushes right away', () async {
      final created = await harness.addTransaction();

      await harness.retry();

      expect(
        harness.server.transactions.calls,
        [RemoteCall.create(created.id)],
      );
    });

    test('a write made during a run is pushed by a follow-up run', () async {
      final first = await harness.addTransaction(description: 'first');
      final run = harness.sync();
      final second = await harness.addTransaction(description: 'second');
      await run;
      await harness.elapse(const Duration(seconds: 2));

      expect(
        harness.server.transactions.calls,
        containsAll([
          RemoteCall.create(first.id),
          RemoteCall.create(second.id),
        ]),
      );
      expect(harness.backupStatus.pendingCount, 0);
    });
  });

  group('failures', () {
    test('a network error keeps the entry pending without using a retry',
        () async {
      final created = await harness.addTransaction();
      // More network failures than the retry limit.
      for (var i = 0; i < 6; i++) {
        harness.server.transactions.failNextCall(SimulatedFailure.network);
      }

      await harness.elapse(const Duration(seconds: 2));
      for (var i = 0; i < 5; i++) {
        await harness.resumeApp();
      }

      expect(harness.server.transactions.calls, hasLength(6));
      expect(harness.backupStatus.stuckCount, 0);
      expect(harness.backupStatus.pendingCount, 1);

      await harness.resumeApp();
      expect((await harness.readTransaction(created.id)).isSynced, isTrue);
      expect(harness.backupStatus.pendingCount, 0);
    });

    test('a server error is retried after an exponential backoff', () async {
      final created = await harness.addTransaction();
      harness.server.transactions
        ..failNextCall(SimulatedFailure.server)
        ..failNextCall(SimulatedFailure.server);
      await harness.elapse(const Duration(seconds: 2)); // Attempt 1 fails.

      await harness.resumeApp(); // Still backing off: no attempt.
      await harness.elapse(const Duration(milliseconds: 999));
      expect(harness.server.transactions.calls, hasLength(1));

      await harness.elapse(const Duration(milliseconds: 1)); // 1s: attempt 2.
      expect(harness.server.transactions.calls, hasLength(2));

      await harness.elapse(const Duration(milliseconds: 1999));
      expect(harness.server.transactions.calls, hasLength(2));
      await harness.elapse(const Duration(milliseconds: 1)); // 2s: attempt 3.

      expect(harness.server.transactions.calls, hasLength(3));
      expect((await harness.readTransaction(created.id)).isSynced, isTrue);
    });

    test('five server failures mark the entry stuck, kept and visible',
        () async {
      final created = await harness.addTransaction();
      _failServer(harness, times: 5);

      await harness.elapse(const Duration(minutes: 5));

      expect(harness.server.transactions.calls, hasLength(5));
      expect(harness.backupStatus.stuckCount, 1);
      expect(harness.backupStatus.pendingCount, 0);
      expect((await harness.readTransaction(created.id)).isSynced, isFalse);

      // Stuck entries are not retried automatically this session.
      await harness.resumeApp();
      await harness.elapse(const Duration(minutes: 5));
      expect(harness.server.transactions.calls, hasLength(5));
      expect(harness.backupStatus.stuckCount, 1);
    });

    test('a stuck entry does not hold back the others', () async {
      final stuck = await harness.addTransaction(description: 'stuck');
      _failServer(harness, times: 5);
      await harness.elapse(const Duration(minutes: 5));

      final later = await harness.addTransaction(description: 'later');
      await harness.elapse(const Duration(seconds: 2));

      expect(
        harness.server.transactions.calls.last,
        RemoteCall.create(later.id),
      );
      expect((await harness.readTransaction(later.id)).isSynced, isTrue);
      expect((await harness.readTransaction(stuck.id)).isSynced, isFalse);
      expect(harness.backupStatus.stuckCount, 1);
    });
  });

  group('recovering stuck entries', () {
    late String stuckId;

    setUp(() async {
      stuckId = (await harness.addTransaction()).id;
      _failServer(harness, times: 5);
      await harness.elapse(const Duration(minutes: 5));
      expect(harness.backupStatus.stuckCount, 1);
    });

    test('manual retry re-attempts a stuck entry', () async {
      await harness.retry();

      expect(harness.server.transactions.calls, hasLength(6));
      expect((await harness.readTransaction(stuckId)).isSynced, isTrue);
      expect(harness.backupStatus.stuckCount, 0);
    });

    test('manual retry gives a stuck entry a fresh set of retries', () async {
      harness.server.transactions.failNextCall(SimulatedFailure.server);

      await harness.retry();

      expect(harness.backupStatus.stuckCount, 0);
      expect(harness.backupStatus.pendingCount, 1);
    });

    test('an app restart resets retry counts and re-attempts', () async {
      harness.server.transactions.failNextCall(SimulatedFailure.server);

      harness.restartApp();
      await harness.settle(); // The launch run fails once more.

      expect(harness.server.transactions.calls, hasLength(6));
      expect(harness.backupStatus.stuckCount, 0);
      expect(harness.backupStatus.pendingCount, 1);

      await harness.elapse(const Duration(seconds: 1)); // Backoff expires.
      expect((await harness.readTransaction(stuckId)).isSynced, isTrue);
    });
  });

  group('backup status', () {
    test('starts empty with no backup yet', () {
      expect(harness.backupStatus.pendingCount, 0);
      expect(harness.backupStatus.stuckCount, 0);
      expect(harness.backupStatus.isSyncing, isFalse);
      expect(harness.backupStatus.lastBackupAt, isNull);
    });

    test('counts a write as pending until it is pushed', () async {
      await harness.addTransaction();
      await harness.settle();
      expect(harness.backupStatus.pendingCount, 1);

      await harness.elapse(const Duration(seconds: 2));
      expect(harness.backupStatus.pendingCount, 0);
    });

    test(
        'records the last backup when the queue is fully pushed, '
        'and keeps it across restarts', () async {
      await harness.addTransaction();
      await harness.elapse(const Duration(seconds: 2));
      final backedUpAt = harness.clock.now();

      expect(harness.backupStatus.lastBackupAt, backedUpAt);

      harness.restartApp();
      await harness.settle();
      expect(harness.backupStatus.lastBackupAt, backedUpAt);
    });

    test('does not record a backup while something is stuck', () async {
      await harness.addTransaction();
      _failServer(harness, times: 5);
      await harness.elapse(const Duration(minutes: 5));

      expect(harness.backupStatus.lastBackupAt, isNull);
    });
  });
}

void _failServer(SyncHarness harness, {required int times}) {
  for (var i = 0; i < times; i++) {
    harness.server.transactions.failNextCall(SimulatedFailure.server);
  }
}
