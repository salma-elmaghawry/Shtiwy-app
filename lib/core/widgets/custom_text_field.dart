import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../helpers/app_validatore.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

enum PasswordStrength { none, weak, medium, strong }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool liveValidation;
  final bool showPasswordStrength;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,

    this.liveValidation = false,
    this.showPasswordStrength = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;
  late String _value;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
    _value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(context),
        _buildTextField(context),
        _buildPasswordStrength(context),
      ],
    );
  }

  // =========================
  // Build Methods
  // =========================

  Widget _buildLabel(BuildContext context) {
    if (widget.label == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          widget.label!,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: AppSizes.xs4),
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textField = TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      enabled: widget.enabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      textAlignVertical: TextAlignVertical.center,
      style: theme.textTheme.bodyMedium,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.grey600 : AppColors.grey500,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(),
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.grey200,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.m16,
          vertical: AppSizes.s8,
        ),
        border: _buildBorder(theme),
        enabledBorder: _buildBorder(theme),
        focusedBorder: _buildFocusedBorder(theme),
        errorBorder: _buildErrorBorder(theme),
      ),
    );

    if (widget.isPassword || widget.maxLines == 1) {
      return SizedBox(height: AppSizes.inputHeight56, child: textField);
    }

    return textField;
  }

  Widget _buildSuffixIcon() {
    final isEmailField = widget.keyboardType == TextInputType.emailAddress;

    if (widget.isPassword) {
      return IconButton(
        onPressed: _togglePasswordVisibility,
        icon: Icon(
          _isPasswordVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      );
    }

    if (widget.liveValidation && isEmailField && _value.isNotEmpty) {
      final isValid = AppValidators.isValidEmail(_value);
      return Icon(
        isValid ? Icons.check_circle : Icons.cancel,
        color: isValid ? Colors.green : Colors.redAccent,
      );
    }

    return widget.suffixIcon ?? const SizedBox.shrink();
  }

  Widget _buildPasswordStrength(BuildContext context) {
    if (!widget.showPasswordStrength || !widget.isPassword || _value.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final strength = _getPasswordStrength();
    final strengthValue = _getStrengthValue(strength);
    final strengthColor = _getStrengthColor(strength);
    final strengthText = _getStrengthText(strength);

    return Padding(
      padding: EdgeInsets.only(top: AppSizes.s8),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: strengthValue,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(strengthColor),
              ),
            ),
          ),
          SizedBox(width: AppSizes.s8),
          Text(
            strengthText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: strengthColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.rM12),
      borderSide: BorderSide.none,
    );
  }

  OutlineInputBorder _buildFocusedBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.rM12),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    );
  }

  OutlineInputBorder _buildErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.rM12),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
    );
  }

  // =========================
  // Helper Methods
  // =========================

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  PasswordStrength _getPasswordStrength() {
    if (_value.isEmpty) return PasswordStrength.none;

    final score = _calculatePasswordScore();
    return switch (score) {
      <= 1 => PasswordStrength.weak,
      <= 3 => PasswordStrength.medium,
      _ => PasswordStrength.strong,
    };
  }

  int _calculatePasswordScore() {
    int score = 0;
    if (AppValidators.hasMinimumLength(_value)) score++;
    if (AppValidators.hasMixedCase(_value)) score++;
    if (AppValidators.hasDigit(_value)) score++;
    if (AppValidators.hasSpecialCharacter(_value)) score++;
    return score;
  }

  double _getStrengthValue(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.weak => 0.3,
      PasswordStrength.medium => 0.6,
      PasswordStrength.strong => 1.0,
      _ => 0,
    };
  }

  Color _getStrengthColor(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.weak => Colors.redAccent,
      PasswordStrength.medium => Colors.orangeAccent,
      PasswordStrength.strong => Colors.green,
      _ => Colors.grey,
    };
  }

  String _getStrengthText(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.weak => 'auth.password_strength.weak'.tr(),
      PasswordStrength.medium => 'auth.password_strength.medium'.tr(),
      PasswordStrength.strong => 'auth.password_strength.strong'.tr(),
      _ => '',
    };
  }
}
