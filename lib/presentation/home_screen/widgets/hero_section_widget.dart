import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main headline
          Text(
            'Next-Gen Health Platform',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),

          // Subtext description
          Container(
            constraints: BoxConstraints(maxWidth: 85.w),
            child: Text(
              'AI-powered health intelligence for real-time monitoring, emergency response, and personalized health insights across India',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 1.h),

          // Health status indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Health Zone: Safe',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
