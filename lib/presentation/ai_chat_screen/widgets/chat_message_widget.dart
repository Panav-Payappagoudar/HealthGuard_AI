import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? model; // Added model parameter
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onGenerateReport;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.model, // Model that generated the response
    this.onCopy,
    this.onShare,
    this.onGenerateReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.h,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'smart_toy',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: !isUser ? _showMessageOptions : null,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 75.w,
                  minWidth: 20.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft: Radius.circular(isUser ? 4.w : 1.w),
                    bottomRight: Radius.circular(isUser ? 1.w : 4.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor,
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUser
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimestamp(timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isUser
                                ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                                : theme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                        ),
                        if (!isUser && model != null) ...[  // Only show model for AI responses
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Text(
                              model!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'person',
                  color: theme.colorScheme.onPrimary,
                  size: 4.w,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMessageOptions() {
    if (onCopy != null || onShare != null || onGenerateReport != null) {
      // This would typically show a bottom sheet or popup menu
      // For now, we'll just copy to clipboard as a default action
      onCopy?.call();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
