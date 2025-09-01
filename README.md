# 🛡️ HealthGuard AI  
*A modern Flutter-powered health companion app with AI chat, live maps, and an emergency hub — designed with Apple-like minimalism and luxury aesthetics.*  

<p align="center">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="60" alt="Flutter"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="60" alt="Dart"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg" width="60" alt="Android"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/apple/apple-original.svg" width="60" alt="iOS"/>
  <img src="https://img.shields.io/badge/License-MIT-black?style=flat-square" alt="License"/>
</p>  

---

## 📖 About  
**HealthGuard AI** was developed for the **OpenAI Open Model Hackathon (2025)**, leveraging **gpt-oss open-weight reasoning models** alongside Gemini and ChatGPT integrations. The app is designed to **redefine digital healthcare accessibility** by combining AI-driven health assistance, real-time hospital maps, emergency contact hubs, and curated health education for Indian users.  

It aligns with hackathon categories including **Best Overall**, **Best Local Agent**, and **For Humanity**, by:  
- Using **gpt-oss** models to enable **offline-capable reasoning and health query handling**, reducing reliance on cloud credits.  
- Providing a **local-first emergency and education system** that works even in low-connectivity regions.  
- Delivering **impactful healthcare accessibility** with a user-friendly, Apple-inspired design.  

---

## ✨ Features  
- 🤖 **AI Health Assistant** – Chat with integrated Gemini & ChatGPT, optimized to minimize credit usage.  
- 🗺️ **Live Map with GPS** – Locate nearby hospitals in real time using OpenStreetMap APIs.  
- 🚑 **Emergency Hub** – One-tap access to India’s essential emergency numbers (Ambulance, Police, Fire, Women’s Helpline, etc.).  
- 📰 **Health News** – Real-time health & medical updates powered by Google News API (India-specific).  
- 📚 **Health Education** – A comprehensive guide to India’s most common diseases, prevention, symptoms, and vaccines.  
- 🎨 **Apple-Inspired UI** – Minimal, immersive, and animated design with full **Light & Dark Mode** support.  
- 🔒 **Profile, Privacy & Security** – Manage personal data, biometric lock (optional), and export/delete local storage.  
- ⚡ **Optimized & Responsive** – Runs smoothly across Android/iOS devices with offline caching for critical info.  

---

## 📋 Prerequisites  
Make sure you have the following installed:  
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.29.2)  
- Dart SDK  
- Android Studio / VS Code with Flutter extensions  
- Android SDK / Xcode (for iOS development)  
- Emulator or physical device for testing  

---

## 🛠️ Installation  

### Install dependencies  
```bash
flutter pub get
```

### Run the app with environment variables  

The app uses `env.json` for secrets and backend config.  

#### 🔹 CLI  
```bash
flutter run --dart-define-from-file=env.json
```

#### 🔹 VS Code  
Open `.vscode/launch.json` and configure:  
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define-from-file",
        "env.json"
      ]
    }
  ]
}
```

#### 🔹 IntelliJ / Android Studio  
1. Go to **Run > Edit Configurations**  
2. Select your Flutter config or create one  
3. Add to **Additional arguments**:  
   ```
   --dart-define-from-file=env.json
   ```

---

## 📁 Project Structure  
```
healthguard_ai/
├── android/              # Android-specific configuration
├── ios/                  # iOS-specific configuration
├── lib/
│   ├── core/             # Core utilities and services
│   │   └── utils/        # Utility classes
│   ├── presentation/     # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/           # Application routing
│   ├── theme/            # Theme configuration
│   ├── widgets/          # Reusable UI components
│   └── main.dart         # Application entry point
├── assets/               # Static assets (images, fonts, etc.)
├── pubspec.yaml          # Project dependencies and configuration
└── README.md             # Project documentation
```

---

## 🧩 Adding Routes  
To add new routes, update:  
`lib/routes/app_routes.dart`  

```dart
import 'package:flutter/material.dart';
import 'package:healthguard_ai/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  };
}
```

---

## 🎨 Theming  
This app supports both **Light and Dark themes** with custom typography, inputs, buttons, dialogs, and cards.  

```dart
ThemeData theme = Theme.of(context);
Color primaryColor = theme.colorScheme.primary;
```  

* 🌞 **Light Mode** – clean, white, minimalist  
* 🌙 **Dark Mode** – elegant, OLED-friendly  

---

## 📱 Responsive Design  
Built with **Sizer** for responsiveness:  

```dart
Container(
  width: 50.w, // 50% of screen width
  height: 20.h, // 20% of screen height
  child: Text('Responsive Container'),
)
```  

Works seamlessly across phones & tablets.  

---

## 📦 Deployment  

### Android  
```bash
flutter build apk --release
```  

### iOS  
```bash
flutter build ios --release
```  

---

## ⚙️ Tech Stack  
- **Framework**: Flutter (3.29.2) + Dart  
- **UI/UX**: Material 3, Cupertino Widgets, Apple-inspired design system  
- **State Management**: Provider / Riverpod (configurable)  
- **Networking**: HTTP, REST APIs  
- **Maps**: OpenStreetMap, Overpass API  
- **AI Integration**: Gemini + ChatGPT + gpt-oss (offline/local agent support)  
- **News**: Google News API (health-specific)  
- **Data Handling**: JSON, Local Storage, Secure Storage  
- **Authentication**: (Pluggable — OAuth2/JWT-ready)  
- **Deployment**: Android APK / iOS IPA builds  

---

## 📜 License  
This project is licensed under the [MIT License](LICENSE).  
