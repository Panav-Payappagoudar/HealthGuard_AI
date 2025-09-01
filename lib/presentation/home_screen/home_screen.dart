import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/animated_gradient_background.dart';
import './widgets/cta_card_widget.dart';
import './widgets/health_status_summary_widget.dart';
import './widgets/hero_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;

  // Mock data for health alerts and news previews
  final List<Map<String, dynamic>> _healthAlerts = [
    {
      "id": 1,
      "title": "Air Quality Alert",
      "message":
          "Moderate air quality in your area. Consider limiting outdoor activities.",
      "severity": "medium",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "title": "Health Zone Update",
      "message": "Your area has been upgraded to Green zone status.",
      "severity": "low",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];

  final List<Map<String, dynamic>> _newsPreview = [
    {
      "id": 1,
      "headline": "WHO Reports Decline in Seasonal Flu Cases Across India",
      "source": "Health Ministry",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "category": "Public Health",
    },
    {
      "id": 2,
      "headline":
          "New AI-Powered Diagnostic Tools Launched in Major Indian Hospitals",
      "source": "Medical News",
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      "category": "Technology",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeHealthData();
  }

  Future<void> _initializeHealthData() async {
    // Simulate initial data loading
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        // Data loaded
      });
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      // Simulate API calls for refreshing health data
      await Future.delayed(const Duration(seconds: 2));

      // Update health alerts and news
      if (mounted) {
        setState(() {
          // Refresh timestamp and data
        });
      }
    } catch (e) {
      // Handle refresh error silently
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _navigateToLiveMap() {
    Navigator.pushNamed(context, '/live-map-screen');
  }

  void _navigateToAIChat() {
    Navigator.pushNamed(context, '/ai-chat-screen');
  }

  void _navigateToEmergency() {
    Navigator.pushNamed(context, '/emergency-directory-screen');
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    switch (index) {
      case 0:
        // Already on home screen
        break;
      case 1:
        Navigator.pushNamed(context, '/live-map-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/ai-chat-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/emergency-directory-screen');
        break;
      case 4:
        Navigator.pushNamed(context, '/symptom-checker-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'HealthGuard AI',
        showBackButton: false,
        showSettingsAction: true,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              _showNotificationsBottomSheet();
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero section with animated background
                  const HeroSectionWidget(),
                  SizedBox(height: 2.h),

                  // Primary CTA cards
                  CtaCardWidget(
                    title: 'Live Health Map',
                    description:
                        '3D interactive map with real-time health zones and outbreak tracking',
                    iconName: 'map',
                    onTap: _navigateToLiveMap,
                    accentColor: theme.colorScheme.primary,
                  ),

                  CtaCardWidget(
                    title: 'AI Health Assistant',
                    description:
                        'Get instant health advice and symptom analysis from our AI chatbot',
                    iconName: 'chat_bubble',
                    onTap: _navigateToAIChat,
                    accentColor: const Color(0xFF34C759),
                  ),

                  CtaCardWidget(
                    title: 'Emergency Services',
                    description:
                        'Quick access to emergency contacts and nearest hospital locations',
                    iconName: 'emergency',
                    onTap: _navigateToEmergency,
                    accentColor: theme.colorScheme.error,
                  ),

                  SizedBox(height: 2.h),

                  // Health status summary
                  const HealthStatusSummaryWidget(),

                  SizedBox(height: 2.h),

                  // Quick actions section
                  _buildQuickActionsSection(),

                  SizedBox(height: 2.h),

                  // News preview section
                  _buildNewsPreviewSection(),

                  SizedBox(height: 10.h), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Symptom Checker',
                  iconName: 'health_and_safety',
                  onTap: () =>
                      Navigator.pushNamed(context, '/symptom-checker-screen'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionCard(
                  title: 'Find Hospital',
                  iconName: 'local_hospital',
                  onTap: () => Navigator.pushNamed(context, '/live-map-screen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String iconName,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsPreviewSection() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health News',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to full news screen
                },
                child: Text(
                  'View All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _newsPreview.length > 2 ? 2 : _newsPreview.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final news = _newsPreview[index];
              return _buildNewsCard(news);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news["headline"] as String,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text(
                news["source"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                ' • ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                _formatTime(news["timestamp"] as DateTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotificationsBottomSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              Text(
                'Health Alerts',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),

              ListView.separated(
                shrinkWrap: true,
                itemCount: _healthAlerts.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final alert = _healthAlerts[index];
                  return _buildAlertCard(alert);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final theme = Theme.of(context);
    final severity = alert["severity"] as String;
    Color severityColor = theme.colorScheme.tertiary;

    switch (severity) {
      case 'high':
        severityColor = theme.colorScheme.error;
        break;
      case 'medium':
        severityColor = const Color(0xFFFF9500);
        break;
      case 'low':
        severityColor = theme.colorScheme.tertiary;
        break;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: severityColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert["title"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  alert["message"] as String,
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
