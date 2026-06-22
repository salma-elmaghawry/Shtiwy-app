import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';
import 'package:shtiwy/features/booking/widgets/build_booking_card.dart';
import 'package:shtiwy/core/widgets/app_header.dart';

class BookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text('home.nav_booking'.tr(), style: AppTextStyles.font24Bold),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    children: [
                      buildBookingCard(
                        context,
                        bookingRef: '#SHT-9831',
                        packageName: 'رحلة العمرة المميزة - فندق الصفوة',
                        bookingDate: '22 يونيو 2026',
                        amount: '7,500 ج.م',
                        isPaid: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
