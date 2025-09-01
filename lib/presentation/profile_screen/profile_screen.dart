import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../services/openai_service.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/data_export_widget.dart';
import './widgets/health_summary_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/privacy_controls_section_widget.dart';
import './widgets/profile_avatar_widget.dart';
import './widgets/security_section_widget.dart';
import 'widgets/data_export_widget.dart';
import 'widgets/health_summary_widget.dart';
import 'widgets/personal_info_section_widget.dart';
import 'widgets/privacy_controls_section_widget.dart';
import 'widgets/profile_avatar_widget.dart';
import 'widgets/security_section_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  // User data
  String _userName = '';
  String _userEmail = '';
  String _userAge = '';
  List<String> _medicalConditions = [];
  List<String> _emergencyContacts = [];

  // Privacy settings
  bool _dataShareEnabled = false;
  bool _locationTrackingEnabled = true;
  bool _healthDataStorageEnabled = true;
  bool _aiInteractionLoggingEnabled = false;
  bool _biometricLockEnabled = true;
  bool _screenshotBlockingEnabled = false;

  // Health summary data
  Map<String, dynamic> _healthSummary = {};

  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;

  // OpenAI client for AI-powered insights
  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);
  bool _isGeneratingHealthInsights = false;
  String? _aiHealthInsights;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _loadUserData();
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
      _userEmail = prefs.getString('user_email') ?? '';
      _userAge = prefs.getString('user_age') ?? '';
      _medicalConditions = prefs.getStringList('medical_conditions') ?? [];
      _emergencyContacts = prefs.getStringList('emergency_contacts') ?? [];

      // Privacy settings
      _dataShareEnabled = prefs.getBool('data_share_enabled') ?? false;
      _locationTrackingEnabled =
          prefs.getBool('location_tracking_enabled') ?? true;
      _healthDataStorageEnabled =
          prefs.getBool('health_data_storage_enabled') ?? true;
      _aiInteractionLoggingEnabled =
          prefs.getBool('ai_interaction_logging_enabled') ?? false;
      _biometricLockEnabled = prefs.getBool('biometric_lock_enabled') ?? true;
      _screenshotBlockingEnabled =
          prefs.getBool('screenshot_blocking_enabled') ?? false;

      // Health summary mock data
      _healthSummary = {
        'lastCheckup': '2 weeks ago',
        'symptomReports': 3,
        'aiConsultations': 7,
        'riskScore': 'Low',
        'completionProgress': 0.75,
      };
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_email', _userEmail);
    await prefs.setString('user_age', _userAge);
    await prefs.setStringList('medical_conditions', _medicalConditions);
    await prefs.setStringList('emergency_contacts', _emergencyContacts);

    // Privacy settings
    await prefs.setBool('data_share_enabled', _dataShareEnabled);
    await prefs.setBool('location_tracking_enabled', _locationTrackingEnabled);
    await prefs.setBool(
        'health_data_storage_enabled', _healthDataStorageEnabled);
    await prefs.setBool(
        'ai_interaction_logging_enabled', _aiInteractionLoggingEnabled);
    await prefs.setBool('biometric_lock_enabled', _biometricLockEnabled);
    await prefs.setBool(
        'screenshot_blocking_enabled', _screenshotBlockingEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(
              Icons.save_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              await _saveUserData();
              Fluttertoast.showToast(msg: 'Profile saved successfully');
            },
          ),
        ],
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: _fadeController,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar Section
                ProfileAvatarWidget(
                  userName: _userName,
                  onAvatarTap: _showAvatarOptions,
                  onBiometricToggle: () => _toggleBiometric(),
                  isBiometricEnabled: _biometricLockEnabled,
                ),

                SizedBox(height: 24.h),

                // Personal Information Section
                PersonalInfoSectionWidget(
                  userName: _userName,
                  userEmail: _userEmail,
                  userAge: _userAge,
                  medicalConditions: _medicalConditions,
                  emergencyContacts: _emergencyContacts,
                  onUserNameChanged: (value) =>
                      setState(() => _userName = value),
                  onUserEmailChanged: (value) =>
                      setState(() => _userEmail = value),
                  onUserAgeChanged: (value) => setState(() => _userAge = value),
                  onMedicalConditionsChanged: (conditions) =>
                      setState(() => _medicalConditions = conditions),
                  onEmergencyContactsChanged: (contacts) =>
                      setState(() => _emergencyContacts = contacts),
                ),

                SizedBox(height: 24.h),

                // Privacy Controls Section
                PrivacyControlsSectionWidget(
                  dataShareEnabled: _dataShareEnabled,
                  locationTrackingEnabled: _locationTrackingEnabled,
                  healthDataStorageEnabled: _healthDataStorageEnabled,
                  aiInteractionLoggingEnabled: _aiInteractionLoggingEnabled,
                  screenshotBlockingEnabled: _screenshotBlockingEnabled,
                  onDataShareChanged: (value) {
                    setState(() => _dataShareEnabled = value);
                    if (value) _showPrivacyConsent();
                  },
                  onLocationTrackingChanged: (value) =>
                      setState(() => _locationTrackingEnabled = value),
                  onHealthDataStorageChanged: (value) =>
                      setState(() => _healthDataStorageEnabled = value),
                  onAiInteractionLoggingChanged: (value) =>
                      setState(() => _aiInteractionLoggingEnabled = value),
                  onScreenshotBlockingChanged: (value) {
                    setState(() => _screenshotBlockingEnabled = value);
                    _toggleScreenshotProtection(value);
                  },
                ),

                SizedBox(height: 24.h),

                // Health Summary Widget
                HealthSummaryWidget(
                  healthSummary: _healthSummary,
                  onGenerateInsights: _generateAIHealthInsights,
                  isGeneratingInsights: _isGeneratingHealthInsights,
                  aiInsights: _aiHealthInsights,
                ),

                SizedBox(height: 24.h),

                // Security Section
                SecuritySectionWidget(
                  biometricEnabled: _biometricLockEnabled,
                  onBiometricToggle: _toggleBiometric,
                  onShowSessions: _showActiveSessions,
                  onShowDevices: _showAuthorizedDevices,
                ),

                SizedBox(height: 24.h),

                // Data Export Widget
                DataExportWidget(
                  onExportData: _exportUserData,
                  onDeleteAccount: _showDeleteAccountDialog,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
                Fluttertoast.showToast(
                    msg: 'Camera feature will be available soon');
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery functionality
                Fluttertoast.showToast(
                    msg: 'Gallery feature will be available soon');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Use Initials'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: 'Using initials as avatar');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBiometric() async {
    try {
      // Simulate biometric authentication
      if (!_biometricLockEnabled) {
        final authenticated = await _authenticateBiometric();
        if (authenticated) {
          setState(() => _biometricLockEnabled = true);
          Fluttertoast.showToast(msg: 'Biometric lock enabled');
        }
      } else {
        setState(() => _biometricLockEnabled = false);
        Fluttertoast.showToast(msg: 'Biometric lock disabled');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Biometric authentication failed');
    }
  }

  Future<bool> _authenticateBiometric() async {
    // Simulate biometric authentication
    await Future.delayed(Duration(seconds: 1));
    return true; // In real implementation, use local_auth package
  }

  void _toggleScreenshotProtection(bool enabled) {
    // In real implementation, this would use platform-specific code
    HapticFeedback.selectionClick();
    Fluttertoast.showToast(
      msg: enabled
          ? 'Screenshot protection enabled'
          : 'Screenshot protection disabled',
    );
  }

  void _showPrivacyConsent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Sharing Consent'),
        content: Text(
          'By enabling data sharing, you consent to sharing anonymized health data for research purposes. This helps improve healthcare for everyone while maintaining your privacy.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _dataShareEnabled = false);
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Accept'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAIHealthInsights() async {
    setState(() => _isGeneratingHealthInsights = true);

    try {
      final prompt = '''
      Based on this user profile, provide brief health insights:
      - Age: ${_userAge.isEmpty ? 'Not specified' : _userAge}
      - Medical conditions: ${_medicalConditions.isEmpty ? 'None reported' : _medicalConditions.join(', ')}
      - Recent activity: ${_healthSummary['symptomReports']} symptom reports, ${_healthSummary['aiConsultations']} AI consultations
      
      Provide personalized health recommendations in under 100 words.
      ''';

      final response = await _openAIClient.createChatCompletion(
        messages: [Message(role: 'user', content: prompt)],
        options: {
          'max_tokens': 100,
          'temperature': 0.3,
        },
      );

      setState(() {
        _aiHealthInsights = response.text;
        _isGeneratingHealthInsights = false;
      });
    } catch (e) {
      setState(() {
        _aiHealthInsights =
            'Unable to generate insights at this time. Please ensure you have a stable internet connection.';
        _isGeneratingHealthInsights = false;
      });
    }
  }

  void _showActiveSessions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Active Sessions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.smartphone),
              title: Text('Current Device'),
              subtitle: Text('Last active: Now'),
              trailing: Chip(
                label: Text('Active'),
                backgroundColor: Colors.green.withValues(alpha: 0.2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.computer),
              title: Text('Web Browser'),
              subtitle: Text('Last active: 2 hours ago'),
              trailing: TextButton(
                onPressed: () {},
                child: Text('End'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAuthorizedDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Authorized Devices'),
        content: Text('Your account is currently authorized on 2 devices.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Manage'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportUserData() async {
    try {
      final userData = {
        'personal_info': {
          'name': _userName,
          'email': _userEmail,
          'age': _userAge,
          'medical_conditions': _medicalConditions,
          'emergency_contacts': _emergencyContacts,
        },
        'privacy_settings': {
          'data_share_enabled': _dataShareEnabled,
          'location_tracking_enabled': _locationTrackingEnabled,
          'health_data_storage_enabled': _healthDataStorageEnabled,
          'ai_interaction_logging_enabled': _aiInteractionLoggingEnabled,
          'biometric_lock_enabled': _biometricLockEnabled,
          'screenshot_blocking_enabled': _screenshotBlockingEnabled,
        },
        'health_summary': _healthSummary,
        'export_date': DateTime.now().toIso8601String(),
      };

      // In web, trigger download
      if (Theme.of(context).platform == TargetPlatform.linux ||
          Theme.of(context).platform == TargetPlatform.macOS ||
          Theme.of(context).platform == TargetPlatform.windows) {
        // For web platform
        final content = '''
Data Export - HealthGuard AI
Generated on: ${DateTime.now()}

Personal Information:
- Name: ${_userName}
- Email: ${_userEmail}
- Age: ${_userAge}
- Medical Conditions: ${_medicalConditions.join(', ')}
- Emergency Contacts: ${_emergencyContacts.join(', ')}

Privacy Settings:
- Data Sharing: ${_dataShareEnabled ? 'Enabled' : 'Disabled'}
- Location Tracking: ${_locationTrackingEnabled ? 'Enabled' : 'Disabled'}
- Health Data Storage: ${_healthDataStorageEnabled ? 'Enabled' : 'Disabled'}
- AI Interaction Logging: ${_aiInteractionLoggingEnabled ? 'Enabled' : 'Disabled'}
- Biometric Lock: ${_biometricLockEnabled ? 'Enabled' : 'Disabled'}
- Screenshot Blocking: ${_screenshotBlockingEnabled ? 'Enabled' : 'Disabled'}

Health Summary:
- Last Checkup: ${_healthSummary['lastCheckup']}
- Symptom Reports: ${_healthSummary['symptomReports']}
- AI Consultations: ${_healthSummary['aiConsultations']}
- Risk Score: ${_healthSummary['riskScore']}
''';

        // For mobile platform, save to file
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'exported_data_${DateTime.now().millisecondsSinceEpoch}', content);
      }

      Fluttertoast.showToast(msg: 'Data exported successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to export data');
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              _performAccountDeletion();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performAccountDeletion() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text('Deleting account...'),
          ],
        ),
      ),
    );

    // Simulate account deletion process
    await Future.delayed(Duration(seconds: 3));

    // Clear all stored data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
    Fluttertoast.showToast(msg: 'Account deleted successfully');

    // Navigate back to login or home
    Navigator.pushNamedAndRemoveUntil(
        context, '/home-screen', (route) => false);
  }
}