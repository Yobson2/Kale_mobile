import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/sync/sync_providers.dart';

/// Runs the `SyncEngine` for the app's lifetime: creates (and so starts)
/// it at launch, and tells it when the app returns to the foreground.
///
/// Wrap the app root with it once.
class SyncAppLifecycle extends ConsumerStatefulWidget {
  /// Creates a [SyncAppLifecycle] around [child].
  const SyncAppLifecycle({required this.child, super.key});

  /// The app.
  final Widget child;

  @override
  ConsumerState<SyncAppLifecycle> createState() => _SyncAppLifecycleState();
}

class _SyncAppLifecycleState extends ConsumerState<SyncAppLifecycle> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    ref.read(syncEngineProvider);
    _listener = AppLifecycleListener(
      onResume: () => ref.read(syncEngineProvider).onAppResumed(),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
