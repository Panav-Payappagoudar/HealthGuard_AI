import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionButtonsWidget extends StatelessWidget {
  final Function(String) onQuickAction;

  const QuickActionButtonsWidget({
    super.key,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final quickActions = [
      {
        'title': 'Symptom Checker',
        'icon': 'health_and_safety',
        'action': 'I want to check my symptoms',
      },
      {
        'title': 'Medicine Info',
        'icon': 'medication',
        'action': 'Tell me about a medicine',
      },
      {
        'title': 'Find Doctor',
        'icon': 'local_hospital',
        'action': 'Help me find a doctor nearby',
      },
      {
        'title': 'Emergency Help',
        'icon': 'emergency',
        'action': 'I need emergency assistance',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: quickActions
                .map((action) => _buildQuickActionButton(
                      context,
                      action['title'] as String,
                      action['icon'] as String,
                      action['action'] as String,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    String iconName,
    String action,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onQuickAction(action),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.5.h,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: theme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
