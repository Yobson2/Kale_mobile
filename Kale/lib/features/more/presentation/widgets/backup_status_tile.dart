import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Settings row showing whether the user's data is backed up: stuck or
/// pending changes, the last successful backup, and a Retry action when
/// something is stuck.
class BackupStatusTile extends ConsumerWidget {
  /// Creates a [BackupStatusTile].
  const BackupStatusTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status =
        ref.watch(backupStatusProvider).valueOrNull ?? const BackupStatus();
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final isStuck = status.stuckCount > 0;

    final (icon, iconColor, title) = switch (status) {
      BackupStatus(:final stuckCount) when stuckCount > 0 => (
          Icons.cloud_off,
          colors.error,
          l10n.backupStuck(stuckCount),
        ),
      BackupStatus(:final pendingCount) when pendingCount > 0 => (
          Icons.cloud_upload_outlined,
          colors.primary,
          l10n.settingsBackupPending(pendingCount),
        ),
      _ => (
          Icons.cloud_done_outlined,
          colors.primary,
          l10n.settingsBackupUpToDate
        ),
    };

    final lastBackupAt = status.lastBackupAt;
    final subtitle = lastBackupAt == null
        ? l10n.settingsBackupNever
        : l10n.settingsBackupLast(_formatTime(context, lastBackupAt));

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: AppRadius.borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isStuck ? colors.error : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isStuck)
              TextButton(
                onPressed: () => ref.read(syncEngineProvider).retry(),
                child: Text(l10n.commonRetry),
              )
            else if (status.isSyncing)
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).add_Hm().format(time);
  }
}
