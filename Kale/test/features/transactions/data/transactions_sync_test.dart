import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() async {
    harness = SyncHarness();
    await harness.settle(); // Let the launch sync finish.
  });
  tearDown(() => harness.dispose());

  test('a created transaction is pushed once and marked synced', () async {
    final created = await harness.addTransaction(amount: 2500);

    await harness.sync();

    expect(harness.server.transactions.calls, [RemoteCall.create(created.id)]);
    expect((await harness.readTransaction(created.id)).isSynced, isTrue);
  });

  test('sync() waits for a push that reconnecting already started', () async {
    final created = await harness.addTransaction();

    harness
      ..engine // The app is running and listening for connectivity.
      ..online = true;
    await Future<void>.delayed(Duration.zero); // Reconnect push starts.
    await harness.sync();

    expect(harness.server.transactions.calls, [RemoteCall.create(created.id)]);
    expect((await harness.readTransaction(created.id)).isSynced, isTrue);
  });

  for (final failure in SimulatedFailure.values) {
    test(
        'a ${failure.name} error fails only that push; it is retried '
        '${failure == SimulatedFailure.network ? 'by the next sync' : 'after its backoff'}',
        () async {
      final first = await harness.addTransaction(description: 'first');
      final second = await harness.addTransaction(description: 'second');
      harness.server.transactions.failNextCall(failure);

      await harness.sync();

      expect(harness.server.transactions.calls, [
        RemoteCall.create(first.id),
        RemoteCall.create(second.id),
      ]);
      expect((await harness.readTransaction(first.id)).isSynced, isFalse);
      expect((await harness.readTransaction(second.id)).isSynced, isTrue);

      switch (failure) {
        case SimulatedFailure.network:
          await harness.sync();
        case SimulatedFailure.server:
          await harness.elapse(const Duration(seconds: 1));
      }

      expect(
        harness.server.transactions.calls.last,
        RemoteCall.create(first.id),
      );
      expect((await harness.readTransaction(first.id)).isSynced, isTrue);
      expect(harness.server.transactions.rows.keys, {first.id, second.id});
    });
  }
}
