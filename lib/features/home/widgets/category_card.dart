import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';

Widget buildCategoryCard(BuildContext context, IconData icon, String label) {
  return Container(
    width: 100.w,
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.screenPadding16,
      vertical: AppSizes.screenPadding16,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(AppSizes.rM12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: AppSizes.iconM24),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.font12SemiBold.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
