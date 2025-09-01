import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class PrivacyControlsSectionWidget extends StatelessWidget {
  final bool dataShareEnabled;
  final bool locationTrackingEnabled;
  final bool healthDataStorageEnabled;
  final bool aiInteractionLoggingEnabled;
  final bool screenshotBlockingEnabled;
  final Function(bool) onDataShareChanged;
  final Function(bool) onLocationTrackingChanged;
  final Function(bool) onHealthDataStorageChanged;
  final Function(bool) onAiInteractionLoggingChanged;
  final Function(bool) onScreenshotBlockingChanged;

  const PrivacyControlsSectionWidget({
    super.key,
    required this.dataShareEnabled,
    required this.locationTrackingEnabled,
    required this.healthDataStorageEnabled,
    required this.aiInteractionLoggingEnabled,
    required this.screenshotBlockingEnabled,
    required this.onDataShareChanged,
    required this.onLocationTrackingChanged,
    required this.onHealthDataStorageChanged,
    required this.onAiInteractionLoggingChanged,
    required this.onScreenshotBlockingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
                Icons.privacy_tip_outlined,
                size: 24.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Privacy Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Privacy First',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Data sharing toggle
          _buildPrivacyToggle(
            title: 'Share Anonymized Data',
            subtitle: 'Help improve healthcare research with anonymized data',
            value: dataShareEnabled,
            onChanged: onDataShareChanged,
            icon: Icons.analytics_outlined,
            iconColor: dataShareEnabled
                ? Colors.blue
                : theme.colorScheme.onSurfaceVariant,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Location tracking toggle
          _buildPrivacyToggle(
            title: 'Location Tracking',
            subtitle:
                'Enable location services for nearby hospitals and health zones',
            value: locationTrackingEnabled,
            onChanged: onLocationTrackingChanged,
            icon: Icons.location_on_outlined,
            iconColor: locationTrackingEnabled
                ? Colors.orange
                : theme.colorScheme.onSurfaceVariant,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Health data storage toggle
          _buildPrivacyToggle(
            title: 'Health Data Storage',
            subtitle: 'Store health data locally for personalized insights',
            value: healthDataStorageEnabled,
            onChanged: onHealthDataStorageChanged,
            icon: Icons.storage_outlined,
            iconColor: healthDataStorageEnabled
                ? Colors.green
                : theme.colorScheme.onSurfaceVariant,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // AI interaction logging toggle
          _buildPrivacyToggle(
            title: 'AI Interaction Logging',
            subtitle:
                'Log AI conversations for better recommendations (encrypted)',
            value: aiInteractionLoggingEnabled,
            onChanged: onAiInteractionLoggingChanged,
            icon: Icons.psychology_outlined,
            iconColor: aiInteractionLoggingEnabled
                ? Colors.purple
                : theme.colorScheme.onSurfaceVariant,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Screenshot blocking toggle
          _buildPrivacyToggle(
            title: 'Screenshot Protection',
            subtitle: 'Prevent screenshots in sensitive areas of the app',
            value: screenshotBlockingEnabled,
            onChanged: onScreenshotBlockingChanged,
            icon: Icons.screenshot_outlined,
            iconColor: screenshotBlockingEnabled
                ? Colors.red
                : theme.colorScheme.onSurfaceVariant,
            theme: theme,
          ),

          SizedBox(height: 20.h),

          // Privacy summary
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security_outlined,
                      size: 20.w,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Your Privacy Status',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  _getPrivacySummary(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color iconColor,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: value
            ? iconColor.withValues(alpha: 0.05)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? iconColor.withValues(alpha: 0.2)
              : theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: iconColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: iconColor,
          ),
        ],
      ),
    );
  }

  String _getPrivacySummary() {
    final enabledCount = [
      dataShareEnabled,
      locationTrackingEnabled,
      healthDataStorageEnabled,
      aiInteractionLoggingEnabled,
      screenshotBlockingEnabled,
    ].where((setting) => setting).length;

    final String privacyLevel = enabledCount <= 1
        ? 'Maximum Privacy'
        : enabledCount <= 3
            ? 'Balanced Privacy'
            : 'Enhanced Features';

    return 'You have $enabledCount out of 5 privacy features enabled. '
        'Current level: $privacyLevel. All data is encrypted and stored securely.';
  }
}