import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';

Widget buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          AppImages.appLogo,
          width: AppSizes.iconXL48,
          height: AppSizes.iconXL48,
        ),
        RichText(
          text: TextSpan(
            style: AppTextStyles.font20Bold,
            children: [
              TextSpan(
                text: 'app_header_1'.tr(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              TextSpan(
                text: 'app_header_2'.tr(),
                style: const TextStyle(
                  color: AppColors.third,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Image.asset(
          AppImages.chatbot,
          width: AppSizes.iconXL48,
          height: AppSizes.iconXL48,
        ),
      ],
    ),
  );
}
