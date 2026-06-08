import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';

class RoleSelectionSection extends StatelessWidget {
  final String? selectedRole;
  final bool showRoleError;
  final ValueChanged<String> onSelect;

  const RoleSelectionSection({
    super.key,
    required this.selectedRole,
    required this.showRoleError,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'auth.signup.role_title'.tr(),

          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        SizedBox(height: AppSizes.s8),

        Row(
          children: [
            Expanded(
              child: RoleCard(
                role: 'user',
                title: 'auth.signup.role_student'.tr(),
                subtitle: 'auth.signup.role_student_desc'.tr(),
                icon: Icons.person_outline,
                isSelected: selectedRole == 'user',
                isDark: isDark,
                onTap: onSelect,
              ),
            ),

            SizedBox(width: AppSizes.m16),

            Expanded(
              child: RoleCard(
                role: 'manager',
                title: 'auth.signup.role_tutor'.tr(),
                subtitle: 'auth.signup.role_tutor_desc'.tr(),
                icon: Icons.admin_panel_settings_outlined,
                isSelected: selectedRole == 'manager',
                isDark: isDark,
                onTap: onSelect,
              ),
            ),
          ],
        ),

        if (showRoleError)
          Padding(
            padding: EdgeInsets.only(top: AppSizes.s8, left: AppSizes.s8),

            child: Text(
              'auth.signup.role_required_error'.tr(),

              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}

class RoleCard extends StatelessWidget {
  final String role;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final ValueChanged<String> onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => onTap(role),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: EdgeInsets.all(AppSizes.m16),

        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: isDark ? 0.15 : 0.05)
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),

          borderRadius: BorderRadius.circular(AppSizes.rM12),

          border: Border.all(
            color: isSelected
                ? primaryColor
                : (isDark ? Colors.grey[800]! : Colors.grey[300]!),

            width: isSelected ? 2 : 1,
          ),

          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              icon,
              size: AppSizes.iconXL48,

              color: isSelected
                  ? primaryColor
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),

            SizedBox(height: AppSizes.s8),

            Text(
              title,
              textAlign: TextAlign.center,

              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? primaryColor : null,
              ),
            ),

            SizedBox(height: AppSizes.xs4),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
