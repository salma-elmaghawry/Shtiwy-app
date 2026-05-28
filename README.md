# Nawirni: Your Study, Your Way, Powered by AI

**Nawirni** is an innovative AI-powered study companion mobile application designed to revolutionize personalized learning. Whether you're a student looking to improve your grades, a professional developing new skills, or a lifelong learner, Nawirni adapts to your unique learning style and pace.

## About Nawirni

Nawirni combines cutting-edge artificial intelligence with intuitive design to create a personalized study experience tailored to each user. Our mission is to empower learners by providing adaptive content, intelligent recommendations, and interactive study tools that make learning more effective and engaging.

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
└── nawirni_app.dart   # App configuration
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

Nawirni follows the **Clean Architecture** principles with **BLoC** pattern for state management, ensuring:

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

Nawirni supports multiple languages:
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

For support, please open an issue on GitHub or contact us at support@nawirni.com

## Acknowledgments

- Flutter documentation and community
- Supabase for backend infrastructure
- Google Fonts for typography

---

**Nawirni**: Your Study, Your Way, Powered by AI.
