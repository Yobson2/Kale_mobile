// ── Period Selector ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';

class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dashboardPeriodNotifierProvider);

    return Row(
      children: DashboardPeriod.values.map((period) {
        final isSelected = period == selected;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: ChoiceChip(
            label: Text(_periodLabel(period)),
            selected: isSelected,
            onSelected: (_) {
              ref
                  .read(dashboardPeriodNotifierProvider.notifier)
                  .setPeriod(period);
            },
            selectedColor: context.colorScheme.primary,
            labelStyle: TextStyle(
              color: isSelected
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusFull,
            ),
            side: BorderSide.none,
          ),
        );
      }).toList(),
    );
  }

  String _periodLabel(DashboardPeriod period) {
    return switch (period) {
      DashboardPeriod.daily => 'Daily',
      DashboardPeriod.weekly => 'Weekly',
      DashboardPeriod.monthly => 'Monthly',
    };
  }
}
