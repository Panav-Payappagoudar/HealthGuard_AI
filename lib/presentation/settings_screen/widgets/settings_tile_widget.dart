import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showDisclosure;

  const SettingsTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconName,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.showDisclosure = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: (iconColor ?? theme.colorScheme.primary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: iconColor ?? theme.colorScheme.primary,
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
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: 2.w),
                trailing!,
              ] else if (showDisclosure && onTap != null) ...[
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
