import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        height: 70.h,
        margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 14.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(34.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDarkMode ? 0.18 : 0.08,
              ),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey800
                : AppColors.grey200.withOpacity(0.8),
          ),
        ),
        child: Row(
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'home.nav_home'.tr(),
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.card_travel_rounded,
              label: 'home.nav_packages'.tr(),
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.menu_book_rounded,
              label: 'home.nav_booking'.tr(),
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.settings_rounded,
              label: 'home.nav_settings'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: 46.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.grey500,
                size: 20.sp,
              ),
              SizedBox(height: 3.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12SemiBold.copyWith(
                  fontSize: 10.sp,
                  color: isSelected
                      ? Colors.white
                      : AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}