import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/custom_text_field.dart';

/// A row containing the country-code picker and the phone number text field,
/// both constrained to the same height via [crossAxisAlignment.stretch].
class PhoneFieldRow extends StatelessWidget {
  final TextEditingController phoneController;
  final ValueChanged<String?> onDialChanged;

  const PhoneFieldRow({
    super.key,
    required this.phoneController,
    required this.onDialChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: 'auth.signup.phone_label'.tr()),
        SizedBox(height: AppSizes.xs4),
        // Using IntrinsicHeight so both children share the same rendered height.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CountryCodePickerButton(onDialChanged: onDialChanged),
              SizedBox(width: AppSizes.s8),
              Expanded(
                child: CustomTextField(
                  controller: phoneController,
                  hint: 'auth.signup.phone_hint'.tr(),
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Private: field label
// ─────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Private: country code picker button
// ─────────────────────────────────────────────

class _CountryCodePickerButton extends StatefulWidget {
  final ValueChanged<String?> onDialChanged;
  const _CountryCodePickerButton({required this.onDialChanged});

  @override
  State<_CountryCodePickerButton> createState() =>
      _CountryCodePickerButtonState();
}

class _CountryCodePickerButtonState extends State<_CountryCodePickerButton> {
  OutlineInputBorder _pickerBorder({Color? color, double width = 0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.rM12),
      borderSide: color == null
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.surfaceDark : AppColors.grey200;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hintColor = isDark ? AppColors.grey600 : AppColors.grey500;

    return CountryCodePicker(
      onChanged: (c) => widget.onDialChanged(c.dialCode),
      initialSelection: 'EG',
      favorite: const ['+20', 'EG'],
      padding: EdgeInsets.zero,
      dialogBackgroundColor: theme.colorScheme.surface,
      barrierColor: Colors.black54,
      boxDecoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.rL16),
      ),
      closeIcon: Icon(Icons.close, color: textColor),
      dialogTextStyle:
          theme.textTheme.bodyMedium?.copyWith(color: textColor),
      headerTextStyle:
          theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ) ??
          TextStyle(fontWeight: FontWeight.w700, color: textColor),
      searchStyle: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      searchDecoration: InputDecoration(
        hintText: 'auth.signup.country_hint'.tr(),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: hintColor),
        prefixIcon: Icon(Icons.search, color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.m16,
          vertical: AppSizes.s8,
        ),
        border: _pickerBorder(),
        enabledBorder: _pickerBorder(),
        focusedBorder:
            _pickerBorder(color: theme.colorScheme.primary, width: 1.5),
      ),
      builder: (country) {
        final flagUri = country?.flagUri;
        final dialCode = country?.dialCode ?? '+20';

        return Container(
          // Match the text field height; stretches to IntrinsicHeight parent.
          constraints: BoxConstraints(minHeight: AppSizes.inputHeight56),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.m16),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppSizes.rM12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (flagUri != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.rXS4),
                  child: Image.asset(
                    flagUri,
                    package: 'country_code_picker',
                    width: AppSizes.iconL32,
                  ),
                ),
                SizedBox(width: AppSizes.s8),
              ],
              Text(
                dialCode,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
              SizedBox(width: AppSizes.xs4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: hintColor,
                size: AppSizes.iconS20,
              ),
            ],
          ),
        );
      },
    );
  }
}
