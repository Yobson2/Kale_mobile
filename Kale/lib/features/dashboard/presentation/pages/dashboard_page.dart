import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/budget_health_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/cash_flow_summary_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/savings_overview_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/charts/category_breakdown_chart.dart';
import 'package:kale/features/dashboard/presentation/widgets/charts/income_expense_chart.dart';
import 'package:kale/features/dashboard/presentation/widgets/period_selector.dart';
import 'package:kale/features/dashboard/presentation/widgets/sections/recent_transactions_section.dart';

/// Main dashboard page showing financial summary, charts, and recent
/// transactions for the selected period.
class DashboardPage extends ConsumerWidget {
  /// Creates a [DashboardPage].
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = switch (authState) {
      AuthAuthenticated(:final user) => user.name,
      _ => 'User',
    };

    final greetingPose =
        DateTime.now().hour < 12 ? KaiPose.welcome : KaiPose.idle;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.homeTitle,
        showBackButton: false,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: KaiMascot(pose: greetingPose, size: 32),
        ),
        titleWidget: _buildGreeting(context, userName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO(dev): Navigate to notifications.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PeriodSelector(),
                AppSpacing.verticalLg,
                CashFlowSummaryCard(),
                AppSpacing.verticalLg,
                IncomeExpenseChart(),
                AppSpacing.verticalLg,
                CategoryBreakdownChart(),
                AppSpacing.verticalLg,
                BudgetHealthCard(),
                AppSpacing.verticalLg,
                SavingsOverviewCard(),
                AppSpacing.verticalLg,
                RecentTransactionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String userName) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          userName,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
