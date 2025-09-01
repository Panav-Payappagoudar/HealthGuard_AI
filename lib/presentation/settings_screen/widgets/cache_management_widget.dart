import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CacheManagementWidget extends StatefulWidget {
  const CacheManagementWidget({super.key});

  @override
  State<CacheManagementWidget> createState() => _CacheManagementWidgetState();
}

class _CacheManagementWidgetState extends State<CacheManagementWidget> {
  double _cacheSize = 45.7; // MB
  bool _isClearing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'storage',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cache Management',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Current cache size: ${_cacheSize.toStringAsFixed(1)} MB',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Cache breakdown
          _buildCacheItem(
            context,
            'Map Tiles',
            '${(_cacheSize * 0.4).toStringAsFixed(1)} MB',
            'map',
          ),
          _buildCacheItem(
            context,
            'News Articles',
            '${(_cacheSize * 0.3).toStringAsFixed(1)} MB',
            'article',
          ),
          _buildCacheItem(
            context,
            'Health Data',
            '${(_cacheSize * 0.2).toStringAsFixed(1)} MB',
            'health_and_safety',
          ),
          _buildCacheItem(
            context,
            'Images',
            '${(_cacheSize * 0.1).toStringAsFixed(1)} MB',
            'image',
          ),

          SizedBox(height: 3.h),

          // Clear cache button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isClearing ? null : _clearCache,
              icon: _isClearing
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'delete_sweep',
                      color: theme.colorScheme.onPrimary,
                      size: 18,
                    ),
              label: Text(_isClearing ? 'Clearing...' : 'Clear All Cache'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheItem(
    BuildContext context,
    String name,
    String size,
    String iconName,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            size,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache() async {
    setState(() {
      _isClearing = true;
    });

    // Simulate cache clearing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isClearing = false;
      _cacheSize = 0.0;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cache cleared successfully'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }
  }
}
