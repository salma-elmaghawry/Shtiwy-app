import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        } else if (!state.isAuthenticated && !state.isLoading) {
          Navigator.of(context).pushReplacementNamed(Routes.splash);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _HomeView(userName: state.user?.name),
                  _MyTripsView(),
                  _BookingsView(),
                  _ContactView(),
                ],
              ),
            ),
            floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      // WhatsApp contact launcher action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('جاري الاتصال بـ شتيوي للسياحة عبر واتساب...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    backgroundColor: const Color(0xFF25D366),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  )
                : null,
            floatingActionButtonLocation: context.locale.languageCode == 'ar'
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.startFloat,
            bottomNavigationBar: _buildBottomNavBar(context),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(0, Icons.home, 'home.nav_home'.tr()),
          _buildNavBarItem(1, Icons.airplanemode_active, 'home.nav_trips'.tr()),
          _buildNavBarItem(2, Icons.calendar_month, 'home.nav_bookings'.tr()),
          _buildNavBarItem(3, Icons.support_agent, 'home.nav_contact'.tr()),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.grey500,
              size: AppSizes.iconM24,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.font12SemiBold.copyWith(
                color: isSelected ? Colors.white : AppColors.grey600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Home View Tab Content
// ----------------------------------------------------
class _HomeView extends StatelessWidget {
  final String? userName;

  const _HomeView({this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildHeroBanner(context),
              _buildCategoryRow(context),
              _buildLatestOffersHeader(context),
              _buildFeaturedOfferCard(context),
              _buildSecondaryOffersRow(context),
              _buildNewsletterBanner(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الملف الشخصي')),
              );
            },
            icon: Icon(
              Icons.account_circle_outlined,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
          RichText(
            text: TextSpan(
              style: AppTextStyles.font20Bold,
              children: const [
                TextSpan(
                  text: 'SHTIWY ',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: 'شتيوي.',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('القائمة الجانبية')),
              );
            },
            icon: Icon(
              Icons.menu,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      height: 240.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.rL16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.rL16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1565552645632-d7c5f7ebe16c?w=800',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.grey300,
                  child: const Icon(Icons.image, size: 50),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(AppSizes.rXS4),
                    ),
                    child: Text(
                      'home.announcement'.tr(),
                      style: AppTextStyles.font10Normal.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'home.hajj_1447'.tr(),
                    style: AppTextStyles.font20Bold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'home.hajj_subtitle'.tr(),
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('جاري حجز رحلة الحج...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.rM12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'home.book_now'.tr(),
                            style: AppTextStyles.font14SemiBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            context.locale.languageCode == 'ar'
                                ? Icons.arrow_back
                                : Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryCard(
            context,
            Icons.mosque,
            'home.hajj_offers'.tr(),
          ),
          _buildCategoryCard(
            context,
            Icons.brightness_3,
            'home.umrah_trips'.tr(),
          ),
          _buildCategoryCard(
            context,
            Icons.explore_outlined,
            'home.external_tourism'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, IconData icon, String label) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.rM12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconM24,
            ),
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

  Widget _buildLatestOffersHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.latest_offers'.tr(),
                style: AppTextStyles.font18Normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2.h),
                height: 3.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('عرض جميع العروض والمكافآت')),
              );
            },
            child: Text(
              'home.view_all'.tr(),
              style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedOfferCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.rL16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                child: Image.network(
                  'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
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
                    Icon(Icons.calendar_today_outlined, size: 14.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(
                      '10 يناير',
                      style: AppTextStyles.font12SemiBold.copyWith(color: AppColors.grey600),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.nights_stay_outlined, size: 14.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(
                      'home.nights'.tr(namedArgs: {'count': '5'}),
                      style: AppTextStyles.font12SemiBold.copyWith(color: AppColors.grey600),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.star_outline, size: 14.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(
                      'home.stars'.tr(namedArgs: {'count': '5'}),
                      style: AppTextStyles.font12SemiBold.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('عرض تفاصيل رحلة العمرة المميزة')),
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

  Widget _buildSecondaryOffersRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: _buildSmallOfferCard(
              context,
              title: 'ليالي اسطنبول الساحرة',
              price: '15,800 ج.م',
              date: '05 مارس',
              imageUrl: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=600',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildSmallOfferCard(
              context,
              title: 'رحلة دبي العائلية',
              price: '12,200 ج.م',
              date: '25 فبراير',
              imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=600',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallOfferCard(
    BuildContext context, {
    required String title,
    required String price,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.rM12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.rM12),
            ),
            child: Image.network(
              imageUrl,
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100.h,
                  color: AppColors.grey300,
                  child: const Icon(Icons.image, size: 30),
                );
              },
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
                    Icon(Icons.calendar_today_outlined, size: 10.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(
                      date,
                      style: AppTextStyles.font10Normal.copyWith(color: AppColors.grey600),
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

  Widget _buildNewsletterBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE87A24),
            Color(0xFFF2994A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.rL16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home.subscribe_title'.tr(),
            style: AppTextStyles.font18Normal.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'home.subscribe_desc'.tr(),
            style: AppTextStyles.font12SemiBold.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.rM12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'home.email_placeholder'.tr(),
                      hintStyle: AppTextStyles.font14Normal.copyWith(
                        color: AppColors.grey500,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.font14Normal.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('تم الاشتراك بنجاح!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  minimumSize: Size(0, 44.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.rM12),
                  ),
                ),
                child: Text(
                  'home.subscribe_btn'.tr(),
                  style: AppTextStyles.font14SemiBold.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// My Trips View
// ----------------------------------------------------
class _MyTripsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'home.nav_trips'.tr(),
                  style: AppTextStyles.font24Bold,
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTripCard(
                        context,
                        title: 'رحلة العمرة المميزة',
                        date: '10 يناير 2026',
                        status: 'قادمة',
                        statusColor: AppColors.success,
                        icon: Icons.mosque,
                      ),
                      SizedBox(height: 12.h),
                      _buildTripCard(
                        context,
                        title: 'رحلة دبي العائلية',
                        date: '25 فبراير 2026',
                        status: 'قيد المراجعة',
                        statusColor: AppColors.warning,
                        icon: Icons.flight,
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle_outlined,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
          RichText(
            text: TextSpan(
              style: AppTextStyles.font20Bold,
              children: const [
                TextSpan(
                  text: 'SHTIWY ',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'شتيوي.',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(
    BuildContext context, {
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.rL16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font16Normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: AppTextStyles.font12SemiBold.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status,
              style: AppTextStyles.font10Normal.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// Bookings View
// ----------------------------------------------------
class _BookingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'home.nav_bookings'.tr(),
                  style: AppTextStyles.font24Bold,
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    children: [
                      _buildBookingCard(
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle_outlined,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
          RichText(
            text: TextSpan(
              style: AppTextStyles.font20Bold,
              children: const [
                TextSpan(
                  text: 'SHTIWY ',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'شتيوي.',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
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
            color: Colors.black.withOpacity(0.04),
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
                  color: (isPaid ? AppColors.success : AppColors.error).withOpacity(0.1),
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
}

// ----------------------------------------------------
// Contact View
// ----------------------------------------------------
class _ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'home.nav_contact'.tr(),
                  style: AppTextStyles.font24Bold,
                ),
                SizedBox(height: 16.h),
                _buildContactItem(
                  context,
                  title: 'خدمة العملاء (الهاتف)',
                  subtitle: '+20 123 456 7890',
                  icon: Icons.phone_in_talk_outlined,
                  onTap: () {},
                ),
                SizedBox(height: 12.h),
                _buildContactItem(
                  context,
                  title: 'راسلنا عبر واتساب',
                  subtitle: '+20 123 456 7890',
                  icon: Icons.chat_bubble_outline,
                  onTap: () {},
                ),
                SizedBox(height: 12.h),
                _buildContactItem(
                  context,
                  title: 'البريد الإلكتروني',
                  subtitle: 'support@shtiwy.com',
                  icon: Icons.mail_outline_rounded,
                  onTap: () {},
                ),
                SizedBox(height: 12.h),
                _buildContactItem(
                  context,
                  title: 'العنوان',
                  subtitle: 'القاهرة، مصر',
                  icon: Icons.location_on_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle_outlined,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
          RichText(
            text: TextSpan(
              style: AppTextStyles.font20Bold,
              children: const [
                TextSpan(
                  text: 'SHTIWY ',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'شتيوي.',
                  style: TextStyle(
                    color: AppColors.third,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: AppColors.third,
              size: AppSizes.iconL32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.rL16),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSizes.rL16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font16Normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
