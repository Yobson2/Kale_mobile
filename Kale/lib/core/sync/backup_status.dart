import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_status.freezed.dart';

/// Whether the user's data is safely backed up, as the `SyncEngine`
/// sees it. Drives the sync banner and the Settings backup row.
@freezed
abstract class BackupStatus with _$BackupStatus {
  /// Creates a [BackupStatus].
  const factory BackupStatus({
    /// Changes waiting to be pushed (will be retried automatically).
    @Default(0) int pendingCount,

    /// Changes that failed every retry this session. They stay queued and
    /// are re-attempted on manual retry or on the next app start.
    @Default(0) int stuckCount,

    /// Whether a sync run is pushing changes right now.
    @Default(false) bool isSyncing,

    /// Whether the device last reported no connectivity.
    @Default(false) bool isOffline,

    /// When the queue was last fully pushed: everything changed before
    /// this moment is on the server. Null if that never happened.
    DateTime? lastBackupAt,
  }) = _BackupStatus;

  const BackupStatus._();

  /// Whether every local change is on the server.
  bool get isFullyBackedUp => pendingCount == 0 && stuckCount == 0;
}
