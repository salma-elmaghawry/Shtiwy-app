import 'package:flutter/material.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/features/booking/screens/booking_screen.dart';
import 'package:shtiwy/features/intro/choose_theme_lang.dart';
import 'package:shtiwy/features/intro/splash_page.dart';
import 'package:shtiwy/features/intro/onboarding_page.dart';
import 'package:shtiwy/features/auth/presentation/screens/login_page.dart';
import 'package:shtiwy/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:shtiwy/features/auth/presentation/screens/otp_screen.dart';
import 'package:shtiwy/features/home/screens/home_screen.dart';
import 'package:shtiwy/features/packages/presentation/screens/packedge_screen.dart';
import 'package:shtiwy/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case Routes.languageSelection:
        return MaterialPageRoute(
          builder: (_) => const LanguageThemeSelectionPage(),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      //main tabs
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.packages:
        return MaterialPageRoute(builder: (_) => PackageScreen());
      case Routes.bookings:
        return MaterialPageRoute(builder: (_) => BookingsScreen());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
