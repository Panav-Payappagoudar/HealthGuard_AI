import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapBottomSheetWidget extends StatelessWidget {
  final String currentLocationStatus;
  final VoidCallback onReportCase;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const MapBottomSheetWidget({
    super.key,
    required this.currentLocationStatus,
    required this.onReportCase,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: isExpanded ? 0.4 : 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor,
                offset: const Offset(0, -2),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              GestureDetector(
                onTap: onToggleExpanded,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: _getStatusColor(currentLocationStatus, theme),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Location Status',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${currentLocationStatus.toUpperCase()} RISK ZONE',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(
                                    currentLocationStatus, theme),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconWidget(
                        iconName: isExpanded
                            ? 'keyboard_arrow_down'
                            : 'keyboard_arrow_up',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded content
              if (isExpanded)
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Zone legend
                        _buildZoneLegend(context),

                        SizedBox(height: 3.h),

                        // Report case button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onReportCase,
                            icon: CustomIconWidget(
                              iconName: 'report',
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                            label: const Text('Report Health Case'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Safety tips
                        _buildSafetyTips(context),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZoneLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Zone Legend',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        _buildLegendItem(context, 'High Risk', 'Active outbreak areas',
            theme.colorScheme.error),
        SizedBox(height: 1.h),
        _buildLegendItem(context, 'Medium Risk', 'Elevated case numbers',
            AppTheme.warningLight),
        SizedBox(height: 1.h),
        _buildLegendItem(
            context, 'Low Risk', 'Safe zones', AppTheme.successLight),
      ],
    );
  }

  Widget _buildLegendItem(
      BuildContext context, String title, String description, Color color) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 3.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTips(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'health_and_safety',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Safety Recommendations',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            currentLocationStatus == 'high'
                ? '• Avoid crowded areas\n• Wear protective masks\n• Maintain social distancing\n• Seek medical attention if symptoms appear'
                : currentLocationStatus == 'medium'
                    ? '• Stay alert for symptoms\n• Follow hygiene protocols\n• Limit non-essential travel\n• Monitor health updates'
                    : '• Continue preventive measures\n• Stay informed about changes\n• Report any symptoms promptly\n• Support community health efforts',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'high':
        return theme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}
