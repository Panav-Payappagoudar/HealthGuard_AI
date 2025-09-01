import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class HealthSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> healthSummary;
  final VoidCallback onGenerateInsights;
  final bool isGeneratingInsights;
  final String? aiInsights;

  const HealthSummaryWidget({
    super.key,
    required this.healthSummary,
    required this.onGenerateInsights,
    required this.isGeneratingInsights,
    this.aiInsights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 24.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Health Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getRiskColor(healthSummary['riskScore'])
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Text(
                  '${healthSummary['riskScore'] ?? 'N/A'} Risk',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getRiskColor(healthSummary['riskScore']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Health stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Last Checkup',
                  value: healthSummary['lastCheckup'] ?? 'N/A',
                  icon: Icons.event_outlined,
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'Symptom Reports',
                  value: '${healthSummary['symptomReports'] ?? 0}',
                  icon: Icons.report_outlined,
                  color: Colors.orange,
                  theme: theme,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'AI Consultations',
                  value: '${healthSummary['aiConsultations'] ?? 0}',
                  icon: Icons.psychology_outlined,
                  color: Colors.purple,
                  theme: theme,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'Profile Complete',
                  value:
                      '${((healthSummary['completionProgress'] ?? 0.0) * 100).round()}%',
                  icon: Icons.person_outline,
                  color: Colors.green,
                  theme: theme,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Profile completion progress
          _buildProgressSection(theme),

          SizedBox(height: 16.h),

          // AI Insights section
          _buildAIInsightsSection(theme),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16.w,
                color: color,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(ThemeData theme) {
    final progress = healthSummary['completionProgress'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              size: 16.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4.w),
            Text(
              'Profile Completion Progress',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 0.8
                ? Colors.green
                : progress >= 0.5
                    ? Colors.orange
                    : Colors.red,
          ),
          minHeight: 6.h,
        ),
        SizedBox(height: 4.h),
        Text(
          _getCompletionMessage(progress),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightsSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                size: 16.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'AI Health Insights',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (!isGeneratingInsights)
                TextButton.icon(
                  onPressed: onGenerateInsights,
                  icon: Icon(Icons.refresh, size: 16.w),
                  label: Text('Generate'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          if (isGeneratingInsights)
            Container(
              height: 60.h,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Generating personalized insights...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (aiInsights != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.sp),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                aiInsights!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            )
          else
            Text(
              'Get personalized health insights based on your profile and activity. Our AI analyzes your data to provide tailored recommendations.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Color _getRiskColor(String? riskLevel) {
    switch (riskLevel?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getCompletionMessage(double progress) {
    if (progress >= 0.8) {
      return 'Excellent! Your profile is almost complete.';
    } else if (progress >= 0.5) {
      return 'Good progress. Add more details for better insights.';
    } else {
      return 'Complete your profile for personalized health recommendations.';
    }
  }
}