import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Model class for user profile data
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String age;
  final String phoneNumber;
  final String address;
  final String emergencyContact;
  final String emergencyContactPhone;
  final List<String> medicalConditions;
  final List<String> allergies;
  final List<String> medications;
  final String bloodType;
  final String profileImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.phoneNumber = '',
    this.address = '',
    this.emergencyContact = '',
    this.emergencyContactPhone = '',
    this.medicalConditions = const [],
    this.allergies = const [],
    this.medications = const [],
    this.bloodType = '',
    this.profileImagePath = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'phoneNumber': phoneNumber,
      'address': address,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'medicalConditions': medicalConditions,
      'allergies': allergies,
      'medications': medications,
      'bloodType': bloodType,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] ?? '',
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      bloodType: json['bloodType'] ?? '',
      profileImagePath: json['profileImagePath'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? age,
    String? phoneNumber,
    String? address,
    String? emergencyContact,
    String? emergencyContactPhone,
    List<String>? medicalConditions,
    List<String>? allergies,
    List<String>? medications,
    String? bloodType,
    String? profileImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      bloodType: bloodType ?? this.bloodType,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

/// Model class for user preferences
class UserPreferences {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final bool locationServicesEnabled;
  final bool biometricAuthEnabled;
  final bool dataBackupEnabled;
  final int reminderFrequency; // in hours
  final List<String> preferredHealthTopics;

  UserPreferences({
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.language = 'en',
    this.locationServicesEnabled = true,
    this.biometricAuthEnabled = false,
    this.dataBackupEnabled = true,
    this.reminderFrequency = 24,
    this.preferredHealthTopics = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'language': language,
      'locationServicesEnabled': locationServicesEnabled,
      'biometricAuthEnabled': biometricAuthEnabled,
      'dataBackupEnabled': dataBackupEnabled,
      'reminderFrequency': reminderFrequency,
      'preferredHealthTopics': preferredHealthTopics,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      language: json['language'] ?? 'en',
      locationServicesEnabled: json['locationServicesEnabled'] ?? true,
      biometricAuthEnabled: json['biometricAuthEnabled'] ?? false,
      dataBackupEnabled: json['dataBackupEnabled'] ?? true,
      reminderFrequency: json['reminderFrequency'] ?? 24,
      preferredHealthTopics: List<String>.from(json['preferredHealthTopics'] ?? []),
    );
  }

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
    bool? locationServicesEnabled,
    bool? biometricAuthEnabled,
    bool? dataBackupEnabled,
    int? reminderFrequency,
    List<String>? preferredHealthTopics,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      locationServicesEnabled: locationServicesEnabled ?? this.locationServicesEnabled,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
      dataBackupEnabled: dataBackupEnabled ?? this.dataBackupEnabled,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      preferredHealthTopics: preferredHealthTopics ?? this.preferredHealthTopics,
    );
  }
}

/// Service class for managing user profile data and preferences
class ProfileService {
  static const String _profileKey = 'user_profile';
  static const String _preferencesKey = 'user_preferences';
  static const String _healthDataKey = 'user_health_data';
  
  static ProfileService? _instance;
  static ProfileService get instance => _instance ??= ProfileService._();
  ProfileService._();
  
  // Add unnamed constructor for compatibility
  ProfileService();

