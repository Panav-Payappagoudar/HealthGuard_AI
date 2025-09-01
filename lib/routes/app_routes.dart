import 'package:flutter/material.dart';
import '../presentation/symptom_checker_screen/symptom_checker_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/ai_chat_screen/ai_chat_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/emergency_directory_screen/emergency_directory_screen.dart';
import '../presentation/live_map_screen/live_map_screen.dart';
import '../presentation/health_education_screen/health_education_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String symptomChecker = '/symptom-checker-screen';
  static const String settings = '/settings-screen';
  static const String aiChat = '/ai-chat-screen';
  static const String home = '/home-screen';
  static const String emergencyDirectory = '/emergency-directory-screen';
  static const String liveMap = '/live-map-screen';
  static const String healthEducation = '/health-education-screen';
  static const String profile = '/profile-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SymptomCheckerScreen(),
    symptomChecker: (context) => const SymptomCheckerScreen(),
    settings: (context) => const SettingsScreen(),
    aiChat: (context) => const AiChatScreen(),
    home: (context) => const HomeScreen(),
    emergencyDirectory: (context) => const EmergencyDirectoryScreen(),
    liveMap: (context) => const LiveMapScreen(),
    healthEducation: (context) => const HealthEducationScreen(),
    profile: (context) => const ProfileScreen(),
    // TODO: Add your other routes here
  };
}
