import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';

Widget buildFeaturedOfferCard(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(AppSizes.rL16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.rL16),
              ),
              child: Image.asset(
                AppImages.hotel1,
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180.h,
                    color: AppColors.grey300,
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppSizes.rXS4),
                ),
                child: Text(
                  'home.discount_badge'.tr(namedArgs: {'discount': '15'}),
                  style: AppTextStyles.font10Normal.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'رحلة العمرة المميزة - فندق الصفوة',
                      style: AppTextStyles.font16Normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '7,500 ج.م',
                    style: AppTextStyles.font16Normal.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '10 يناير',
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.nights_stay_outlined,
                    size: 14.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'home.nights'.tr(namedArgs: {'count': '5'}),
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.star_outline,
                    size: 14.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'home.stars'.tr(namedArgs: {'count': '5'}),
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('عرض تفاصيل رحلة العمرة المميزة'),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.grey100,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.rM12),
                    ),
                  ),
                  child: Text(
                    'home.trip_details'.tr(),
                    style: AppTextStyles.font14SemiBold.copyWith(
                      color: AppColors.grey800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
