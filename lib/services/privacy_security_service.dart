import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

// Security Settings Model
class SecuritySettings {
  final bool biometricEnabled;
  final bool twoFactorEnabled;
  final bool sessionTimeoutEnabled;
  final int sessionTimeoutMinutes;
  final bool deviceTrustEnabled;
  final List<String> trustedDevices;
  final DateTime lastPasswordChange;
  final bool autoLogoutEnabled;
  final bool loginNotificationsEnabled;
  
  SecuritySettings({
    this.biometricEnabled = false,
    this.twoFactorEnabled = false,
    this.sessionTimeoutEnabled = true,
    this.sessionTimeoutMinutes = 30,
    this.deviceTrustEnabled = false,
    this.trustedDevices = const [],
    DateTime? lastPasswordChange,
    this.autoLogoutEnabled = true,
    this.loginNotificationsEnabled = true,
  }) : lastPasswordChange = lastPasswordChange ?? DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'biometricEnabled': biometricEnabled,
    'twoFactorEnabled': twoFactorEnabled,
    'sessionTimeoutEnabled': sessionTimeoutEnabled,
    'sessionTimeoutMinutes': sessionTimeoutMinutes,
    'deviceTrustEnabled': deviceTrustEnabled,
    'trustedDevices': trustedDevices,
    'lastPasswordChange': lastPasswordChange.toIso8601String(),
    'autoLogoutEnabled': autoLogoutEnabled,
    'loginNotificationsEnabled': loginNotificationsEnabled,
  };
  
  factory SecuritySettings.fromJson(Map<String, dynamic> json) => SecuritySettings(
    biometricEnabled: json['biometricEnabled'] ?? false,
    twoFactorEnabled: json['twoFactorEnabled'] ?? false,
    sessionTimeoutEnabled: json['sessionTimeoutEnabled'] ?? true,
    sessionTimeoutMinutes: json['sessionTimeoutMinutes'] ?? 30,
    deviceTrustEnabled: json['deviceTrustEnabled'] ?? false,
    trustedDevices: List<String>.from(json['trustedDevices'] ?? []),
    lastPasswordChange: DateTime.parse(json['lastPasswordChange'] ?? DateTime.now().toIso8601String()),
    autoLogoutEnabled: json['autoLogoutEnabled'] ?? true,
    loginNotificationsEnabled: json['loginNotificationsEnabled'] ?? true,
  );
}

// Privacy Settings Model
class PrivacySettings {
  final bool dataCollectionEnabled;
  final bool analyticsEnabled;
  final bool crashReportingEnabled;
  final bool personalizedAdsEnabled;
  final bool locationTrackingEnabled;
  final bool healthDataSharingEnabled;
  final bool thirdPartyIntegrationsEnabled;
  final List<String> dataRetentionPeriods;
  final bool cookiesEnabled;
  final bool diagnosticsEnabled;
  
  PrivacySettings({
    this.dataCollectionEnabled = true,
    this.analyticsEnabled = false,
    this.crashReportingEnabled = true,
    this.personalizedAdsEnabled = false,
    this.locationTrackingEnabled = false,
    this.healthDataSharingEnabled = false,
    this.thirdPartyIntegrationsEnabled = false,
    this.dataRetentionPeriods = const ['1 year'],
    this.cookiesEnabled = true,
    this.diagnosticsEnabled = true,
  });
  
  Map<String, dynamic> toJson() => {
    'dataCollectionEnabled': dataCollectionEnabled,
    'analyticsEnabled': analyticsEnabled,
    'crashReportingEnabled': crashReportingEnabled,
    'personalizedAdsEnabled': personalizedAdsEnabled,
    'locationTrackingEnabled': locationTrackingEnabled,
    'healthDataSharingEnabled': healthDataSharingEnabled,
    'thirdPartyIntegrationsEnabled': thirdPartyIntegrationsEnabled,
    'dataRetentionPeriods': dataRetentionPeriods,
    'cookiesEnabled': cookiesEnabled,
    'diagnosticsEnabled': diagnosticsEnabled,
  };
  
  factory PrivacySettings.fromJson(Map<String, dynamic> json) => PrivacySettings(
    dataCollectionEnabled: json['dataCollectionEnabled'] ?? true,
    analyticsEnabled: json['analyticsEnabled'] ?? false,
    crashReportingEnabled: json['crashReportingEnabled'] ?? true,
    personalizedAdsEnabled: json['personalizedAdsEnabled'] ?? false,
    locationTrackingEnabled: json['locationTrackingEnabled'] ?? false,
    healthDataSharingEnabled: json['healthDataSharingEnabled'] ?? false,
    thirdPartyIntegrationsEnabled: json['thirdPartyIntegrationsEnabled'] ?? false,
    dataRetentionPeriods: List<String>.from(json['dataRetentionPeriods'] ?? ['1 year']),
    cookiesEnabled: json['cookiesEnabled'] ?? true,
    diagnosticsEnabled: json['diagnosticsEnabled'] ?? true,
  );
}

