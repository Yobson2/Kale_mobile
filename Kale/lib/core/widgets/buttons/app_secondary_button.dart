import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// Secondary tonal button with scale press feedback.
///
/// Uses [surfaceContainerHigh] background with no border.
class AppSecondaryButton extends StatefulWidget {
  /// Creates an [AppSecondaryButton].
  const AppSecondaryButton({
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

  /// Callback when pressed.
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
  State<AppSecondaryButton> createState() => _AppSecondaryButtonState();
}

class _AppSecondaryButtonState extends State<AppSecondaryButton> {
  bool _isPressed = false;

  bool get _isEnabled => !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedScale(
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
            color: _isEnabled
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: AppRadius.borderRadiusMd,
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onSurface,
                  ),
                )
              : Row(
                  mainAxisSize:
                      widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: 20,
                        color: colorScheme.onSurface,
                      ),
                      AppSpacing.horizontalSm,
                    ],
                    Text(
                      widget.text,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
