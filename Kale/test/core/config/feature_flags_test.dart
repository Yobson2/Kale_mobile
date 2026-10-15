import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/config/feature_flags.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/router/app_router.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/core/services/streak_service.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/more/presentation/pages/more_page.dart';
import 'package:kale/features/more/presentation/pages/profile_page.dart';
import 'package:kale/features/more/presentation/pages/settings_page.dart';
import 'package:kale/features/more/presentation/pages/tontine_groups_page.dart';
import 'package:kale/features/splash/presentation/providers/splash_provider.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:kale/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_notifier.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:kale/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_helpers.dart';

/// v1 shows only what works (decisions Q5, Q16, Q20; #52).
void main() {
  const user = User(id: 'u-1', email: 'ama@kale.app', name: 'Ama');
  const v1 = FeatureFlags();
  const allOn = FeatureFlags(tontineEnabled: true, gamificationEnabled: true);

  Future<List<Override>> overrides(FeatureFlags flags) async => [
        ...await createTestOverrides(),
        featureFlagsProvider.overrideWithValue(flags),
        authNotifierProvider.overrideWith(
          () => _FixedAuthNotifier(const AuthState.authenticated(user)),
        ),
      ];

  Future<void> pumpPage(
    WidgetTester tester,
    Widget page,
    FeatureFlags flags,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      createTestApp(child: page, overrides: await overrides(flags)),
    );
    await tester.pumpAndSettle();
  }

  test("v1's defaults: tontine, gamification and paid exports off; CSV on", () {
    expect(v1.tontineEnabled, isFalse);
    expect(v1.gamificationEnabled, isFalse);
    expect(v1.csvExportEnabled, isTrue);
    expect(v1.pdfStatementsEnabled, isFalse);
    expect(v1.insightsExportEnabled, isFalse);
    expect(ProviderContainer().read(featureFlagsProvider), v1);
  });

  group('tontine', () {
    testWidgets('off: the More entry says "Coming soon" and opens nothing',
        (tester) async {
      await pumpPage(tester, const MorePage(), v1);

      expect(find.text('Coming Soon'), findsOneWidget);
      await tester.tap(find.text('Tontine Groups'));
      await tester.pumpAndSettle();
      expect(find.byType(MorePage), findsOneWidget);
    });

    testWidgets('on: the entry has no "Coming soon" badge', (tester) async {
      await pumpPage(tester, const MorePage(), allOn);

      expect(find.text('Coming Soon'), findsNothing);
    });

    Future<GoRouter> pumpRouter(WidgetTester tester, FeatureFlags flags) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final container = ProviderContainer(
        overrides: [
          ...await overrides(flags),
          // The splash screen stays put, so it never navigates over [go].
          splashInitProvider
              .overrideWith((ref) => Completer<SplashResult>().future),
        ],
      );
      addTearDown(container.dispose);
      final router = container.read(appRouterProvider);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      router.go(RouteNames.tontineGroups);
      await tester.pumpAndSettle();
      return router;
    }

    testWidgets('off: the tontine page is unreachable, even by its path',
        (tester) async {
      final router = await pumpRouter(tester, v1);

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        RouteNames.more,
      );
      expect(find.byType(TontineGroupsPage), findsNothing);
    });

    testWidgets('on: the tontine page opens', (tester) async {
      final router = await pumpRouter(tester, allOn);

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        RouteNames.tontineGroups,
      );
      expect(find.byType(TontineGroupsPage), findsOneWidget);
    });
  });

  testWidgets('the More page shows no "Premium Member" label', (tester) async {
    await pumpPage(tester, const MorePage(), v1);

    expect(find.textContaining('Premium'), findsNothing);
    expect(find.text(user.email), findsOneWidget);
  });

  group('gamification', () {
    testWidgets('off: the profile shows no level or achievements',
        (tester) async {
      await pumpPage(tester, const ProfilePage(), v1);

      expect(find.text('ACHIEVEMENTS'), findsNothing);
      expect(find.text('BEGINNER'), findsNothing);
    });

    testWidgets('on: the profile shows the level and achievements',
        (tester) async {
      await pumpPage(tester, const ProfilePage(), allOn);

      expect(find.text('ACHIEVEMENTS'), findsOneWidget);
    });

    Future<ProviderContainer> createIncome(FeatureFlags flags) async {
      final container = ProviderContainer(
        overrides: [
          ...await overrides(flags),
          createTransactionUseCaseProvider.overrideWithValue(
            _CreatesTransaction(),
          ),
          transactionsStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
      );
      addTearDown(container.dispose);
      await container
          .read(transactionsNotifierProvider.notifier)
          .createTransaction(
            amountMinor: 1500,
            type: TransactionType.income,
            categoryId: 'cat_salary',
            date: DateTime(2026, 10, 15),
            paymentMethod: PaymentMethod.cash,
          );
      // The hooks run fire-and-forget after the write.
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return container;
    }

    test('off: a new transaction records no streak and unlocks nothing',
        () async {
      final storage = (await createIncome(v1)).read(localStorageProvider);

      expect(StreakService(storage).currentStreak, 0);
      expect(AchievementService(storage).unlockedCount, 0);
    });

    test('on: a new transaction records the streak and its achievement',
        () async {
      final storage = (await createIncome(allOn)).read(localStorageProvider);

      expect(StreakService(storage).currentStreak, 1);
      expect(AchievementService(storage).unlockedCount, greaterThan(0));
    });
  });

  group('CSV export', () {
    testWidgets('on by default: Settings offers it', (tester) async {
      await pumpPage(tester, const SettingsPage(), v1);

      expect(find.text('Export transactions (CSV)'), findsOneWidget);
    });

    testWidgets('off: Settings does not offer it', (tester) async {
      await pumpPage(
        tester,
        const SettingsPage(),
        const FeatureFlags(csvExportEnabled: false),
      );

      expect(find.text('Export transactions (CSV)'), findsNothing);
    });
  });
}

class _FixedAuthNotifier extends AuthNotifier {
  _FixedAuthNotifier(this._state);

  final AuthState _state;

  @override
  AuthState build() => _state;

  /// The session is already the given one.
  @override
  Future<void> restoreSession() async {}
}

class _UnusedRepository extends Mock implements TransactionsRepository {}

/// Answers every create with a saved transaction.
class _CreatesTransaction extends CreateTransactionUseCase {
  _CreatesTransaction() : super(_UnusedRepository());

  @override
  Future<Either<Failure, Transaction>> call(
    CreateTransactionParams params,
  ) async =>
      Right(
        Transaction(
          id: 'tx-1',
          amountMinor: params.amountMinor,
          type: params.type,
          categoryId: params.categoryId,
          date: params.date,
          paymentMethod: params.paymentMethod,
          createdAt: params.date,
          updatedAt: params.date,
        ),
      );
}
