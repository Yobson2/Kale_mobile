import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  test(
    'a goal and two contributions reach the server, and the goal amount is '
    'their sum, counted once',
    () async {
      final goal = await harness.addSavingsGoal(targetAmountMinor: 250000);
      final first = await harness.contribute(goal.id, amountMinor: 2500);
      final second = await harness.contribute(goal.id, amountMinor: 1500);

      await harness.sync();

      final goalCalls = harness.server.savingsGoals.calls;
      expect(
        goalCalls.where((c) => c.operation == RemoteOperation.create),
        [RemoteCall.create(goal.id)],
      );
      expect(
        goalCalls.where((c) => c.operation == RemoteOperation.update),
        everyElement(RemoteCall.update(goal.id)),
      );
      expect(
        harness.server.savingsContributions.calls,
        [RemoteCall.create(first.id), RemoteCall.create(second.id)],
      );

      final serverGoal = harness.server.savingsGoals.rows[goal.id]!;
      final serverContributions =
          harness.server.savingsContributions.rows.values;
      expect(serverGoal.currentAmountMinor, 4000);
      expect(
        serverContributions.fold<int>(0, (sum, c) => sum + c.amountMinor),
        serverGoal.currentAmountMinor,
      );
      expect(
        serverContributions.map((c) => c.goalId),
        everyElement(goal.id),
      );
      expect((await harness.readSavingsGoal(goal.id)).currentAmountMinor, 4000);
    },
  );

  test('amounts are sent as integer minor units, with no currency', () async {
    final goal = await harness.addSavingsGoal(targetAmountMinor: 5000);
    final contribution = await harness.contribute(goal.id, amountMinor: 1050);

    await harness.sync();

    final goalJson = harness.server.savingsGoals.rows[goal.id]!.toJson();
    expect(goalJson['target_amount_minor'], 5000);
    expect(goalJson['current_amount_minor'], 1050);
    expect(goalJson, isNot(contains('currency_code')));
    expect(goalJson, isNot(contains('target_amount')));
    final contributionJson =
        harness.server.savingsContributions.rows[contribution.id]!.toJson();
    expect(contributionJson['amount_minor'], 1050);
    expect(contributionJson['amount_minor'], isA<int>());
  });

  test('reaching the target completes the goal, and that change is synced',
      () async {
    final goal = await harness.addSavingsGoal(targetAmountMinor: 3000);
    await harness.sync();

    await harness.contribute(goal.id, amountMinor: 1000);
    await harness.contribute(goal.id, amountMinor: 2000);
    await harness.sync();

    expect(
      (await harness.readSavingsGoal(goal.id)).status,
      SavingsGoalStatus.completed,
    );
    final serverGoal = harness.server.savingsGoals.rows[goal.id]!;
    expect(serverGoal.status, SavingsGoalStatus.completed.name);
    expect(serverGoal.currentAmountMinor, 3000);
  });

  test('once savings are pushed, nothing is left waiting for backup', () async {
    final goal = await harness.addSavingsGoal();
    await harness.contribute(goal.id, amountMinor: 500);

    await harness.sync();

    expect(harness.backupStatus.pendingCount, 0);
    expect(harness.backupStatus.stuckCount, 0);
    expect(harness.backupStatus.lastBackupAt, isNotNull);
  });

  test('a goal and its contributions queued offline sync after a relaunch',
      () async {
    harness.online = false;
    final goal = await harness.addSavingsGoal();
    final contribution = await harness.contribute(goal.id, amountMinor: 700);

    harness
      ..restartApp()
      ..online = true;
    await harness.sync();

    expect(harness.server.savingsGoals.rows[goal.id]!.currentAmountMinor, 700);
    expect(
      harness.server.savingsContributions.calls,
      [RemoteCall.create(contribution.id)],
    );
  });

  test(
    'restoring from the server brings back goals and contributions, '
    'without doubling the saved amount',
    () async {
      final goal = await harness.addSavingsGoal(targetAmountMinor: 9000);
      await harness.contribute(goal.id, amountMinor: 1200);
      await harness.contribute(goal.id, amountMinor: 800);
      await harness.sync();
      await harness.db.clearAllData();

      expect(await harness.restoreIfNeeded(), PullOutcome.done);
      final restored = await harness.readSavingsGoal(goal.id);
      expect(restored.currentAmountMinor, 2000);
      final contributions = await harness.listContributions(goal.id);
      expect(
        contributions.map((c) => c.amountMinor).toList()..sort(),
        [800, 1200],
      );
    },
  );

  test('a refresh keeps a goal that has not been backed up yet', () async {
    final goal = await harness.addSavingsGoal(name: 'Not yet pushed');

    await harness.pull();

    expect((await harness.readSavingsGoal(goal.id)).name, 'Not yet pushed');
  });
}
