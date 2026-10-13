import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/sync/sync_app_lifecycle.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockSyncEngine extends Mock implements SyncEngine {}

void main() {
  testWidgets('starts the engine at launch and pushes on resume',
      (tester) async {
    final engine = _MockSyncEngine();
    var created = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncEngineProvider.overrideWith((ref) {
            created++;
            return engine;
          }),
        ],
        child: const SyncAppLifecycle(child: SizedBox()),
      ),
    );
    expect(created, 1);
    verifyNever(engine.onAppResumed);

    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden)
      ..handleAppLifecycleStateChanged(AppLifecycleState.paused)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden)
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    verify(engine.onAppResumed).called(1);
  });
}
