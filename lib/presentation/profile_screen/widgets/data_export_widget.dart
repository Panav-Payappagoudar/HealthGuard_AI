import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class DataExportWidget extends StatelessWidget {
  final VoidCallback onExportData;
  final VoidCallback onDeleteAccount;

  const DataExportWidget({
    super.key,
    required this.onExportData,
    required this.onDeleteAccount,
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
                Icons.download_outlined,
                size: 24.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Data Management',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Export data option
          _buildDataOption(
            title: 'Export My Data',
            subtitle:
                'Download all your personal and health data in a secure format',
            icon: Icons.file_download_outlined,
            iconColor: theme.colorScheme.primary,
            onTap: () => _showExportDialog(context, onExportData),
            theme: theme,
          ),

          SizedBox(height: 12.h),

          // Delete account option
          _buildDataOption(
            title: 'Delete My Account',
            subtitle: 'Permanently remove your account and all associated data',
            icon: Icons.delete_forever_outlined,
            iconColor: theme.colorScheme.error,
            onTap: () => _showDeleteConfirmation(context, onDeleteAccount),
            theme: theme,
            isDestructive: true,
          ),

          SizedBox(height: 16.h),

          // Data rights info
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
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
                      Icons.info_outline,
                      size: 16.w,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Your Data Rights',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'You have complete control over your data. Export includes all personal information, health records, AI conversations, and app settings. All data is encrypted and can only be accessed by you.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDestructive
              ? theme.colorScheme.errorContainer.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isDestructive
              ? Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.2),
                )
              : null,
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
                      color: isDestructive ? theme.colorScheme.error : null,
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context, VoidCallback onExport) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download_outlined),
            SizedBox(width: 8.w),
            Text('Export Your Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your data export will include:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 12.h),
            ..._buildExportItems().map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4.w,
                        height: 4.w,
                        margin: EdgeInsets.only(top: 8.h, right: 8.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                          child: Text(item,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                )),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security_outlined,
                    size: 16.w,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'All data is encrypted and secure',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onExport();
            },
            icon: Icon(Icons.download),
            label: Text('Export Data'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: 8.w),
            Text(
              'Delete Account',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. Deleting your account will permanently remove:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12.h),
            ..._buildDeleteItems().map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.close,
                        size: 16.w,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Consider exporting your data first if you want to keep a copy.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  List<String> _buildExportItems() {
    return [
      'Personal information (name, email, age)',
      'Medical conditions and emergency contacts',
      'Health summary and activity data',
      'AI conversation history',
      'Privacy and security settings',
      'Bookmarked health articles',
      'App preferences and configurations',
    ];
  }

  List<String> _buildDeleteItems() {
    return [
      'All personal and health data',
      'AI conversation history',
      'Bookmarked content',
      'App settings and preferences',
      'Account access credentials',
    ];
  }
}