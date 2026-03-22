import 'package:flutter/material.dart';

/// Wraps a child widget with a staggered fade + slide-up entrance animation.
///
/// Use this inside list builders to animate items appearing one after another.
/// The [index] determines the stagger delay (capped at 8 items for performance).
class StaggeredListItem extends StatefulWidget {
  /// Creates a [StaggeredListItem].
  const StaggeredListItem({
    required this.index,
    required this.child,
    super.key,
  });

  /// The index of this item in the list (used for stagger delay).
  final int index;

  /// The widget to animate.
  final Widget child;

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Stagger delay capped at 8 items to avoid long waits for big lists.
    final delay = Duration(milliseconds: 60 * widget.index.clamp(0, 8));
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
