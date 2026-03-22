import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// A full-screen overlay that displays a coach mark tooltip.
///
/// Used for first-time user experience (FTUE) to guide users
/// through key features of the app. Tapping anywhere on the
/// overlay or the dismiss button will call [onDismiss].
class AppCoachMark extends StatefulWidget {
  /// Creates an [AppCoachMark] overlay.
  const AppCoachMark({
    required this.message,
    required this.onDismiss,
    this.dismissText = 'Got it',
    super.key,
  });

  /// The instructional message to display in the tooltip.
  final String message;

  /// Called when the user dismisses the coach mark.
  final VoidCallback onDismiss;

  /// Text for the dismiss button. Defaults to 'Got it'.
  final String dismissText;

  @override
  State<AppCoachMark> createState() => _AppCoachMarkState();
}

class _AppCoachMarkState extends State<AppCoachMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Material(
          color: Colors.black54,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.xl),
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.borderRadiusLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.verticalMd,
                  Text(
                    widget.message,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalLg,
                  FilledButton(
                    onPressed: widget.onDismiss,
                    child: Text(widget.dismissText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
