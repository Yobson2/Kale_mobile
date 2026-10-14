import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/logout_outcome.dart';
import 'package:kale/features/more/presentation/pages/more_page.dart';
import 'package:kale/features/more/presentation/pages/profile_page.dart';

import '../../../../helpers/test_helpers.dart';

/// Anonymous users can never sign back in once logged out, so they are
/// offered account creation where permanent users see "Log out".
void main() {
  const anonymous = User(id: 'anon-1', email: '', name: '', isAnonymous: true);
  const permanent = User(id: 'u-1', email: 'a@b.co', name: 'Ama');

  const logout = 'Logout';
  const createAccount = 'Create an account to save your data';

  final pages = <String, Widget>{
    'MorePage': const MorePage(),
    'ProfilePage': const ProfilePage(),
  };

  Future<void> pumpPage(WidgetTester tester, Widget page, User user) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final overrides = await createTestOverrides();
    await tester.pumpWidget(
      createTestApp(
        child: page,
        overrides: [
          ...overrides,
          authNotifierProvider.overrideWith(
            () => _FixedAuthNotifier(AuthState.authenticated(user)),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final MapEntry(key: name, value: page) in pages.entries) {
    group(name, () {
      testWidgets('an anonymous user is offered account creation, not logout',
          (tester) async {
        await pumpPage(tester, page, anonymous);

        expect(find.text(createAccount), findsOneWidget);
        expect(find.text(logout), findsNothing);
      });

      testWidgets('a permanent user is offered logout', (tester) async {
        await pumpPage(tester, page, permanent);

        expect(find.text(logout), findsOneWidget);
        expect(find.text(createAccount), findsNothing);
      });
    });
  }

  group('logout with changes not backed up', () {
    Future<_BlockedLogoutNotifier> tapLogout(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final notifier = _BlockedLogoutNotifier(2);
      final overrides = await createTestOverrides();
      await tester.pumpWidget(
        createTestApp(
          child: const ProfilePage(),
          overrides: [
            ...overrides,
            authNotifierProvider.overrideWith(() => notifier),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(logout));
      await tester.pumpAndSettle();
      return notifier;
    }

    const warning = "2 changes aren't backed up yet. If you log out now, "
        'they will be lost for good.';

    testWidgets('warns how many changes would be lost', (tester) async {
      await tapLogout(tester);

      expect(find.text(warning), findsOneWidget);
    });

    testWidgets('cancelling keeps the user logged in', (tester) async {
      final notifier = await tapLogout(tester);

      await tester.tap(find.text('Stay logged in'));
      await tester.pumpAndSettle();

      expect(find.text(warning), findsNothing);
      expect(notifier.discarded, isFalse);
    });

    testWidgets('confirming logs out and discards them', (tester) async {
      final notifier = await tapLogout(tester);

      await tester.tap(find.text('Log out anyway'));
      await tester.pumpAndSettle();

      expect(notifier.discarded, isTrue);
    });
  });
}

class _FixedAuthNotifier extends AuthNotifier {
  _FixedAuthNotifier(this._state);

  final AuthState _state;

  @override
  AuthState build() => _state;
}

/// A permanent user whose logout is blocked by [unsaved] changes.
class _BlockedLogoutNotifier extends AuthNotifier {
  _BlockedLogoutNotifier(this.unsaved);

  final int unsaved;
  bool discarded = false;

  @override
  AuthState build() => const AuthState.authenticated(
        User(id: 'u-1', email: 'a@b.co', name: 'Ama'),
      );

  @override
  Future<LogoutOutcome> logout() async =>
      LogoutOutcome.blocked(unsavedChanges: unsaved);

  @override
  Future<void> discardChangesAndLogout() async => discarded = true;
}
