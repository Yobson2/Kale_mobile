import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/logout_outcome.dart';

import '../../helpers/sync_harness.dart';

/// Logging out never loses data silently: it backs up first, refuses
/// while changes are still only on the phone, and once the user goes
/// ahead it leaves nothing of theirs behind.
void main() {
  late SyncHarness harness;

  setUp(() async {
    harness = SyncHarness();
    await harness.settle(); // Let the launch sync finish.
  });
  tearDown(() => harness.dispose());

  Future<void> signIn(String email) async {
    await harness.auth.login(email: email, password: 'secret');
    await harness.settle();
    expect(harness.authState, isA<AuthAuthenticated>());
  }

  group('online with pending changes', () {
    test('logout backs them up, then logs out without asking', () async {
      await signIn('ama@kale.app');
      final first = await harness.addTransaction(description: 'first');
      final second = await harness.addTransaction(description: 'second');

      final outcome = await harness.auth.logout();

      expect(outcome, const LogoutOutcome.loggedOut());
      expect(
        harness.server.transactions.rows.keys,
        containsAll([first.id, second.id]),
      );
      expect(harness.authState, isA<AuthUnauthenticated>());
    });
  });

  group('changes that cannot be backed up', () {
    test('offline: logout is blocked with the number of changes', () async {
      await signIn('ama@kale.app');
      harness.online = false;
      await harness.addTransaction();
      await harness.addBudget();

      final outcome = await harness.auth.logout();

      expect(outcome, const LogoutOutcome.blocked(unsavedChanges: 2));
      expect(harness.authState, isA<AuthAuthenticated>());
      expect(harness.server.auth.logouts, 0);
    });

    test('server refusing a change: logout is blocked with its count',
        () async {
      await signIn('ama@kale.app');
      harness.server.transactions.failNextCall(SimulatedFailure.server);
      final refused = await harness.addTransaction(description: 'refused');

      final outcome = await harness.auth.logout();

      expect(outcome, const LogoutOutcome.blocked(unsavedChanges: 1));
      expect(
        harness.server.transactions.rows.keys,
        isNot(contains(refused.id)),
      );
    });

    test('stuck changes block logout too', () async {
      await signIn('ama@kale.app');
      final created = await harness.addTransaction();
      for (var i = 0; i < 5; i++) {
        harness.server.transactions.failNextCall(SimulatedFailure.server);
      }
      await harness.elapse(const Duration(minutes: 30));
      expect(harness.backupStatus.stuckCount, 1);
      // The server still refuses on the backup attempt at logout.
      harness.server.transactions.failNextCall(SimulatedFailure.server);

      final outcome = await harness.auth.logout();

      expect(outcome, const LogoutOutcome.blocked(unsavedChanges: 1));
      expect(
        (await harness.listTransactions()).map((t) => t.id),
        [created.id],
      );
    });

    test('cancelling the confirmation keeps everything as it was', () async {
      await signIn('ama@kale.app');
      harness.online = false;
      final created = await harness.addTransaction();

      await harness.auth.logout(); // Blocked; the user cancels.

      expect(harness.authState, isA<AuthAuthenticated>());
      expect(
        (await harness.listTransactions()).map((t) => t.id),
        [created.id],
      );
      expect(harness.backupStatus.pendingCount, 1);

      // Still queued: it goes up once the phone is back online.
      harness.online = true;
      await harness.settle();
      expect(harness.server.transactions.rows.keys, [created.id]);
    });

    test('confirming wipes local data and the queue', () async {
      await signIn('ama@kale.app');
      harness.online = false;
      await harness.addTransaction();
      await harness.addBudget();

      await harness.auth.logout(); // Blocked; the user confirms.
      await harness.auth.discardChangesAndLogout();
      await harness.settle();

      expect(harness.authState, isA<AuthUnauthenticated>());
      expect(await harness.listTransactions(), isEmpty);
      expect(harness.backupStatus.pendingCount, 0);
      expect(harness.backupStatus.stuckCount, 0);

      // Nothing of the old queue reaches the server later.
      harness.online = true;
      await harness.elapse(const Duration(hours: 1));
      expect(harness.server.transactions.rows, isEmpty);
      expect(harness.server.budgets.rows, isEmpty);
    });
  });

  group('after logout', () {
    test("the next user sees none of the previous user's data", () async {
      await signIn('ama@kale.app');
      await harness.addTransaction(amountMinor: 5000);
      await harness.addBudget();
      await harness.sync();
      expect(harness.backupStatus.lastBackupAt, isNotNull);

      expect(await harness.auth.logout(), const LogoutOutcome.loggedOut());
      await signIn('kofi@kale.app');

      expect(await harness.listTransactions(), isEmpty);
      final summary = await harness.dashboardSummary(
        start: DateTime(2026, 10),
        end: DateTime(2026, 10, 31),
      );
      expect(summary.totalExpenses.minorUnits, 0);
      expect(summary.recentTransactions, isEmpty);
      expect(harness.backupStatus.pendingCount, 0);
      expect(harness.backupStatus.stuckCount, 0);
      expect(harness.backupStatus.lastBackupAt, isNull);
    });

    test('the wipe also survives an app restart', () async {
      await signIn('ama@kale.app');
      harness.online = false;
      await harness.addTransaction();
      await harness.auth.logout();
      await harness.auth.discardChangesAndLogout();

      harness.restartApp();
      await harness.settle();

      expect(await harness.listTransactions(), isEmpty);
      expect(harness.backupStatus.pendingCount, 0);
    });
  });
}
