import 'dart:async';

/// Time source for the `SyncEngine`: the current time and timers.
///
/// The engine never reads `DateTime.now()` or creates a [Timer] directly,
/// so tests can replace this with a fake clock and move time forward
/// without real waits (debounce, backoff).
class SyncClock {
  /// Creates a [SyncClock] backed by the system clock and real timers.
  const SyncClock();

  /// The current time.
  DateTime now() => DateTime.now();

  /// Runs [callback] once after [duration].
  Timer timer(Duration duration, void Function() callback) =>
      Timer(duration, callback);
}
