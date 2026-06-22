import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';

Widget buildSmallOfferCard(
  BuildContext context, {
  required String title,
  required String price,
  required String date,
  required String imageUrl,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.rM12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.rM12),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.grey300,
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.font12SemiBold.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                price,
                style: AppTextStyles.font14Normal.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 10.sp,
                    color: AppColors.grey500,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    date,
                    style: AppTextStyles.font10Normal.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
