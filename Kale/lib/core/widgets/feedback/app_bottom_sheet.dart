import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Shows a themed modal bottom sheet with ghost shadow.
///
/// Uses [surfaceContainerLowest] background and top-only 24px radius.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
  bool isDismissible = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: colorScheme.surfaceContainerLowest,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.borderRadiusTopXl,
    ),
    builder: (ctx) => Padding(
      padding: AppSpacing.paddingLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(ctx).colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
              borderRadius: AppRadius.borderRadiusFull,
            ),
          ),
          builder(ctx),
        ],
      ),
    ),
  );
}
