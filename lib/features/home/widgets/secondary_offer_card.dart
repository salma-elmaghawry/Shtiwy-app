
  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';
import 'package:shtiwy/features/home/widgets/small_offer_card.dart';
  
  Widget buildSecondaryOffersRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: buildSmallOfferCard(
              context,
              title: 'ليالي اسطنبول الساحرة',
              price: '15,800 ج.م',
              date: '05 مارس',
              imageUrl:
                  'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=600',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: buildSmallOfferCard(
              context,
              title: 'رحلة دبي العائلية',
              price: '12,200 ج.م',
              date: '25 فبراير',
              imageUrl:
                  'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=600',
            ),
          ),
        ],
      ),
    );
  }