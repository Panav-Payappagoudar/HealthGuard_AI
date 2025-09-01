import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HealthStatusSummaryWidget extends StatelessWidget {
  const HealthStatusSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final lastUpdate = now.subtract(const Duration(minutes: 3));

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'health_and_safety',
                color: theme.colorScheme.tertiary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Health Status Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'SAFE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Status indicators
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  context: context,
                  title: 'Current Zone',
                  value: 'Green',
                  color: theme.colorScheme.tertiary,
                  iconName: 'location_on',
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildStatusItem(
                  context: context,
                  title: 'Risk Level',
                  value: 'Low',
                  color: theme.colorScheme.tertiary,
                  iconName: 'shield',
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildStatusItem(
                  context: context,
                  title: 'Alerts',
                  value: '0',
                  color: theme.colorScheme.tertiary,
                  iconName: 'notifications',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Last update info
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: theme.colorScheme.onSurfaceVariant,
                size: 3.5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Last updated: ${_formatTime(lastUpdate)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Refresh action
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'refresh',
                      color: theme.colorScheme.primary,
                      size: 3.5.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Refresh',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required BuildContext context,
    required String title,
    required String value,
    required Color color,
    required String iconName,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 5.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