// Account Security Model
class AccountSecurity {
  final String userId;
  final String passwordHash;
  final List<String> activeSessions;
  final List<Map<String, dynamic>> loginHistory;
  final DateTime lastLoginTime;
  final String lastLoginDevice;
  final String lastLoginLocation;
  final int failedLoginAttempts;
  final DateTime? accountLockedUntil;
  
  AccountSecurity({
    required this.userId,
    required this.passwordHash,
    this.activeSessions = const [],
    this.loginHistory = const [],
    DateTime? lastLoginTime,
    this.lastLoginDevice = '',
    this.lastLoginLocation = '',
    this.failedLoginAttempts = 0,
    this.accountLockedUntil,
  }) : lastLoginTime = lastLoginTime ?? DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'passwordHash': passwordHash,
    'activeSessions': activeSessions,
    'loginHistory': loginHistory,
    'lastLoginTime': lastLoginTime.toIso8601String(),
    'lastLoginDevice': lastLoginDevice,
    'lastLoginLocation': lastLoginLocation,
    'failedLoginAttempts': failedLoginAttempts,
    'accountLockedUntil': accountLockedUntil?.toIso8601String(),
  };
  
  factory AccountSecurity.fromJson(Map<String, dynamic> json) => AccountSecurity(
    userId: json['userId'] ?? '',
    passwordHash: json['passwordHash'] ?? '',
    activeSessions: List<String>.from(json['activeSessions'] ?? []),
    loginHistory: List<Map<String, dynamic>>.from(json['loginHistory'] ?? []),
    lastLoginTime: DateTime.parse(json['lastLoginTime'] ?? DateTime.now().toIso8601String()),
    lastLoginDevice: json['lastLoginDevice'] ?? '',
    lastLoginLocation: json['lastLoginLocation'] ?? '',
    failedLoginAttempts: json['failedLoginAttempts'] ?? 0,
    accountLockedUntil: json['accountLockedUntil'] != null 
        ? DateTime.parse(json['accountLockedUntil']) 
        : null,
  );
}

// Privacy and Security Service
class PrivacySecurityService {
  static const String _securitySettingsKey = 'security_settings';
  static const String _privacySettingsKey = 'privacy_settings';
  static const String _accountSecurityKey = 'account_security';
  static const String _dataExportKey = 'data_export_requests';
  static const String _dataDeletionKey = 'data_deletion_requests';
  
