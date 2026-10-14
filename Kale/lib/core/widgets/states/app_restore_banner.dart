import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/core/sync/sync_puller.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Banner shown while the account is being restored on this device, with
/// how many items have arrived so far. Hidden otherwise.
class AppRestoreBanner extends ConsumerWidget {
  /// Creates an [AppRestoreBanner].
  const AppRestoreBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status =
        ref.watch(pullStatusProvider).valueOrNull ?? const PullStatus();
    if (!status.isPulling || !status.isRestore) return const SizedBox.shrink();

    final colors = context.colorScheme;
    final message = context.l10n.restoreInProgress(status.rowsPulled);
    return Semantics(
      liveRegion: true,
      label: message,
      child: ColoredBox(
        color: colors.primaryContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_download_outlined,
                    size: 16,
                    color: colors.onPrimaryContainer,
                  ),
                  AppSpacing.horizontalSm,
                  Flexible(
                    child: Text(
                      message,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              minHeight: 2,
              color: colors.primary,
              backgroundColor: colors.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
