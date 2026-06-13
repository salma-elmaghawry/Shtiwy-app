import 'package:flutter/material.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/features/intro/choose_theme_lang.dart';
import 'package:shtiwy/features/intro/splash_page.dart';
import 'package:shtiwy/features/intro/onboarding_page.dart';
import 'package:shtiwy/features/auth/presentation/screens/login_page.dart';
import 'package:shtiwy/features/auth/presentation/screens/sign_up_page.dart';
import 'package:shtiwy/features/auth/presentation/screens/otp_screen.dart';
import 'package:shtiwy/features/home/home_page.dart';

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
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case Routes.otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
