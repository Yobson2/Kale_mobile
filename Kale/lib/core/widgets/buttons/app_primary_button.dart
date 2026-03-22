import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Primary gradient button with scale press feedback.
///
/// Uses a gradient fill from primary -> primaryContainer instead of a flat
/// [ElevatedButton]. Press feedback uses [AnimatedScale] at 0.98.
class AppPrimaryButton extends StatefulWidget {
  /// Creates an [AppPrimaryButton].
  const AppPrimaryButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.height = 52,
  });

  /// Button label text.
  final String text;

  /// Callback when pressed. Disabled when `null` or [isLoading].
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Shows a loading spinner and disables the button.
  final bool isLoading;

  /// Whether the button takes full width.
  final bool isExpanded;

  /// Button height.
  final double height;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _isPressed = false;

  bool get _isEnabled => !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.isLoading ? '${widget.text}, loading' : widget.text,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTapDown:
              _isEnabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: _isEnabled
              ? (_) {
                  setState(() => _isPressed = false);
                  widget.onPressed?.call();
                }
              : null,
          onTapCancel:
              _isEnabled ? () => setState(() => _isPressed = false) : null,
          child: Container(
            width: widget.isExpanded ? double.infinity : null,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: _isEnabled
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primaryContainer,
                      ],
                    )
                  : null,
              color: _isEnabled
                  ? null
                  : colorScheme.primary.withValues(alpha: 0.4),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            alignment: Alignment.center,
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisSize: widget.isExpanded
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 20,
                          color: colorScheme.onPrimary,
                        ),
                        AppSpacing.horizontalSm,
                      ],
                      Text(
                        widget.text,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
