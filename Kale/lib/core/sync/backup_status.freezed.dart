// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupStatus {
  /// Changes waiting to be pushed (will be retried automatically).
  int get pendingCount;

  /// Changes that failed every retry this session. They stay queued and
  /// are re-attempted on manual retry or on the next app start.
  int get stuckCount;

  /// Whether a sync run is pushing changes right now.
  bool get isSyncing;

  /// Whether the device last reported no connectivity.
  bool get isOffline;

  /// When the queue was last fully pushed: everything changed before
  /// this moment is on the server. Null if that never happened.
  DateTime? get lastBackupAt;

  /// Create a copy of BackupStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BackupStatusCopyWith<BackupStatus> get copyWith =>
      _$BackupStatusCopyWithImpl<BackupStatus>(
          this as BackupStatus, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BackupStatus &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.stuckCount, stuckCount) ||
                other.stuckCount == stuckCount) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.lastBackupAt, lastBackupAt) ||
                other.lastBackupAt == lastBackupAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pendingCount, stuckCount,
      isSyncing, isOffline, lastBackupAt);

  @override
  String toString() {
    return 'BackupStatus(pendingCount: $pendingCount, stuckCount: $stuckCount, isSyncing: $isSyncing, isOffline: $isOffline, lastBackupAt: $lastBackupAt)';
  }
}

/// @nodoc
abstract mixin class $BackupStatusCopyWith<$Res> {
  factory $BackupStatusCopyWith(
          BackupStatus value, $Res Function(BackupStatus) _then) =
      _$BackupStatusCopyWithImpl;
  @useResult
  $Res call(
      {int pendingCount,
      int stuckCount,
      bool isSyncing,
      bool isOffline,
      DateTime? lastBackupAt});
}

/// @nodoc
class _$BackupStatusCopyWithImpl<$Res> implements $BackupStatusCopyWith<$Res> {
  _$BackupStatusCopyWithImpl(this._self, this._then);

  final BackupStatus _self;
  final $Res Function(BackupStatus) _then;

  /// Create a copy of BackupStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingCount = null,
    Object? stuckCount = null,
    Object? isSyncing = null,
    Object? isOffline = null,
    Object? lastBackupAt = freezed,
  }) {
    return _then(_self.copyWith(
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      stuckCount: null == stuckCount
          ? _self.stuckCount
          : stuckCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSyncing: null == isSyncing
          ? _self.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _self.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastBackupAt: freezed == lastBackupAt
          ? _self.lastBackupAt
          : lastBackupAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _BackupStatus extends BackupStatus {
  const _BackupStatus(
      {this.pendingCount = 0,
      this.stuckCount = 0,
      this.isSyncing = false,
      this.isOffline = false,
      this.lastBackupAt})
      : super._();

  /// Changes waiting to be pushed (will be retried automatically).
  @override
  @JsonKey()
  final int pendingCount;

  /// Changes that failed every retry this session. They stay queued and
  /// are re-attempted on manual retry or on the next app start.
  @override
  @JsonKey()
  final int stuckCount;

  /// Whether a sync run is pushing changes right now.
  @override
  @JsonKey()
  final bool isSyncing;

  /// Whether the device last reported no connectivity.
  @override
  @JsonKey()
  final bool isOffline;

  /// When the queue was last fully pushed: everything changed before
  /// this moment is on the server. Null if that never happened.
  @override
  final DateTime? lastBackupAt;

  /// Create a copy of BackupStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BackupStatusCopyWith<_BackupStatus> get copyWith =>
      __$BackupStatusCopyWithImpl<_BackupStatus>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BackupStatus &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.stuckCount, stuckCount) ||
                other.stuckCount == stuckCount) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.lastBackupAt, lastBackupAt) ||
                other.lastBackupAt == lastBackupAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pendingCount, stuckCount,
      isSyncing, isOffline, lastBackupAt);

  @override
  String toString() {
    return 'BackupStatus(pendingCount: $pendingCount, stuckCount: $stuckCount, isSyncing: $isSyncing, isOffline: $isOffline, lastBackupAt: $lastBackupAt)';
  }
}

/// @nodoc
abstract mixin class _$BackupStatusCopyWith<$Res>
    implements $BackupStatusCopyWith<$Res> {
  factory _$BackupStatusCopyWith(
          _BackupStatus value, $Res Function(_BackupStatus) _then) =
      __$BackupStatusCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int pendingCount,
      int stuckCount,
      bool isSyncing,
      bool isOffline,
      DateTime? lastBackupAt});
}

/// @nodoc
class __$BackupStatusCopyWithImpl<$Res>
    implements _$BackupStatusCopyWith<$Res> {
  __$BackupStatusCopyWithImpl(this._self, this._then);

  final _BackupStatus _self;
  final $Res Function(_BackupStatus) _then;

  /// Create a copy of BackupStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pendingCount = null,
    Object? stuckCount = null,
    Object? isSyncing = null,
    Object? isOffline = null,
    Object? lastBackupAt = freezed,
  }) {
    return _then(_BackupStatus(
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      stuckCount: null == stuckCount
          ? _self.stuckCount
          : stuckCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSyncing: null == isSyncing
          ? _self.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      isOffline: null == isOffline
          ? _self.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastBackupAt: freezed == lastBackupAt
          ? _self.lastBackupAt
          : lastBackupAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