  /// Get user profile from local storage
  Future<UserProfile?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final Map<String, dynamic> profileMap = jsonDecode(profileJson);
        return UserProfile.fromJson(profileMap);
      }
      return null;
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      return null;
    }
  }

  /// Save user profile to local storage
  Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
      final profileJson = jsonEncode(updatedProfile.toJson());
      
      await prefs.setString(_profileKey, profileJson);
      return true;
    } catch (e) {
      debugPrint('Error saving user profile: $e');
      return false;
    }
  }

  /// Update specific profile fields
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? age,
    String? phoneNumber,
    String? address,
    String? emergencyContact,
    String? emergencyContactPhone,
    List<String>? medicalConditions,
    List<String>? allergies,
    List<String>? medications,
    String? bloodType,
    String? profileImagePath,
  }) async {
    try {
      final currentProfile = await getUserProfile();
      if (currentProfile == null) {
        // Create new profile if none exists
        final newProfile = UserProfile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name ?? '',
          email: email ?? '',
          age: age ?? '',
          phoneNumber: phoneNumber ?? '',
          address: address ?? '',
          emergencyContact: emergencyContact ?? '',
          emergencyContactPhone: emergencyContactPhone ?? '',
          medicalConditions: medicalConditions ?? [],
          allergies: allergies ?? [],
          medications: medications ?? [],
          bloodType: bloodType ?? '',
          profileImagePath: profileImagePath ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return await saveUserProfile(newProfile);
      }

      final updatedProfile = currentProfile.copyWith(
        name: name,
        email: email,
        age: age,
        phoneNumber: phoneNumber,
        address: address,
        emergencyContact: emergencyContact,
        emergencyContactPhone: emergencyContactPhone,
        medicalConditions: medicalConditions,
        allergies: allergies,
        medications: medications,
        bloodType: bloodType,
        profileImagePath: profileImagePath,
        updatedAt: DateTime.now(),
      );

      return await saveUserProfile(updatedProfile);
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  /// Get user preferences
  Future<UserPreferences> getUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString(_preferencesKey);
      
      if (preferencesJson != null) {
        final Map<String, dynamic> preferencesMap = jsonDecode(preferencesJson);
        return UserPreferences.fromJson(preferencesMap);
      }
      return UserPreferences(); // Return default preferences
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
      return UserPreferences();
    }
  }

  /// Save user preferences
  Future<bool> saveUserPreferences(UserPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = jsonEncode(preferences.toJson());
      
      await prefs.setString(_preferencesKey, preferencesJson);
      return true;
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
      return false;
    }
  }

  /// Update specific preference fields
  Future<bool> updatePreferences({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
    bool? locationServicesEnabled,
    bool? biometricAuthEnabled,
    bool? dataBackupEnabled,
    int? reminderFrequency,
    List<String>? preferredHealthTopics,
  }) async {
    try {
      final currentPreferences = await getUserPreferences();
      final updatedPreferences = currentPreferences.copyWith(
        notificationsEnabled: notificationsEnabled,
        darkModeEnabled: darkModeEnabled,
        language: language,
        locationServicesEnabled: locationServicesEnabled,
        biometricAuthEnabled: biometricAuthEnabled,
        dataBackupEnabled: dataBackupEnabled,
        reminderFrequency: reminderFrequency,
        preferredHealthTopics: preferredHealthTopics,
      );

      return await saveUserPreferences(updatedPreferences);
    } catch (e) {
      debugPrint('Error updating preferences: $e');
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile(UserProfile profile) async {
    return await saveUserProfile(profile);
  }

  /// Update user preferences
  Future<bool> updateUserPreferences(UserPreferences preferences) async {
    return await saveUserPreferences(preferences);
  }

  /// Clear all profile data
  Future<bool> clearProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      await prefs.remove(_preferencesKey);
      await prefs.remove(_healthDataKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing profile data: $e');
      return false;
    }
  }

  /// Export profile data as JSON
  Future<Map<String, dynamic>?> exportProfileData() async {
    try {
      final profile = await getUserProfile();
      final preferences = await getUserPreferences();
      
      if (profile == null) return null;
      
      return {
        'profile': profile.toJson(),
        'preferences': preferences.toJson(),
        'exportedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error exporting profile data: $e');
      return null;
    }
  }

  /// Import profile data from JSON
  Future<bool> importProfileData(Map<String, dynamic> data) async {
    try {
      if (data.containsKey('profile')) {
        final profile = UserProfile.fromJson(data['profile']);
        await saveUserProfile(profile);
      }
      
      if (data.containsKey('preferences')) {
        final preferences = UserPreferences.fromJson(data['preferences']);
        await saveUserPreferences(preferences);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error importing profile data: $e');
      return false;
    }
  }

  /// Validate profile data
  bool validateProfile(UserProfile profile) {
    if (profile.name.isEmpty) return false;
    if (profile.email.isNotEmpty && !_isValidEmail(profile.email)) return false;
    if (profile.age.isNotEmpty && int.tryParse(profile.age) == null) return false;
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}