import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';

/// Financial Insights page — spending analysis, top categories,
/// and actionable recommendations.
class InsightsPage extends ConsumerWidget {
  /// Creates an [InsightsPage].
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Insights',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: summaryAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (_, __) => Center(
          child: Text('Something went wrong. Please try again.'),
        ),
        data: (summary) {
          final totalExpenses = summary.totalExpenses;
          final totalIncome = summary.totalIncome;
          final savingsRate = totalIncome > 0
              ? ((totalIncome - totalExpenses) / totalIncome * 100).round()
              : 0;
          final sorted = summary.topExpenseCategories.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final total = sorted.fold<double>(0, (s, e) => s + e.value);

          return SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'PERFORMANCE REPORT',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.65,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalXs,
                Text(
                  'Insights',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalXl,

                // Spending Trends card
                _SpendingTrendsCard(
                  totalExpenses: totalExpenses,
                  isDark: isDark,
                ),
                AppSpacing.verticalLg,

                // Top Categories
                _TopCategoriesCard(
                  categories: sorted.take(4).toList(),
                  categoryNames: summary.categoryNames,
                  categoryColors: summary.categoryColors,
                  total: total,
                ),
                AppSpacing.verticalLg,

                // Money habit pills
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _HabitPill(
                        icon: Icons.calendar_today,
                        label: 'Avg daily spend',
                        value: CurrencyFormatter.format(
                          totalExpenses / 30,
                          compact: true,
                        ),
                        color: context.colorScheme.primary,
                        bgColor: context.colorScheme.primaryContainer
                            .withValues(alpha: 0.15),
                      ),
                      AppSpacing.horizontalMd,
                      _HabitPill(
                        icon: Icons.savings_outlined,
                        label: 'Savings Rate',
                        value: '$savingsRate%',
                        color: AppColors.infoLight,
                        bgColor: AppColors.infoLight.withValues(alpha: 0.1),
                      ),
                      AppSpacing.horizontalMd,
                      _HabitPill(
                        icon: Icons.bolt,
                        label: 'Impulse Score',
                        value: totalExpenses > totalIncome * 0.8
                            ? 'High'
                            : 'Low',
                        color: isDark
                            ? AppColors.warningDark
                            : AppColors.warningLight,
                        bgColor: (isDark
                                ? AppColors.warningDark
                                : AppColors.warningLight)
                            .withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
                AppSpacing.verticalXl,

                // Recommendations
                Text(
                  'Recommendations',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalLg,

                _RecommendationCard(
                  icon: Icons.lightbulb,
                  iconColor: isDark
                      ? AppColors.tertiaryDark
                      : AppColors.tertiaryLight,
                  title: 'Optimize Subscriptions',
                  description:
                      'Review recurring expenses to identify potential '
                      'savings. Small cuts compound over time.',
                  actionLabel: 'REVIEW SPENDING',
                ),
                AppSpacing.verticalMd,

                _RecommendationCard(
                  icon: Icons.rocket_launch,
                  iconColor: context.colorScheme.primary,
                  title: 'Boost Your Emergency Fund',
                  description: totalIncome > totalExpenses
                      ? 'You have a surplus of '
                          '${CurrencyFormatter.format(totalIncome - totalExpenses, compact: true)}'
                          ' this period. Consider moving it to savings.'
                      : 'Building an emergency fund provides a safety net '
                          'for unexpected expenses.',
                  actionLabel: 'VIEW SAVINGS',
                ),

                AppSpacing.verticalXxxl,
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Spending trends hero card.
class _SpendingTrendsCard extends StatelessWidget {
  const _SpendingTrendsCard({
    required this.totalExpenses,
    required this.isDark,
  });

  final double totalExpenses;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingXl,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Trends',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Outflow velocity compared to last month',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(totalExpenses, compact: true),
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.verticalXl,
          // Simplified sparkline using CustomPaint
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _SparklinePainter(
                color: context.colorScheme.primary,
                fillColor:
                    context.colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          AppSpacing.verticalMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                .map(
                  (d) => Text(
                    d,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Top categories card with horizontal progress bars.
class _TopCategoriesCard extends StatelessWidget {
  const _TopCategoriesCard({
    required this.categories,
    required this.categoryNames,
    required this.categoryColors,
    required this.total,
  });

  final List<MapEntry<String, double>> categories;
  final Map<String, String> categoryNames;
  final Map<String, String> categoryColors;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final barColors = [
      context.colorScheme.primary,
      context.colorScheme.primaryContainer,
      context.colorScheme.tertiaryContainer,
      context.colorScheme.secondaryContainer,
    ];

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Categories',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalLg,
          ...categories.asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value;
            final name = categoryNames[cat.key] ?? cat.key;
            final percent =
                total > 0 ? (cat.value / total * 100).round() : 0;
            final color = barColors[i % barColors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: AppRadius.borderRadiusFull,
                    child: LinearProgressIndicator(
                      value: (percent / 100).clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: context.colorScheme.outlineVariant
                          .withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ],
              ),
            );
          }),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Full breakdown',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: context.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Habit pill chip.
class _HabitPill extends StatelessWidget {
  const _HabitPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          AppSpacing.horizontalSm,
          Text(
            '$label: ',
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Recommendation card with icon, title, description, and action button.
class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                AppSpacing.verticalMd,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Text(
                    actionLabel,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple sparkline painter for the spending trends chart.
class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.color, required this.fillColor});

  final Color color;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.75),
      Offset(size.width * 0.3, size.height * 0.35),
      Offset(size.width * 0.45, size.height * 0.55),
      Offset(size.width * 0.6, size.height * 0.2),
      Offset(size.width * 0.75, size.height * 0.45),
      Offset(size.width, size.height * 0.35),
    ];

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      final cp1x = (points[i - 1].dx + points[i].dx) / 2;
      path.cubicTo(
        cp1x,
        points[i - 1].dy,
        cp1x,
        points[i].dy,
        points[i].dx,
        points[i].dy,
      );
    }

    // Fill
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, Paint()..color = fillColor);
    canvas.drawPath(path, linePaint);

    // Draw dots at key points
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final p in [points[2], points[4]]) {
      canvas.drawCircle(p, 5, dotBorderPaint);
      canvas.drawCircle(p, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
