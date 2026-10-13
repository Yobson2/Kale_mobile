import 'package:flutter_test/flutter_test.dart';

import '../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  test(
    'changes queued in an earlier session sync before any feature is opened',
    () async {
      harness.online = false;
      final transaction = await harness.addTransaction();
      final budget = await harness.addBudget();

      // Relaunch: only the engine is created, no feature repository is read.
      harness
        ..restartApp()
        ..online = true;
      await harness.sync();

      expect(
        harness.server.transactions.calls,
        [RemoteCall.create(transaction.id)],
      );
      expect(harness.server.budgets.calls, [RemoteCall.create(budget.id)]);
    },
  );
}
