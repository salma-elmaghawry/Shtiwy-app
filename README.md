<p align="center">
  <img src="assets/images/logo_s.png" width="120" alt="Shtiwy Logo"/>
</p>

<h1 align="center">Shtiwy — Smart Travel & Tourism Platform</h1>

<p align="center">
  A production-grade, multi-platform Flutter application for travel and tourism services — featuring Hajj, Umrah, and external tourism trip booking. Built with <strong>Clean Architecture</strong>, <strong>BLoC state management</strong>, and <strong>Supabase</strong> as a full backend-as-a-service.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/State_Management-BLoC-blueviolet" alt="BLoC"/>
  <img src="https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white" alt="Supabase"/>
  <img src="https://img.shields.io/badge/Architecture-Clean_Architecture-orange" alt="Clean Architecture"/>
  <img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-brightgreen" alt="Multi-platform"/>
</p>

---

https://github.com/user-attachments/assets/7e339e87-6490-47ef-a781-6ee170ea172c

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🔐 **Full Authentication Flow** | Email/password sign-up & sign-in, OTP email verification, resend OTP, session persistence, and sign-out — all via Supabase Auth |
| 🕌 **Hajj & Umrah Booking** | Browse Hajj packages (1447 AH), Umrah trips, and external tourism offers with detailed trip info (nights, stars, discounts) |
| 📦 **Travel Packages** | Explore curated travel packages with rich details, pricing, and one-tap booking |
| 🌙 **Dark / Light Theme** | Full Material Design 3 theming with runtime dark-mode toggle, persisted via SharedPreferences through a dedicated `ThemeCubit` |
| 🌍 **Multi-Language (i18n)** | Arabic 🇸🇦 & English 🇬🇧 with `easy_localization`, locale persistence, and fully localized error messages |
| 📍 **Geolocation & Maps** | Google Maps integration with Geolocator for location-based features and location selection during sign-up |
| 🎨 **Polished Onboarding** | Multi-page animated onboarding with custom illustrations, guiding users through the app's value proposition |
| 📱 **Responsive UI** | Pixel-perfect adaptive layouts using `flutter_screenutil` across phones, tablets, and desktop |
| 🛡️ **Granular Error Handling** | Typed failure hierarchy (`Failure` → `InvalidCredentialsFailure`, `NetworkFailure`, etc.) with centralized `ErrorMapper` translating Supabase exceptions to user-friendly, localized messages |
| 🔄 **Custom Animations** | Rich animation system with reusable animated widgets and page transitions via `flutter_animate` |

---

## 🏗️ Architecture & Design Patterns

The project follows **Clean Architecture** layered with **feature-first modular organization**, ensuring high cohesion within features and loose coupling across the app.

```
lib/
├── core/                          # Shared infrastructure
│   ├── animations/                # Reusable animated widgets & page transitions
│   ├── bloc/                      # BaseState with Status enum (initial/loading/success/failure)
│   ├── error_handling/            # Failure hierarchy + ErrorMapper (Supabase → typed failures)
│   ├── helpers/                   # Validators, extensions, formatters, spacing utilities
│   ├── injection/                 # GetIt service locator — DI container
│   ├── network/                   # LoggingHttpClient — request/response interceptor
│   ├── resources/                 # App-wide constants and assets references
│   ├── routes/                    # Centralized named routing (AppRouter + Routes)
│   ├── services/                  # SupabaseService, LocationService
│   ├── shared_pages/              # Cross-feature pages (splash, errors, etc.)
│   ├── theme/                     # AppTheme (light/dark), AppColors, ThemeCubit
│   ├── utils/                     # Text styles, constants, utilities
│   └── widgets/                   # Reusable UI: CustomButton, CustomTextField,
│                                  #   PremiumOTPInput, AnimatedLogo, LoadingOverlay
│
├── features/                      # Feature modules (Clean Architecture per feature)
│   ├── auth/                      # Authentication
│   │   ├── data/                  #   ├── datasource/ (AuthRemoteDataSource interface + impl)
│   │   │   └── models/            #   └── models/ (data transfer objects)
│   │   ├── domain/                #   └── entities/ (User entity)
│   │   ├── repository/            #   ├── AuthRepository (abstract contract)
│   │   │                          #   └── AuthRepositoryImpl (Dartz Either<Failure, T>)
│   │   └── presentation/          #   ├── cubit/ (AuthCubit + AuthStates)
│   │                              #   ├── screens/
│   │                              #   └── widgets/
│   ├── booking/                   # Trip booking flow
│   ├── home/                      # Home dashboard, offers, announcements
│   ├── intro/                     # Splash, onboarding, theme/language chooser
│   ├── packages/                  # Travel packages catalog
│   └── settings/                  # User settings (theme, language, sign-out)
│
├── main.dart                      # Entry point — DI setup, Supabase init, locale loading
└── shtiwy_app.dart                # MaterialApp config, ScreenUtil, BlocBuilder for theme
```

