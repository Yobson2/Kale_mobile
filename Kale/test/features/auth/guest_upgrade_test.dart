import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/save_data_outcome.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';

import '../../helpers/sync_harness.dart';

/// A guest (anonymous user) saves their data to a real account.
void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  User currentUser() {
    final state = harness.authState;
    if (state is! AuthAuthenticated) fail('Expected a session, got $state');
    return state.user;
  }

  /// Launches as a guest with 2 transactions, a budget with 1 allocation,
  /// and a goal with 1 contribution, all backed up: 4 entries.
  Future<User> guestWithData() async {
    await harness.auth.restoreSession();
    await harness.addTransaction(amountMinor: 100);
    await harness.addTransaction(amountMinor: 200);
    await harness.addBudget(
      categories: [
        BudgetCategoryAllocation(
          id: '',
          budgetId: '',
          categoryId: 'cat_food',
          groupName: 'Needs',
          allocatedMinor: 5000,
          spentMinor: 0,
          createdAt: DateTime(2026, 10),
        ),
      ],
    );
    final goal = await harness.addSavingsGoal();
    await harness.contribute(goal.id, amountMinor: 300);
    await harness.sync();
    final guest = currentUser();
    expect(guest.isAnonymous, isTrue);
    return guest;
  }

  Future<Map<String, int>> localCounts() async => {
        'transactions': (await harness.listTransactions()).length,
        'budgets': (await harness.budgets.getBudgets())
            .fold((f) => throw StateError('$f'), (b) => b)
            .length,
        'goals': (await harness.savings.getSavingsGoals())
            .fold((f) => throw StateError('$f'), (g) => g)
            .length,
      };

  /// Alice already has an account (email and Google) with one transaction
  /// on the server.
  String existingAlice() {
    final alice = harness.server.auth.createAccount('alice@example.com');
    harness.server.auth.identities['google:alice'] = alice;
    harness.server.transactions
      ..seed(
        'alice-tx',
        TransactionModel(
          id: 'alice-tx',
          amountMinor: 9999,
          type: 'expense',
          categoryId: 'cat_rent',
          date: DateTime(2026, 10, 3),
          paymentMethod: 'cash',
          createdAt: DateTime(2026, 10, 3),
          updatedAt: DateTime(2026, 10, 3),
        ),
      )
      ..owners['alice-tx'] = alice;
    return alice;
  }

  group('linking keeps the same user and every local entry', () {
    for (final provider in SocialProvider.values) {
      test('with ${provider.name}', () async {
        final guest = await guestWithData();
        final before = await localCounts();

        final outcome = await harness.auth.linkSocialAccount(provider);

        expect(outcome, isA<SaveDataDone>());
        final user = currentUser();
        expect(user.id, guest.id);
        expect(user.isAnonymous, isFalse);
        expect(await localCounts(), before);
        expect(harness.backupStatus.pendingCount, 0);
      });
    }

    test('with an email and its code', () async {
      final guest = await guestWithData();
      final before = await localCounts();

      final sent = await harness.auth.startEmailLink('me@example.com');
      expect(sent, isA<SaveDataCodeSent>());
      expect(harness.server.auth.codesSentTo, ['me@example.com']);
      final outcome = await harness.auth.confirmEmailLink(
        email: 'me@example.com',
        code: FakeAuthRemote.validCode,
        password: 'secret-123',
      );

      expect(outcome, isA<SaveDataDone>());
      expect(currentUser().id, guest.id);
      expect(currentUser().isAnonymous, isFalse);
      expect(await localCounts(), before);
    });

    test('a wrong code fails and changes nothing', () async {
      await guestWithData();
      await harness.auth.startEmailLink('me@example.com');

      final outcome = await harness.auth.confirmEmailLink(
        email: 'me@example.com',
        code: '000000',
        password: 'secret-123',
      );

      expect(outcome, isA<SaveDataFailed>());
      expect(currentUser().isAnonymous, isTrue);
    });
  });

  group('an identity that belongs to another account', () {
    test('offers the choice with the number of entries involved', () async {
      await guestWithData();
      existingAlice();
      harness.server.auth.nextSocialIdentity = 'alice';

      final outcome =
          await harness.auth.linkSocialAccount(SocialProvider.google);

      expect(outcome, isA<SaveDataIdentityInUse>());
      // 2 transactions + 1 budget + 1 goal.
      expect((outcome as SaveDataIdentityInUse).entryCount, 4);
      expect(currentUser().isAnonymous, isTrue);
    });

    test('an email in use is reported the same way, and no code is sent',
        () async {
      await guestWithData();
      existingAlice();

      final outcome = await harness.auth.startEmailLink('alice@example.com');

      expect(outcome, isA<SaveDataIdentityInUse>());
      expect(
        (outcome as SaveDataIdentityInUse).credential,
        isA<EmailCodeCredential>(),
      );
      expect(harness.server.auth.codesSentTo, isEmpty);
    });

    test(
      '"Add my entries" pushes every entry to that account once, and brings '
      'its own data in',
      () async {
        final guest = await guestWithData();
        final alice = existingAlice();
        harness.server.auth.nextSocialIdentity = 'alice';
        final inUse = await harness.auth.linkSocialAccount(
          SocialProvider.google,
        ) as SaveDataIdentityInUse;
        final guestRowsOnServer = {
          for (final table in <FakeRemote<Object?>>[
            harness.server.transactions,
            harness.server.budgets,
            harness.server.budgetCategories,
            harness.server.savingsGoals,
            harness.server.savingsContributions,
          ])
            table: table.owners.values.where((o) => o == guest.id).length,
        };
        for (final table in guestRowsOnServer.keys) {
          table
            ..calls.clear()
            ..callers.clear();
        }

        final outcome = await harness.auth.switchToExistingAccount(
          inUse.credential,
          keepGuestData: true,
        );

        expect(outcome, isA<SaveDataDone>());
        expect(currentUser().id, alice);
        // Every guest entry was created once more, under Alice.
        guestRowsOnServer.forEach((table, guestRows) {
          final creates = table.calls
              .where((c) => c.operation == RemoteOperation.create)
              .toList();
          expect(creates, hasLength(guestRows), reason: '$table');
          expect(creates.map((c) => c.entityId).toSet(), hasLength(guestRows));
          expect(
            table.callers,
            everyElement(alice),
            reason: '$table pushed under Alice',
          );
        });
        // On the device: the guest's entries and Alice's, no duplicate.
        expect(await localCounts(), {
          'transactions': 3,
          'budgets': 1,
          'goals': 1,
        });
        expect(
          (await harness.listTransactions()).map((t) => t.amountMinor).toSet(),
          {100, 200, 9999},
        );
        // Children follow their parent's new id.
        final budget = (await harness.budgets.getBudgets())
            .fold((f) => throw StateError('$f'), (b) => b)
            .single;
        expect(budget.categories.single.allocatedMinor, 5000);
        final goal = (await harness.savings.getSavingsGoals())
            .fold((f) => throw StateError('$f'), (g) => g)
            .single;
        expect(
          (await harness.listContributions(goal.id)).single.amountMinor,
          300,
        );
        expect(harness.backupStatus.pendingCount, 0);
        expect(harness.backupStatus.stuckCount, 0);
        // The guest's own server rows are left alone.
        expect(
          harness.server.transactions.owners.values.where((o) => o == guest.id),
          hasLength(2),
        );
      },
    );

    test('"Discard them" wipes local data and restores that account', () async {
      await guestWithData();
      final alice = existingAlice();
      final inUse = await harness.auth.startEmailLink('alice@example.com')
          as SaveDataIdentityInUse;
      await harness.auth.sendSignInCode('alice@example.com');

      final outcome = await harness.auth.switchToExistingAccount(
        inUse.credential,
        keepGuestData: false,
        code: FakeAuthRemote.validCode,
      );

      expect(outcome, isA<SaveDataDone>());
      expect(currentUser().id, alice);
      expect(
        (await harness.listTransactions()).map((t) => t.id),
        ['alice-tx'],
      );
      expect(
        await localCounts(),
        {'transactions': 1, 'budgets': 0, 'goals': 0},
      );
      expect(
        harness.server.transactions.calls
            .where((c) => c.operation == RemoteOperation.create),
        hasLength(2),
        reason: "only the guest's own creates, from before the switch",
      );
    });

    test('a failed sign-in leaves the guest and their data untouched',
        () async {
      final guest = await guestWithData();
      existingAlice();
      final inUse = await harness.auth.startEmailLink('alice@example.com')
          as SaveDataIdentityInUse;
      final before = await localCounts();

      final outcome = await harness.auth.switchToExistingAccount(
        inUse.credential,
        keepGuestData: true,
        code: '000000',
      );

      expect(outcome, isA<SaveDataFailed>());
      expect(currentUser(), guest);
      expect(harness.server.auth.currentUserId, guest.id);
      expect(await localCounts(), before);
    });

    test('cancelling the choice leaves the guest session and data untouched',
        () async {
      final guest = await guestWithData();
      existingAlice();
      harness.server.auth.nextSocialIdentity = 'alice';
      final before = await localCounts();

      await harness.auth.linkSocialAccount(SocialProvider.google);
      // The user closes the choice: nothing else is called.

      expect(currentUser(), guest);
      expect(harness.server.auth.currentUserId, guest.id);
      expect(await localCounts(), before);
      expect(harness.backupStatus.pendingCount, 0);
    });
  });
}
