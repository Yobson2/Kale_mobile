import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

import '../../helpers/sync_harness.dart';

/// Someone trying the app is an anonymous user: authenticated, with a real
/// user id, so their data syncs exactly like a permanent user's.
void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  Future<User> launchApp() async {
    await harness.auth.restoreSession();
    final state = harness.authState;
    if (state is! AuthAuthenticated) {
      fail('Expected an authenticated session, got $state');
    }
    return state.user;
  }

  test("an anonymous user's transaction syncs to the server", () async {
    final user = await launchApp();
    expect(user.isAnonymous, isTrue);

    final created = await harness.addTransaction(amountMinor: 1500);
    await harness.sync();

    expect(harness.server.transactions.calls, [RemoteCall.create(created.id)]);
    expect(harness.server.transactions.callers, [user.id]);
    expect((await harness.readTransaction(created.id)).isSynced, isTrue);
  });

  test('after a restart, the same anonymous user keeps syncing', () async {
    final first = await launchApp();
    harness.restartApp();

    final second = await launchApp();
    final created = await harness.addTransaction();
    await harness.sync();

    expect(second, first);
    expect(harness.server.auth.anonymousSignIns, 1);
    expect(harness.server.transactions.callers, [first.id]);
    expect(harness.server.transactions.rows.keys, [created.id]);
  });
}
