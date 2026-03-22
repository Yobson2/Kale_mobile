import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/budget_health_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/cash_flow_summary_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/financial_health_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/savings_overview_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/cards/streak_card.dart';
import 'package:kale/features/dashboard/presentation/widgets/charts/chart_carousel.dart';
import 'package:kale/features/dashboard/presentation/widgets/period_selector.dart';
import 'package:kale/features/dashboard/presentation/widgets/sections/quick_actions_section.dart';
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

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                centerTitle: false,
                title: _buildGreeting(context, userName),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // TODO(dev): Navigate to notifications.
                    },
                  ),
                ],
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: PeriodSelector(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: CashFlowSummaryCard(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalMd),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: StreakCard(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: QuickActionsSection(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: ChartCarousel(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: Row(
                    children: [
                      Expanded(child: BudgetHealthCard()),
                      AppSpacing.horizontalMd,
                      Expanded(child: SavingsOverviewCard()),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: FinancialHealthCard(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalLg,
                  child: RecentTransactionsSection(),
                ),
              ),
              const SliverToBoxAdapter(child: AppSpacing.verticalLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String userName) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? context.l10n.homeGreetingMorning
        : hour < 17
            ? context.l10n.homeGreetingAfternoon
            : context.l10n.homeGreetingEvening;

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
