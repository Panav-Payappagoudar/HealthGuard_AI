import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class EmergencyContactCard extends StatefulWidget {
  final Map<String, dynamic> contact;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const EmergencyContactCard({
    super.key,
    required this.contact,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<EmergencyContactCard> createState() => _EmergencyContactCardState();
}

class _EmergencyContactCardState extends State<EmergencyContactCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  void _addToContacts() {
    // This would typically integrate with device contacts
    // For now, we'll show a confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.contact["name"]} added to contacts'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _shareContact() {
    final String shareText =
        '${widget.contact["name"]}: ${widget.contact["primaryNumber"]}';
    // This would typically use the share plugin
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact details copied to clipboard'),
      ),
    );
  }

  Color _getIconColor() {
    final String category = widget.contact["category"] as String;
    switch (category.toLowerCase()) {
      case 'medical':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'emergency':
        return AppTheme.lightTheme.colorScheme.error;
      case 'safety':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'support':
        return const Color(0xFFFF9500);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: _getIconColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: widget.contact["icon"] as String,
                                color: _getIconColor(),
                                size: 6.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.contact["name"] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  widget.contact["primaryNumber"] as String,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: _getIconColor(),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onFavoriteToggle,
                            icon: CustomIconWidget(
                              iconName:
                                  widget.isFavorite ? 'star' : 'star_border',
                              color: widget.isFavorite
                                  ? const Color(0xFFFF9500)
                                  : theme.colorScheme.onSurfaceVariant,
                              size: 5.w,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _makePhoneCall(
                              widget.contact["primaryNumber"] as String,
                            ),
                            icon: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: _getIconColor(),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'phone',
                                color: Colors.white,
                                size: 4.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.contact["description"] != null) ...[
                        SizedBox(height: 1.h),
                        Text(
                          widget.contact["description"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: _buildExpandedContent(theme),
                        crossFadeState: _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandedContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        if (widget.contact["secondaryNumber"] != null) ...[
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone_outlined',
                color: theme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Secondary: ${widget.contact["secondaryNumber"]}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
        ],
        if (widget.contact["availability"] != null) ...[
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: theme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                widget.contact["availability"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              theme: theme,
              icon: 'message',
              label: 'SMS',
              onTap: () => _sendSMS(widget.contact["primaryNumber"] as String),
            ),
            _buildActionButton(
              theme: theme,
              icon: 'person_add',
              label: 'Add Contact',
              onTap: _addToContacts,
            ),
            _buildActionButton(
              theme: theme,
              icon: 'share',
              label: 'Share',
              onTap: _shareContact,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required ThemeData theme,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
