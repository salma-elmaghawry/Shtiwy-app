# Shtiwy (nawirni)

A Flutter application (client) — local modifications for onboarding, language & theme selection, and developer flow.

**Quick Start**

- **Install dependencies:**

  ```bash
  flutter pub get
  ```

- **Run the app (debug):**

  ```bash
  flutter run
  ```

- **Static analysis:**

  ```bash
  flutter analyze
  ```

**Dev flow (what you'll see in debug builds)**

- The app is configured to show the selection flow in debug mode to make testing easier:
  - Splash → Language & Theme selection → Onboarding → Login/Home
- The production behaviour (release mode) uses persisted preferences (see `SharedPreferences` keys below).

**What I added / changed (high level)**

- Updated localization keys in `assets/translations/en.json` and `assets/translations/ar.json` (app name, onboarding strings).
- Added a 3-page onboarding screen (`lib/features/intro/onboarding_page.dart`) and route registration.
- Implemented `LanguageThemeSelectionPage` (`lib/features/intro/choose_theme_lang.dart`) allowing the user to pick language and theme.
- Persisted selections in `SharedPreferences` and wired them to `EasyLocalization` and `ThemeCubit`.
- Added `SettingsScreen` with a toggle to open the selection screen and to optionally show the selector every startup.
- Normalized package import paths to `package:shtiwy` and renamed app entry to `shtiwy_app.dart`.
- Added a configurable `borderRadius` and `icon` variant to `CustomButton` (`lib/core/widgets/custom_button.dart`).

**Important files & routes**

- `lib/main.dart` — app bootstrap, initializes `EasyLocalization`, DI (`getIt`) and `ThemeCubit`/`AuthCubit`.
- `lib/shtiwy_app.dart` — `MaterialApp` configuration (`initialRoute`, theme, localization delegates).
- `lib/core/routes/routes.dart` — route constants (e.g. `Routes.splash`, `Routes.languageSelection`, `Routes.onboarding`).
- `lib/core/routes/app_router.dart` — route -> page mapping.
- `lib/features/intro/choose_theme_lang.dart` — language & theme selection screen (saves `app_locale` and persists theme).
- `lib/features/intro/onboarding_page.dart` — onboarding PageView; sets `onboarding_seen` when skipped/finished.
- `lib/features/settings/presentation/screens/settings_screen.dart` — simple Settings screen with a toggle to show selection at startup and a button to edit language/theme.
- `lib/core/widgets/custom_button.dart` — custom button with `borderRadius` and `icon` variant (use `ButtonVariant.icon`).

**SharedPreferences keys**

- `app_locale` — saved language code (`"en"` or `"ar"`).
- `app_theme_mode` — saved theme mode (stringified `ThemeMode`).
- `onboarding_seen` — boolean, set true when onboarding is finished or skipped.
- `choose_every_time` — boolean, from Settings screen; when true you may choose to show selection every app start (not yet forced by splash in release).

**Developer notes**

- In debug builds the splash forces the language/theme selection screen to appear first. This is controlled by `kDebugMode` in `SplashPage`.
- The selection screen applies locale via `context.setLocale(...)` and applies theme via `ThemeCubit`. The theme changes are persisted by `ThemeCubit`.
- To test the full first-launch flow quickly: run the app in the simulator, then clear app data (or run with a fresh simulator), the debug flow will present the selection → onboarding → login sequence.

**Lint / Analyzer**

- I ran `flutter analyze` while implementing features. Remaining messages are informational (unused imports in helper files and a couple of deprecation/info warnings). They don't block running the app.

**Next suggested steps**

- Localize the Settings page labels into `assets/translations/en.json` and `assets/translations/ar.json`.
- Optionally wire `SettingsScreen` into the `AppRouter` and add a navbar entry in `HomeScreen`.
- Remove or tidy unused imports flagged by the analyzer.

If you want, I can do any of these next steps and also run and verify the flow on an emulator. Which one should I do next?
# Shitawy

**Shitawy**

اداره رحلات الحج والعمره وكده

### Key Features

- **🤖 AI-Powered Learning**: Personalized study recommendations based on your learning patterns
- **📚 Adaptive Content**: Dynamic course materials that adjust to your knowledge level
- **🎯 Smart Tracking**: Monitor your progress with detailed analytics and insights
- **💡 Interactive Tools**: Engage with quizzes, flashcards, and collaborative learning
- **🌍 Multi-language Support**: Learn in your preferred language (Arabic & English)
- **🎨 Dark Mode**: Eye-friendly interface with theme customization
- **📱 Offline Access**: Download content and study anywhere, anytime

## Getting Started

### Prerequisites

- Flutter SDK (version 3.10.3 or higher)
- Dart SDK
- iOS: Xcode
- Android: Android Studio

### Installation

1. Clone the repository:
```bash
git clone https://github.com/salma-elmaghawry/nawirni.git
cd nawirni
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── theme/          # App theming and styling
│   ├── utils/          # Utility functions and constants
│   ├── widgets/        # Reusable widgets
│   └── error_handling/ # Error handling utilities
├── features/           # Feature-specific modules
├── main.dart          # App entry point
└── shitawy_app.dart   # App configuration
```

## Technology Stack

- **Framework**: Flutter
- **State Management**: Flutter BLoC
- **Backend**: Supabase
- **Database**: Supabase PostgreSQL
- **Authentication**: Supabase Auth
- **Localization**: Easy Localization
- **UI Components**: Material Design 3
- **Fonts**: Google Fonts
- **Routing**: Auto Route
- **Dependency Injection**: Get It
- **Utilities**: Dartz, Equatable

## Architecture


Shitawy follows the **Clean Architecture** principles with **BLoC** pattern for state management, ensuring:

- Separation of concerns
- Testability
- Maintainability
- Scalability

## Supported Platforms

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## Localization

Shitawy supports multiple languages:
- 🇬🇧 English
- 🇸🇦 العربية (Arabic)

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue on GitHub or contact us at support@shitawy.com

## Acknowledgments

- Flutter documentation and community
- Supabase for backend infrastructure
- Google Fonts for typography

---

**Shitawy**: اداره رحلات الحج والعمره وكده
