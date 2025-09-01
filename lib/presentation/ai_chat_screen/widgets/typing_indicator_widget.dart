import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TypingIndicatorWidget extends StatefulWidget {
  const TypingIndicatorWidget({super.key});

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: theme.colorScheme.primary,
                size: 4.w,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(1.w),
                bottomRight: Radius.circular(4.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor,
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 1.w),
                _buildDot(1),
                SizedBox(width: 1.w),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final delay = index * 0.2;
        final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
        final opacity = (animationValue * 2).clamp(0.0, 1.0);
        final scale = animationValue < 0.5
            ? 1.0 + (animationValue * 0.5)
            : 1.25 - ((animationValue - 0.5) * 0.5);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color:
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
        );
      },
    );
  }
}
