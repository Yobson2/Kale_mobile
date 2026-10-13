import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
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
}

class _FixedAuthNotifier extends AuthNotifier {
  _FixedAuthNotifier(this._state);

  final AuthState _state;

  @override
  AuthState build() => _state;
}
