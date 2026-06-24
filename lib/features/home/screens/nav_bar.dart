import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_text_styles.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        height: 64.h,
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(36.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.30 : 0.12),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 40,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey800
                : AppColors.grey200.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _NavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'home.nav_home'.tr(),
              currentIndex: widget.currentIndex,
              previousIndex: _previousIndex,
              onTap: widget.onTap,
            ),
            _NavItem(
              index: 1,
              icon: Icons.card_travel_rounded,
              label: 'home.nav_packages'.tr(),
              currentIndex: widget.currentIndex,
              previousIndex: _previousIndex,
              onTap: widget.onTap,
            ),
            _NavItem(
              index: 2,
              icon: Icons.menu_book_rounded,
              label: 'home.nav_booking'.tr(),
              currentIndex: widget.currentIndex,
              previousIndex: _previousIndex,
              onTap: widget.onTap,
            ),
            _NavItem(
              index: 3,
              icon: Icons.settings_rounded,
              label: 'home.nav_settings'.tr(),
              currentIndex: widget.currentIndex,
              previousIndex: _previousIndex,
              onTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual nav item with premium animation
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final String label;
  final int currentIndex;
  final int previousIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.currentIndex,
    required this.previousIndex,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scaleAnim = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _slideAnim = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.currentIndex == widget.index) {
      _controller.value = 1.0; // start fully selected if already active
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasSelected = oldWidget.currentIndex == widget.index;
    final isSelected = widget.currentIndex == widget.index;

    if (!wasSelected && isSelected) {
      // Became selected → play entrance animation
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.currentIndex == widget.index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onTap(widget.index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: isSelected
              ? _SelectedContent(
                  icon: widget.icon,
                  label: widget.label,
                  scaleAnim: _scaleAnim,
                  slideAnim: _slideAnim,
                )
              : _UnselectedContent(
                  icon: widget.icon,
                  label: widget.label,
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Selected state: bouncy icon + sliding label
// ─────────────────────────────────────────────────────────────────────────────

class _SelectedContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final Animation<double> scaleAnim;
  final Animation<double> slideAnim;

  const _SelectedContent({
    required this.icon,
    required this.label,
    required this.scaleAnim,
    required this.slideAnim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnim,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, slideAnim.value),
          child: Transform.scale(
            scale: scaleAnim.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20.sp),
                SizedBox(height: 3.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12SemiBold.copyWith(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Unselected state: greyed out, subtle scale-down on tap
// ─────────────────────────────────────────────────────────────────────────────

class _UnselectedContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const _UnselectedContent({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.grey500, size: 20.sp)
            .animate()
            .fadeIn(duration: 200.ms),
        SizedBox(height: 3.h),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12SemiBold.copyWith(
            fontSize: 10.sp,
            color: AppColors.grey500,
          ),
        ).animate().fadeIn(duration: 200.ms),
      ],
    );
  }
}