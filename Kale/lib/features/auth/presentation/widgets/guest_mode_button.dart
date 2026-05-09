import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Guest mode button with gradient border effect.
class GuestModeButton extends StatelessWidget {
  const GuestModeButton({
    required this.onPressed,
    required this.colorScheme,
    required this.label,
    super.key,
  });

  final VoidCallback onPressed;
  final ColorScheme colorScheme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderRadiusMd,
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.2),
              colorScheme.primaryContainer.withValues(alpha: 0.2),
            ],
          ),
        ),
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: AppRadius.borderRadiusMd,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bolt,
                size: 20,
                color: colorScheme.primary,
              ),
              AppSpacing.horizontalSm,
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
