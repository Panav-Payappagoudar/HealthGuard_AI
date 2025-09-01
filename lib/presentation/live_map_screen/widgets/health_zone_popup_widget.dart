import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthZonePopupWidget extends StatelessWidget {
  final Map<String, dynamic> zoneData;
  final VoidCallback onClose;

  const HealthZonePopupWidget({
    super.key,
    required this.zoneData,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskLevel = zoneData['riskLevel'] as String;
    final Color riskColor = _getRiskColor(riskLevel, theme);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: riskColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    zoneData['zoneName'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Risk level badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${riskLevel.toUpperCase()} RISK',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: riskColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Active Cases',
                        zoneData['activeCases'].toString(),
                        CustomIconWidget(
                          iconName: 'coronavirus',
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Population',
                        _formatNumber(zoneData['population'] as int),
                        CustomIconWidget(
                          iconName: 'people',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Trend indicator
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: zoneData['trend'] == 'increasing'
                          ? 'trending_up'
                          : zoneData['trend'] == 'decreasing'
                              ? 'trending_down'
                              : 'trending_flat',
                      color: zoneData['trend'] == 'increasing'
                          ? theme.colorScheme.error
                          : zoneData['trend'] == 'decreasing'
                              ? AppTheme.successLight
                              : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Cases ${zoneData['trend']} by ${zoneData['trendPercentage']}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Last updated
                Text(
                  'Last updated: ${zoneData['lastUpdated']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String label, String value, Widget icon) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel, ThemeData theme) {
    switch (riskLevel.toLowerCase()) {
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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
