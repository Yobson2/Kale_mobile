import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/core/widgets/feedback/sync_status_banner.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helpers.dart';

class _MockSyncEngine extends Mock implements SyncEngine {}

void main() {
  late _MockSyncEngine engine;

  setUp(() {
    engine = _MockSyncEngine();
    when(() => engine.retry()).thenAnswer((_) async {});
  });

  Future<void> pumpBanner(WidgetTester tester, BackupStatus status) async {
    await tester.pumpWidget(
      createTestApp(
        child: const Scaffold(body: SyncStatusBanner()),
        overrides: [
          backupStatusProvider.overrideWith((ref) => Stream.value(status)),
          syncEngineProvider.overrideWithValue(engine),
        ],
      ),
    );
    await tester.pump();
  }

  testWidgets('shows stuck changes with a Retry button that retries',
      (tester) async {
    await pumpBanner(tester, const BackupStatus(stuckCount: 3));

    expect(find.text('3 changes not backed up'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    verify(() => engine.retry()).called(1);
  });

  testWidgets('stuck changes win over offline and syncing', (tester) async {
    await pumpBanner(
      tester,
      const BackupStatus(
        stuckCount: 1,
        pendingCount: 2,
        isOffline: true,
        isSyncing: true,
      ),
    );

    expect(find.text('1 change not backed up'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows pending changes while offline', (tester) async {
    await pumpBanner(
      tester,
      const BackupStatus(pendingCount: 2, isOffline: true),
    );

    expect(find.text('Offline · 2 changes waiting'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('shows a backup in progress', (tester) async {
    await pumpBanner(
      tester,
      const BackupStatus(pendingCount: 2, isSyncing: true),
    );

    expect(find.text('Backing up…'), findsOneWidget);
  });

  for (final status in const [
    BackupStatus(),
    BackupStatus(pendingCount: 1), // Waiting for the debounce: no noise.
    BackupStatus(isOffline: true), // Offline with nothing to lose.
  ]) {
    testWidgets('is hidden for $status', (tester) async {
      await pumpBanner(tester, status);

      expect(find.byType(Text), findsNothing);
    });
  }
}
