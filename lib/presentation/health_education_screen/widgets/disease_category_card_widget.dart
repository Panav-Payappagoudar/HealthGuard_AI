import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class DiseaseCategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> disease;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final VoidCallback onTap;

  const DiseaseCategoryCardWidget({
    super.key,
    required this.disease,
    required this.isBookmarked,
    required this.onBookmarkTap,
    required this.onTap,
  });

  Color _getSeverityColor(String severity, ColorScheme colorScheme) {
    switch (severity.toLowerCase()) {
      case 'high':
        return colorScheme.error;
      case 'medium':
        return Colors.orange;
      case 'low':
        return colorScheme.tertiary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disease['name'] ?? '',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getSeverityColor(
                                  disease['severity'] ?? 'low',
                                  colorScheme,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${disease['severity']?.toUpperCase() ?? ''} RISK',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getSeverityColor(
                                    disease['severity'] ?? 'low',
                                    colorScheme,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                disease['prevalence'] ?? '',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onBookmarkTap,
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                disease['description'] ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 16.w,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Symptoms: ${(disease['symptoms'] as List?)?.take(3).join(', ') ?? 'N/A'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}