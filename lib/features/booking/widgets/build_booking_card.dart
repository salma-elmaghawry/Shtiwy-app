 
 
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';
import 'package:shtiwy/core/widgets/app_header.dart';
 
 Widget buildBookingCard(
    BuildContext context, {
    required String bookingRef,
    required String packageName,
    required String bookingDate,
    required String amount,
    required bool isPaid,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.rL16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bookingRef,
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (isPaid ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  isPaid ? 'تم الدفع' : 'معلق',
                  style: AppTextStyles.font10Normal.copyWith(
                    color: isPaid ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            packageName,
            style: AppTextStyles.font16Normal.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تاريخ الحجز: $bookingDate',
                style: AppTextStyles.font12SemiBold.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              Text(
                amount,
                style: AppTextStyles.font16Normal.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }