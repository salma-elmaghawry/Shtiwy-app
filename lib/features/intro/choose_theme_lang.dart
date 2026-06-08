import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtiwy/core/animations/app_animations.dart';
import 'package:shtiwy/core/helpers/spacing.dart';
import 'package:shtiwy/core/injection/injection_container.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/app_segmented_toggle.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/theme/controller/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:shtiwy/core/widgets/custom_button.dart';

// NOTE: this file intentionally uses BuildContext after awaiting some futures
// because navigation and locale changes happen after persistence operations.
// The lints for `use_build_context_synchronously` are informational here.
// ignore_for_file: use_build_context_synchronously

class LanguageThemeSelectionPage extends StatefulWidget {
  const LanguageThemeSelectionPage({super.key});

  @override
  State<LanguageThemeSelectionPage> createState() =>
      _LanguageThemeSelectionPageState();
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    return AppSegmentedToggle<String>(
      selectedValue: context.locale.languageCode,
      minSegmentWidth: 90,
      items: const [
        AppSegmentedToggleItem(value: 'en', label: 'English'),
        AppSegmentedToggleItem(value: 'ar', label: 'العربية'),
      ],
      onChanged: (languageCode) {
        context.setLocale(Locale(languageCode));
      },
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return AppSegmentedToggle<ThemeMode>(
          selectedValue: _effectiveThemeMode(state.themeMode),
          minSegmentWidth: 90,
          items: [
            AppSegmentedToggleItem(
              value: ThemeMode.light,
              label: 'preferences.theme_light'.tr(),
              icon: Icons.light_mode_outlined,
            ),
            AppSegmentedToggleItem(
              value: ThemeMode.dark,
              label: 'preferences.theme_dark'.tr(),
              icon: Icons.dark_mode_outlined,
            ),
          ],
          onChanged: (themeMode) {
            context.read<ThemeCubit>().setThemeMode(themeMode);
          },
        );
      },
    );
  }
}

ThemeMode _effectiveThemeMode(ThemeMode themeMode) {
  if (themeMode == ThemeMode.dark || themeMode == ThemeMode.light) {
    return themeMode;
  }

  return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;
}

class _LanguageThemeSelectionPageState
    extends State<LanguageThemeSelectionPage> {
  static const String _localeKey = 'app_locale';

  @override
  void initState() {
    super.initState();
    // Theme initially provided by ThemeCubit; toggles update it live.
  }

  Future<void> _saveAndContinue() async {
    final prefs = getIt<SharedPreferences>();
    // save the locale that EasyLocalization is currently using
    final langCode = context.locale.languageCode;
    await prefs.setString(_localeKey, langCode);

    // Avoid using BuildContext across async gaps
    if (!mounted) return;

    // Apply locale immediately using EasyLocalization
    try {
      await context.setLocale(Locale(langCode));
    } catch (_) {}

    // Ensure the current ThemeCubit's value is persisted (if changed via the toggle)
    final currentTheme = context.read<ThemeCubit>().state.themeMode;
    await context.read<ThemeCubit>().setThemeMode(currentTheme);

    // Avoid using BuildContext across async gaps
    if (!mounted) return;

    // In debug mode always show onboarding after selection to exercise the flow
    if (kDebugMode) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.onboarding, (route) => false);
      });
      return;
    }

    // If onboarding hasn't been seen yet, show it; otherwise return to splash
    final seen = prefs.getBool('onboarding_seen') ?? false;
    if (!seen) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(Routes.onboarding);
      });
    } else {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.splash, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalSpace(48),

              Image.asset(
                AppImages.appLogo,
                height: AppSizes.logo200,
              ).fadeInScale(),
              verticalSpace(12),
              Text(
                'Language',
                style: TextStyle(
                  fontSize: AppSizes.l24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              verticalSpace(10),
              // Use the app segmented toggle for language selection
              const _LanguageToggle(),
              verticalSpace(30),
              Text(
                'Theme',
                style: TextStyle(
                  fontSize: AppSizes.l24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              verticalSpace(12),
              _ThemeToggle(),
              verticalSpace(60),

              CustomButton(
                borderRadius: AppSizes.rXL24,
                width: 220.w,
                height: 35.h,
                text: 'Continue',
                variant: ButtonVariant.icon,
                icon: const Icon(Icons.arrow_forward),
                onPressed: _saveAndContinue,
              ).fadeInScale(delay: const Duration(milliseconds: 300)),
              verticalSpace(40),
            ],
          ),
        ),
      ),
    );
  }
}
