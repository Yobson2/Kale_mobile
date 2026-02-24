// ── Category Breakdown Pie Chart ──────────────────────────────

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/dashboard/presentation/widgets/items/legend_item.dart';

class CategoryBreakdownChart extends ConsumerWidget {
  const CategoryBreakdownChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return summaryAsync.when(
      data: (summary) {
        if (summary.topExpenseCategories.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildChart(context, summary);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildChart(BuildContext context, DashboardSummary summary) {
    final sorted = summary.topExpenseCategories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Top 5 categories + "Other".
    final top = sorted.take(5).toList();
    final otherTotal = sorted.skip(5).fold<double>(0, (s, e) => s + e.value);
    final total =
        summary.topExpenseCategories.values.fold<double>(0, (s, v) => s + v);

    if (total == 0) return const SizedBox.shrink();

    final sections = <PieChartSectionData>[];
    final legends = <LegendItem>[];

    for (final entry in top) {
      final percent = (entry.value / total * 100).round();
      final colorHex = summary.categoryColors[entry.key];
      final color = _parseHexColor(colorHex) ?? context.colorScheme.primary;
      final name = summary.categoryNames[entry.key] ?? entry.key;

      sections.add(
        PieChartSectionData(
          value: entry.value,
          color: color,
          radius: 32,
          title: '$percent%',
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
      legends.add(LegendItem(name: name, color: color, amount: entry.value));
    }

    if (otherTotal > 0) {
      final percent = (otherTotal / total * 100).round();
      sections.add(
        PieChartSectionData(
          value: otherTotal,
          color: Colors.grey,
          radius: 32,
          title: '$percent%',
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
      legends.add(
        LegendItem(name: 'Other', color: Colors.grey, amount: otherTotal),
      );
    }

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Breakdown',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalLg,
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 36,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                AppSpacing.horizontalLg,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: legends
                        .map(
                          (l) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: l.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                AppSpacing.horizontalSm,
                                Expanded(
                                  child: Text(
                                    l.name,
                                    style: context.textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(
                                    l.amount,
                                    compact: true,
                                  ),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null || hex.length < 6) return null;
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    if (value == null) return null;
    return Color(value);
  }
}