  // Security Settings Management
  Future<SecuritySettings> getSecuritySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_securitySettingsKey);
      
      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
        return SecuritySettings.fromJson(settingsMap);
      }
      
      return SecuritySettings(); // Return default settings
    } catch (e) {
      print('Error loading security settings: $e');
      return SecuritySettings();
    }
  }
  
  Future<bool> updateSecuritySettings(SecuritySettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      return await prefs.setString(_securitySettingsKey, settingsJson);
    } catch (e) {
      print('Error saving security settings: $e');
      return false;
    }
  }
  
  // Privacy Settings Management
  Future<PrivacySettings> getPrivacySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_privacySettingsKey);
      
      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
        return PrivacySettings.fromJson(settingsMap);
      }
      
      return PrivacySettings(); // Return default settings
    } catch (e) {
      print('Error loading privacy settings: $e');
      return PrivacySettings();
    }
  }
  
  Future<bool> updatePrivacySettings(PrivacySettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      return await prefs.setString(_privacySettingsKey, settingsJson);
    } catch (e) {
      print('Error saving privacy settings: $e');
      return false;
    }
  }
  
  // Account Security Management
  Future<AccountSecurity?> getAccountSecurity(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final securityJson = prefs.getString('${_accountSecurityKey}_$userId');
      
      if (securityJson != null) {
        final Map<String, dynamic> securityMap = jsonDecode(securityJson);
        return AccountSecurity.fromJson(securityMap);
      }
      
      return null;
    } catch (e) {
      print('Error loading account security: $e');
      return null;
    }
  }
  
  Future<bool> updateAccountSecurity(AccountSecurity security) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final securityJson = jsonEncode(security.toJson());
      return await prefs.setString('${_accountSecurityKey}_${security.userId}', securityJson);
    } catch (e) {
      print('Error saving account security: $e');
      return false;
    }
  }
  
  // Password Management
  Future<bool> changePassword(String userId, String currentPassword, String newPassword) async {
    try {
      final accountSecurity = await getAccountSecurity(userId);
      if (accountSecurity == null) return false;
      
      // Verify current password
      final currentPasswordHash = _hashPassword(currentPassword);
      if (accountSecurity.passwordHash != currentPasswordHash) {
        return false; // Current password is incorrect
      }
      
      // Update with new password
      final newPasswordHash = _hashPassword(newPassword);
      final updatedSecurity = AccountSecurity(
        userId: userId,
        passwordHash: newPasswordHash,
        activeSessions: accountSecurity.activeSessions,
        loginHistory: accountSecurity.loginHistory,
        lastLoginTime: accountSecurity.lastLoginTime,
        lastLoginDevice: accountSecurity.lastLoginDevice,
        lastLoginLocation: accountSecurity.lastLoginLocation,
        failedLoginAttempts: 0, // Reset failed attempts
        accountLockedUntil: null, // Unlock account
      );
      
      return await updateAccountSecurity(updatedSecurity);
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
  
  // Data Export
  Future<Map<String, dynamic>> exportUserData(String userId) async {
    try {
      final securitySettings = await getSecuritySettings();
      final privacySettings = await getPrivacySettings();
      final accountSecurity = await getAccountSecurity(userId);
      
      final exportData = {
        'export_timestamp': DateTime.now().toIso8601String(),
        'user_id': userId,
        'security_settings': securitySettings.toJson(),
        'privacy_settings': privacySettings.toJson(),
        'account_security': accountSecurity?.toJson(),
        'app_version': '1.0.0',
        'export_format': 'JSON',
      };
      
      // Log export request
      await _logDataExportRequest(userId);
      
      return exportData;
    } catch (e) {
      print('Error exporting user data: $e');
      return {};
    }
  }
  
  // Data Deletion
  Future<bool> requestDataDeletion(String userId, String reason) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Log deletion request
      final deletionRequest = {
        'user_id': userId,
        'request_timestamp': DateTime.now().toIso8601String(),
        'reason': reason,
        'status': 'pending',
      };
      
      final existingRequests = prefs.getStringList(_dataDeletionKey) ?? [];
      existingRequests.add(jsonEncode(deletionRequest));
      await prefs.setStringList(_dataDeletionKey, existingRequests);
      
      return true;
    } catch (e) {
      print('Error requesting data deletion: $e');
      return false;
    }
  }
  
  // Session Management
  Future<bool> terminateSession(String userId, String sessionId) async {
    try {
      final accountSecurity = await getAccountSecurity(userId);
      if (accountSecurity == null) return false;
      
      final updatedSessions = accountSecurity.activeSessions
          .where((session) => session != sessionId)
          .toList();
      
      final updatedSecurity = AccountSecurity(
        userId: userId,
        passwordHash: accountSecurity.passwordHash,
        activeSessions: updatedSessions,
        loginHistory: accountSecurity.loginHistory,
        lastLoginTime: accountSecurity.lastLoginTime,
        lastLoginDevice: accountSecurity.lastLoginDevice,
        lastLoginLocation: accountSecurity.lastLoginLocation,
        failedLoginAttempts: accountSecurity.failedLoginAttempts,
        accountLockedUntil: accountSecurity.accountLockedUntil,
      );
      
      return await updateAccountSecurity(updatedSecurity);
    } catch (e) {
      print('Error terminating session: $e');
      return false;
    }
  }
  
  // Helper Methods
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  Future<void> _logDataExportRequest(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exportRequest = {
        'user_id': userId,
        'export_timestamp': DateTime.now().toIso8601String(),
        'status': 'completed',
      };
      
      final existingRequests = prefs.getStringList(_dataExportKey) ?? [];
      existingRequests.add(jsonEncode(exportRequest));
      await prefs.setStringList(_dataExportKey, existingRequests);
    } catch (e) {
      print('Error logging export request: $e');
    }
  }
  
  // Validation Methods
  bool validatePasswordStrength(String password) {
    // Password must be at least 8 characters long
    if (password.length < 8) return false;
    
    // Must contain at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // Must contain at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    
    // Must contain at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // Must contain at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }
  
  List<String> getPasswordStrengthSuggestions(String password) {
    final suggestions = <String>[];
    
    if (password.length < 8) {
      suggestions.add('Password must be at least 8 characters long');
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      suggestions.add('Add at least one uppercase letter');
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      suggestions.add('Add at least one lowercase letter');
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      suggestions.add('Add at least one number');
    }
    
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      suggestions.add('Add at least one special character (!@#\$%^&*)');
    }
    
    return suggestions;
  }
}