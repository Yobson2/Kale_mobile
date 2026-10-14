import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Banner that tells the user when their data is not safely backed up.
///
/// Shows, in priority order: stuck changes ("N changes not backed up ·
/// Retry"), pending changes while offline, and a backup in progress.
/// Hidden otherwise. Place below the app bar in a [Column] or as part of
/// a [Scaffold] body.
class SyncStatusBanner extends ConsumerWidget {
  /// Creates a [SyncStatusBanner].
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(backupStatusProvider).valueOrNull;
    if (status == null) return const SizedBox.shrink();

    final colors = context.colorScheme;
    final l10n = context.l10n;

    return switch (status) {
      BackupStatus(:final stuckCount) when stuckCount > 0 => _Banner(
          icon: Icons.cloud_off,
          message: l10n.backupStuck(stuckCount),
          color: colors.error,
          action: TextButton(
            onPressed: () => ref.read(syncEngineProvider).retry(),
            child: Text(
              l10n.commonRetry,
              style: TextStyle(color: colors.onError),
            ),
          ),
        ),
      BackupStatus(:final pendingCount, isOffline: true)
          when pendingCount > 0 =>
        _Banner(
          icon: Icons.cloud_off,
          message: l10n.backupOfflinePending(pendingCount),
          color: colors.surfaceContainerHighest,
        ),
      BackupStatus(isSyncing: true) => _Banner(
          icon: Icons.cloud_sync,
          message: l10n.backupSyncing,
          color: colors.primary,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.message,
    required this.color,
    this.action,
  });

  final IconData icon;
  final String message;
  final Color color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.lg,
      ),
      color: color,
      child: Row(
        children: [
          Icon(icon, size: 16, color: foreground),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
