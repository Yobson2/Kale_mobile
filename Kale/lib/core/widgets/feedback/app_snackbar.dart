import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Snackbar variant types.
enum SnackBarVariant { success, error, warning, info }

/// Shows a themed snackbar with icon and color based on [variant].
void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackBarVariant variant = SnackBarVariant.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final (color, icon) = switch (variant) {
    SnackBarVariant.success => (
        isDark ? AppColors.successDark : AppColors.successLight,
        Icons.check_circle,
      ),
    SnackBarVariant.error => (
        isDark ? AppColors.errorDark : AppColors.errorLight,
        Icons.error,
      ),
    SnackBarVariant.warning => (
        isDark ? AppColors.warningDark : AppColors.warningLight,
        Icons.warning_amber,
      ),
    SnackBarVariant.info => (
        isDark ? AppColors.infoDark : AppColors.infoLight,
        Icons.info,
      ),
  };

  const foreground = Colors.white;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: foreground, size: 20),
            AppSpacing.horizontalSm,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: foreground),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        duration: duration,
        margin: AppSpacing.paddingLg,
      ),
    );
}
