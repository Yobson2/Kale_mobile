import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// Rate App page — prompt user to rate with star icons.
class RateAppPage extends StatefulWidget {
  /// Creates a [RateAppPage].
  const RateAppPage({super.key});

  @override
  State<RateAppPage> createState() => _RateAppPageState();
}

class _RateAppPageState extends State<RateAppPage> {
  int _selectedRating = 0;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: context.l10n.moreRateApp),
      body: Stack(
        children: [
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 180,
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 20),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingXl,
                child: _submitted
                    ? _ThankYouState(context: context)
                    : _RatingState(
                        selectedRating: _selectedRating,
                        onRatingChanged: (rating) {
                          setState(() => _selectedRating = rating);
                        },
                        onSubmit: _selectedRating > 0
                            ? () => setState(() => _submitted = true)
                            : null,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rating selection UI.
class _RatingState extends StatelessWidget {
  const _RatingState({
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final int selectedRating;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 80,
          color: context.colorScheme.primary,
        ),
        AppSpacing.verticalLg,
        Text(
          context.l10n.rateAppTitle,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalSm,
        Text(
          context.l10n.rateAppSubtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalXxl,

        // Star rating row
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderRadiusLg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starNumber = index + 1;
              final isSelected = starNumber <= selectedRating;
              return GestureDetector(
                onTap: () => onRatingChanged(starNumber),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 44,
                    color: isSelected
                        ? Colors.amber
                        : context.colorScheme.outlineVariant,
                  ),
                ),
              );
            }),
          ),
        ),
        if (selectedRating > 0) ...[
          AppSpacing.verticalMd,
          Text(
            _ratingLabel(selectedRating, context),
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.primary,
            ),
          ),
        ],
        AppSpacing.verticalXxl,

        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onSubmit,
            child: Text(context.l10n.rateAppSubmit),
          ),
        ),
      ],
    );
  }

  String _ratingLabel(int rating, BuildContext context) {
    return switch (rating) {
      1 => context.l10n.rateAppLabel1,
      2 => context.l10n.rateAppLabel2,
      3 => context.l10n.rateAppLabel3,
      4 => context.l10n.rateAppLabel4,
      5 => context.l10n.rateAppLabel5,
      _ => '',
    };
  }
}

/// Thank you state after submission.
class _ThankYouState extends StatelessWidget {
  const _ThankYouState({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite_rounded,
          size: 80,
          color: context.colorScheme.primary,
        ),
        AppSpacing.verticalLg,
        Text(
          context.l10n.rateAppThankYou,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalSm,
        Text(
          context.l10n.rateAppThankYouMessage,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
