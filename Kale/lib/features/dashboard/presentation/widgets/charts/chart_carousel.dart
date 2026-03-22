import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/dashboard/presentation/widgets/charts/category_breakdown_chart.dart';
import 'package:kale/features/dashboard/presentation/widgets/charts/income_expense_chart.dart';

/// A horizontally swipeable carousel that displays the
/// [IncomeExpenseChart] and [CategoryBreakdownChart] with dot indicators.
class ChartCarousel extends StatefulWidget {
  /// Creates a [ChartCarousel].
  const ChartCarousel({super.key});

  @override
  State<ChartCarousel> createState() => _ChartCarouselState();
}

class _ChartCarouselState extends State<ChartCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _pageCount = 2;
  static const double _pageViewHeight = 320;
  static const double _dotSize = 8;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ClipRect(
          child: SizedBox(
            height: _pageViewHeight,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                IncomeExpenseChart(),
                CategoryBreakdownChart(),
              ],
            ),
          ),
        ),
        AppSpacing.verticalSm,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_pageCount, (index) {
            final isActive = index == _currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
              ),
              child: Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