### 🔑 Architectural Highlights

| Pattern | Implementation |
|---|---|
| **Clean Architecture** | Strict separation into `data` → `domain` → `presentation` layers per feature |
| **BLoC / Cubit** | Cubits for state management with `Equatable` states and `copyWith` for immutability |
| **Repository Pattern** | Abstract repository contracts with concrete implementations — decouples business logic from data sources |
| **Dependency Injection** | `GetIt` service locator with `registerFactory` (transient) and `registerLazySingleton` (shared instances) |
| **Functional Error Handling** | `Dartz Either<Failure, T>` — no exceptions in business logic; all errors are typed values |
| **Centralized Error Mapping** | `ErrorMapper` translates `AuthException`, `PostgrestException` → domain `Failure` subtypes with localized messages |
| **Base State Abstraction** | Generic `BaseState` with `Status` enum providing `isLoading`, `isSuccess`, `isFailure` getters |
| **Environment Configuration** | `.env` + `flutter_dotenv` for secure API key management |
| **Network Interceptor** | Custom `LoggingHttpClient` wrapping `http.BaseClient` for request/response debugging |

---

## 🛠️ Technology Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.10+ (Dart 3.x) |
| **State Management** | Flutter BLoC / Cubit |
| **Backend & Database** | Supabase (PostgreSQL, Auth, REST API) |
| **Authentication** | Supabase Auth (Email/Password, OTP Verification) |
| **Dependency Injection** | GetIt (Service Locator) |
| **Routing** | Centralized named routing (custom AppRouter) |
| **Functional Programming** | Dartz (`Either`, `Option`) |
| **Localization** | Easy Localization (JSON-based, AR + EN) |
| **Responsive Design** | Flutter ScreenUtil |
| **Theming** | Material Design 3 (Light + Dark, runtime toggle) |
| **Maps & Location** | Google Maps Flutter + Geolocator |
| **Animations** | Flutter Animate + Custom animated widgets |
| **HTTP Client** | http package with custom LoggingHttpClient interceptor |
| **SVG Rendering** | flutter_svg |
| **Local Storage** | SharedPreferences |
| **Equality & Immutability** | Equatable |
| **Environment Config** | flutter_dotenv |
| **Code Generation** | build_runner, auto_route_generator, lean_builder |

---

## 🌐 Supported Platforms

| Platform | Status |
|---|---|
| 📱 iOS | ✅ Supported |
| 🤖 Android | ✅ Supported |
| 🌐 Web | ✅ Supported |
| 🖥️ macOS | ✅ Supported |
| 🪟 Windows | ✅ Supported |

---

## 🌍 Localization

Fully localized with structured JSON translation files:

- 🇬🇧 **English** — `assets/translations/en.json`
- 🇸🇦 **العربية (Arabic)** — `assets/translations/ar.json`

Locale preference is persisted across sessions via SharedPreferences, and all user-facing error messages are localized through the `ErrorMapper` → translation key pipeline.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.3`
- Dart SDK `^3.x`
- A Supabase project (with Auth + PostgreSQL configured)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/shtiwy-app.git
cd shtiwy-app

# Install dependencies
flutter pub get

# Set up environment variables
cp .env.example .env
# Fill in your Supabase URL and Anon Key

# Run the app
flutter run
```

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built with ❤️ using Flutter
</p>
