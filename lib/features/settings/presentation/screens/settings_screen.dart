import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtiwy/core/helpers/spacing.dart';
import 'package:shtiwy/core/injection/injection_container.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:shtiwy/core/theme/controller/theme_state.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (bottomSheetContext) {
        final currentLocale = context.locale.languageCode;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey700 : AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              verticalSpace(18),
              Text(
                'settings.select_language'.tr(),
                style: AppTextStyles.font18Normal.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              verticalSpace(20),
              _buildLanguageOption(
                context: context,
                label: 'English',
                langCode: 'en',
                isSelected: currentLocale == 'en',
                isDark: isDark,
              ),
              verticalSpace(12),
              _buildLanguageOption(
                context: context,
                label: 'العربية',
                langCode: 'ar',
                isSelected: currentLocale == 'ar',
                isDark: isDark,
              ),
              verticalSpace(24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String label,
    required String langCode,
    required bool isSelected,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        await context.setLocale(Locale(langCode));
        final prefs = getIt<SharedPreferences>();
        await prefs.setString('app_locale', langCode);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : isDark
              ? AppColors.grey800.withValues(alpha: 0.3)
              : AppColors.grey100,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.font16Normal.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primary
                    : isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          title: Text(
            'settings.sign_out'.tr(),
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          content: Text(
            'settings.sign_out_confirm'.tr(),
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'settings.cancel'.tr(),
                style: const TextStyle(color: AppColors.grey600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('settings.sign_out'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final languageName = isArabic ? 'العربية' : 'English';
    final backgroundColor = isDarkMode
        ? AppColors.backgroundDark
        : const Color(0xFFFCF8F5);

    final content = ColoredBox(
      color: backgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'settings.title'.tr(),
              style: AppTextStyles.font24Bold.copyWith(
                fontSize: 22.sp,
                height: 1.1,
                color: isDarkMode
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF4C3422),
              ),
            ),
            verticalSpace(4),
            Text(
              'settings.subtitle'.tr(),
              style: AppTextStyles.font14Normal.copyWith(
                fontSize: 13.sp,
                height: 1.25,
                color: isDarkMode
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF8D7664),
              ),
            ),
            verticalSpace(26),
            _buildSectionHeader('settings.appearance'.tr()),
            verticalSpace(8),
            _buildSettingsCard(
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  final isDarkSwitch =
                      state.themeMode == ThemeMode.dark ||
                      (state.themeMode == ThemeMode.system &&
                          MediaQuery.platformBrightnessOf(context) ==
                              Brightness.dark);

                  return _buildSwitchTile(
                    title: 'settings.dark_mode'.tr(),
                    subtitle: 'settings.dark_mode_desc'.tr(),
                    value: isDarkSwitch,
                    onChanged: (value) {
                      context.read<ThemeCubit>().setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                    iconData: Icons.dark_mode_outlined,
                    iconColor: const Color(0xFFC4702B),
                    iconBgColor: isDarkMode
                        ? const Color(0xFF403327)
                        : const Color(0xFFFFEEE4),
                  );
                },
              ),
            ),
            verticalSpace(20),
            _buildSectionHeader('settings.localization'.tr()),
            verticalSpace(8),
            _buildSettingsCard(
              child: _buildNavigationTile(
                title: 'settings.language'.tr(),
                subtitle: 'settings.language_desc'.tr(
                  namedArgs: {'lang': languageName},
                ),
                trailingText: languageName,
                onTap: () => _showLanguageBottomSheet(context),
                iconData: Icons.language_outlined,
                iconColor: AppColors.secondary,
                iconBgColor: isDarkMode
                    ? const Color(0xFF44201E)
                    : const Color(0xFFFFEAEA),
                isArabic: isArabic,
              ),
            ),
            verticalSpace(20),
            _buildSectionHeader('settings.assistance'.tr()),
            verticalSpace(8),
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildNavigationTile(
                    title: 'settings.help_support'.tr(),
                    subtitle: 'settings.help_support_desc'.tr(),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('settings.help_support'.tr()),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    iconData: Icons.help_outline_rounded,
                    iconColor: isDarkMode
                        ? AppColors.grey400
                        : AppColors.grey600,
                    iconBgColor: isDarkMode
                        ? AppColors.grey800.withValues(alpha: 0.5)
                        : const Color(0xFFF0EDEB),
                    isArabic: isArabic,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: isArabic ? 16.w : 66.w,
                    endIndent: isArabic ? 66.w : 16.w,
                    color: isDarkMode ? AppColors.grey800 : AppColors.grey200,
                  ),
                  _buildNavigationTile(
                    title: 'settings.about'.tr(),
                    subtitle: 'settings.about_desc'.tr(),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'app_name'.tr(),
                        applicationVersion: '2.4.0',
                        applicationLegalese: '© 2026 Shtiwy Tourism',
                        applicationIcon: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Icon(
                            Icons.mosque,
                            size: 40.r,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                    iconData: Icons.info_outline_rounded,
                    iconColor: isDarkMode
                        ? AppColors.grey400
                        : AppColors.grey600,
                    iconBgColor: isDarkMode
                        ? AppColors.grey800.withValues(alpha: 0.5)
                        : const Color(0xFFF0EDEB),
                    isArabic: isArabic,
                  ),
                ],
              ),
            ),
            verticalSpace(28),
            _buildSignOutButton(isDarkMode),
          ],
        ),
      ),
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: content),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.font12SemiBold.copyWith(
        color: const Color(0xFF9E5C20),
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.12 : 0.035),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey800
              : AppColors.grey200.withValues(alpha: 0.5),
        ),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(14.r), child: child),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          _buildLeadingIcon(
            iconData: iconData,
            iconColor: iconColor,
            iconBgColor: iconBgColor,
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font16Normal.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(2),
                Text(
                  subtitle,
                  style: AppTextStyles.font12SemiBold.copyWith(
                    fontSize: 11.sp,
                    color: isDarkMode
                        ? AppColors.textSecondaryDark
                        : AppColors.grey600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: isDarkMode
                ? AppColors.grey700
                : const Color(0xFFE1DCD8),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
    String? trailingText,
    required bool isArabic,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        child: Row(
          children: [
            _buildLeadingIcon(
              iconData: iconData,
              iconColor: iconColor,
              iconBgColor: iconBgColor,
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font16Normal.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpace(2),
                  Text(
                    subtitle,
                    style: AppTextStyles.font12SemiBold.copyWith(
                      fontSize: 11.sp,
                      color: isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.grey600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailingText != null) ...[
              horizontalSpace(8),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 76.w),
                child: Text(
                  trailingText,
                  style: AppTextStyles.font14Normal.copyWith(
                    fontSize: 12.sp,
                    color: isDarkMode
                        ? AppColors.textSecondaryDark
                        : AppColors.grey600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              horizontalSpace(4),
            ],
            Icon(
              isArabic ? Icons.chevron_left : Icons.chevron_right,
              color: isDarkMode ? AppColors.grey600 : AppColors.grey400,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon({
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
      child: Icon(iconData, color: iconColor, size: 19.sp),
    );
  }

  Widget _buildSignOutButton(bool isDarkMode) {
    return InkWell(
      onTap: () => _showSignOutDialog(context),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.12 : 0.035),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey800
                : AppColors.grey200.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 19.sp),
            horizontalSpace(8),
            Text(
              'settings.sign_out'.tr(),
              style: AppTextStyles.font16Normal.copyWith(
                color: AppColors.error,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
