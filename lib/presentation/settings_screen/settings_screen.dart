import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/about_section_widget.dart';
import './widgets/ai_backend_selector_widget.dart';
import './widgets/cache_management_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_switch_tile_widget.dart';
import './widgets/settings_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentIndex = 4; // Settings tab index

  // Settings state variables
  bool _healthAlertsEnabled = true;
  bool _newsUpdatesEnabled = true;
  bool _emergencyNotificationsEnabled = true;
  bool _locationServicesEnabled = true;
  bool _hospitalFinderEnabled = true;
  bool _demoModeEnabled = false;
  String _selectedAiBackend = 'openai';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _healthAlertsEnabled = prefs.getBool('health_alerts') ?? true;
      _newsUpdatesEnabled = prefs.getBool('news_updates') ?? true;
      _emergencyNotificationsEnabled =
          prefs.getBool('emergency_notifications') ?? true;
      _locationServicesEnabled = prefs.getBool('location_services') ?? true;
      _hospitalFinderEnabled = prefs.getBool('hospital_finder') ?? true;
      _demoModeEnabled = prefs.getBool('demo_mode') ?? false;
      _selectedAiBackend = prefs.getString('ai_backend') ?? 'openai';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_alerts', _healthAlertsEnabled);
    await prefs.setBool('news_updates', _newsUpdatesEnabled);
    await prefs.setBool(
        'emergency_notifications', _emergencyNotificationsEnabled);
    await prefs.setBool('location_services', _locationServicesEnabled);
    await prefs.setBool('hospital_finder', _hospitalFinderEnabled);
    await prefs.setBool('demo_mode', _demoModeEnabled);
    await prefs.setString('ai_backend', _selectedAiBackend);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Account Settings Section
            SettingsSectionWidget(
              title: 'ACCOUNT',
              children: [
                SettingsTileWidget(
                  title: 'Profile Settings',
                  subtitle: 'Manage your personal information',
                  iconName: 'person',
                  onTap: () => _showComingSoonDialog('Profile Settings'),
                ),
                SettingsTileWidget(
                  title: 'Privacy & Security',
                  subtitle: 'Control your data and privacy',
                  iconName: 'security',
                  onTap: () => _showComingSoonDialog('Privacy & Security'),
                ),
              ],
            ),

            // AI Backend Selection Section
            SettingsSectionWidget(
              title: 'AI CONFIGURATION',
              children: [
                AiBackendSelectorWidget(
                  selectedBackend: _selectedAiBackend,
                  onBackendChanged: (backend) {
                    setState(() {
                      _selectedAiBackend = backend;
                    });
                    _saveSettings();
                    _showBackendChangedSnackBar(backend);
                  },
                ),
              ],
            ),

            // Notification Preferences Section
            SettingsSectionWidget(
              title: 'NOTIFICATIONS',
              children: [
                SettingsSwitchTileWidget(
                  title: 'Health Alerts',
                  subtitle: 'Get notified about health zone changes',
                  iconName: 'notifications_active',
                  value: _healthAlertsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _healthAlertsEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
                SettingsSwitchTileWidget(
                  title: 'News Updates',
                  subtitle: 'Receive latest health news',
                  iconName: 'article',
                  value: _newsUpdatesEnabled,
                  onChanged: (value) {
                    setState(() {
                      _newsUpdatesEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
                SettingsSwitchTileWidget(
                  title: 'Emergency Notifications',
                  subtitle: 'Critical health emergency alerts',
                  iconName: 'emergency',
                  iconColor: theme.colorScheme.error,
                  value: _emergencyNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _emergencyNotificationsEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),

            // Location Services Section
            SettingsSectionWidget(
              title: 'LOCATION SERVICES',
              children: [
                SettingsSwitchTileWidget(
                  title: 'Health Zone Monitoring',
                  subtitle: 'Track health zones in your area',
                  iconName: 'location_on',
                  value: _locationServicesEnabled,
                  onChanged: (value) {
                    setState(() {
                      _locationServicesEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
                SettingsSwitchTileWidget(
                  title: 'Hospital Finder',
                  subtitle: 'Find nearby hospitals and clinics',
                  iconName: 'local_hospital',
                  value: _hospitalFinderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _hospitalFinderEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),

            // Data Management Section
            SettingsSectionWidget(
              title: 'DATA MANAGEMENT',
              children: [
                const CacheManagementWidget(),
                SettingsTileWidget(
                  title: 'Offline Content',
                  subtitle: 'Manage downloaded maps and articles',
                  iconName: 'offline_pin',
                  onTap: () => _showComingSoonDialog('Offline Content'),
                ),
                SettingsTileWidget(
                  title: 'Export Health Data',
                  subtitle: 'Download your health reports',
                  iconName: 'download',
                  onTap: () => _showComingSoonDialog('Export Health Data'),
                ),
              ],
            ),

            // Demo Mode Section
            SettingsSectionWidget(
              title: 'DEMO MODE',
              children: [
                SettingsSwitchTileWidget(
                  title: 'Demo Mode',
                  subtitle: 'Use fake data for offline judging',
                  iconName: 'science',
                  iconColor: theme.colorScheme.tertiary,
                  value: _demoModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _demoModeEnabled = value;
                    });
                    _saveSettings();
                    _showDemoModeSnackBar(value);
                  },
                ),
              ],
            ),

            // About Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                'ABOUT',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const AboutSectionWidget(),

            SizedBox(height: 10.h), // Bottom padding for navigation bar
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('This feature is coming soon in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackendChangedSnackBar(String backend) {
    final backendNames = {
      'openai': 'OpenAI GPT',
      'ollama': 'Ollama Local',
      'local': 'Local LLM',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI Backend changed to ${backendNames[backend]}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showDemoModeSnackBar(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? 'Demo mode enabled - Using fake data'
              : 'Demo mode disabled - Using real data',
        ),
        backgroundColor: enabled
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
