import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:shtiwy/core/theme/controller/theme_state.dart';
import 'package:shtiwy/core/widgets/app_segmented_toggle.dart';

class AppHeaderControls extends StatelessWidget {
  final bool showLanguage;
  final bool showTheme;

  const AppHeaderControls({
    super.key,
    this.showLanguage = true,
    this.showTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    final controls = <Widget>[
      if (showLanguage) const _LanguageToggle(),
      if (showTheme) const _ThemeToggle(),
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < controls.length; index++) ...[
              if (index > 0) const SizedBox(width: 8),
              controls[index],
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    return AppSegmentedToggle<String>(
      selectedValue: context.locale.languageCode,
      minSegmentWidth: 64,
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
          minSegmentWidth: 58,
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
