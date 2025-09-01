import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class SecuritySectionWidget extends StatelessWidget {
  final bool biometricEnabled;
  final VoidCallback onBiometricToggle;
  final VoidCallback onShowSessions;
  final VoidCallback onShowDevices;

  const SecuritySectionWidget({
    super.key,
    required this.biometricEnabled,
    required this.onBiometricToggle,
    required this.onShowSessions,
    required this.onShowDevices,
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
                Icons.security_outlined,
                size: 24.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Account Security',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getSecurityLevelColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getSecurityLevel(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getSecurityLevelColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Security status overview
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _getSecurityLevelColor().withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getSecurityLevelColor().withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  biometricEnabled
                      ? Icons.verified_outlined
                      : Icons.warning_outlined,
                  size: 24.w,
                  color: _getSecurityLevelColor(),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getSecurityStatusTitle(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _getSecurityStatusDescription(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Security options
          _buildSecurityOption(
            title: 'Biometric Authentication',
            subtitle: biometricEnabled
                ? 'Face ID/Fingerprint is enabled'
                : 'Enable Face ID or fingerprint authentication',
            icon: Icons.fingerprint_outlined,
            trailing: Switch.adaptive(
              value: biometricEnabled,
              onChanged: (_) => onBiometricToggle(),
            ),
            onTap: onBiometricToggle,
            theme: theme,
          ),

          SizedBox(height: 12.h),

          _buildSecurityOption(
            title: 'Active Sessions',
            subtitle: 'Manage your active login sessions',
            icon: Icons.devices_outlined,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onTap: onShowSessions,
            theme: theme,
          ),

          SizedBox(height: 12.h),

          _buildSecurityOption(
            title: 'Authorized Devices',
            subtitle: 'View and manage authorized devices',
            icon: Icons.smartphone_outlined,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onTap: onShowDevices,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          // Security recommendations
          _buildSecurityRecommendations(theme),
        ],
      ),
    );
  }

  Widget _buildSecurityOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20.w,
                color: theme.colorScheme.onPrimaryContainer,
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
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityRecommendations(ThemeData theme) {
    if (biometricEnabled) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 20.w,
              color: Colors.green,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Great! Your account security is optimally configured.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20.w,
                  color: Colors.orange,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Security Recommendations',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '• Enable biometric authentication for enhanced security\n'
              '• Regularly review active sessions\n'
              '• Keep your app updated to the latest version',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }
  }

  Color _getSecurityLevelColor() {
    return biometricEnabled ? Colors.green : Colors.orange;
  }

  String _getSecurityLevel() {
    return biometricEnabled ? 'High Security' : 'Standard';
  }

  String _getSecurityStatusTitle() {
    return biometricEnabled
        ? 'Your account is well protected'
        : 'Consider enabling biometric authentication';
  }

  String _getSecurityStatusDescription() {
    return biometricEnabled
        ? 'All recommended security features are active'
        : 'Enable additional security features to better protect your health data';
  }
}