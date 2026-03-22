import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/widgets/buttons/app_quick_action.dart';

/// Horizontal row of quick-action buttons for the dashboard.
class QuickActionsSection extends StatelessWidget {
  /// Creates a [QuickActionsSection].
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppQuickAction(
          icon: Icons.add_rounded,
          label: context.l10n.dashboardQuickAdd,
          onTap: () => context.pushNamed(RouteNames.addTransactionName),
        ),
        AppQuickAction(
          icon: Icons.pie_chart_rounded,
          label: context.l10n.dashboardQuickBudget,
          onTap: () => context.go(RouteNames.budget),
        ),
        AppQuickAction(
          icon: Icons.savings_rounded,
          label: context.l10n.dashboardQuickSavings,
          onTap: () => context.pushNamed(RouteNames.savingsGoalsName),
        ),
      ],
    );
  }
}
