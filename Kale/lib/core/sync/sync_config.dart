import 'dart:math';

/// Configuration for the sync engine's retry behavior.
class SyncConfig {
  /// Creates a [SyncConfig].
  const SyncConfig({
    this.maxRetries = 5,
    this.initialBackoffMs = 1000,
    this.maxBackoffMs = 60000,
    this.backoffMultiplier = 2.0,
    this.batchSize = 10,
    this.writeDebounce = const Duration(seconds: 2),
  });

  /// Failed attempts (network errors excepted) after which an entry is
  /// marked stuck.
  final int maxRetries;

  /// Initial backoff delay in milliseconds.
  final int initialBackoffMs;

  /// Maximum backoff delay in milliseconds.
  final int maxBackoffMs;

  /// Multiplier for exponential backoff.
  final double backoffMultiplier;

  /// Number of queue entries to process per sync batch.
  final int batchSize;

  /// How long after the last local write to wait before pushing, so a
  /// burst of writes goes up in one sync run.
  final Duration writeDebounce;

  /// Calculates the backoff delay for a given retry count.
  Duration backoffFor(int retryCount) {
    final ms = (initialBackoffMs * pow(backoffMultiplier, retryCount))
        .clamp(0, maxBackoffMs)
        .toInt();
    return Duration(milliseconds: ms);
  }
}
