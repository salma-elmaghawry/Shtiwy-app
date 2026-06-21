import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shtiwy/core/animations/app_animations.dart';
import 'package:shtiwy/core/helpers/app_validatore.dart';
import 'package:shtiwy/core/helpers/spacing.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/theme/app_colors.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/custom_button.dart';
import 'package:shtiwy/core/widgets/custom_text_field.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
// role_selection removed; sign-up defaults to 'user'
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';


class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  String? _dial = '+1';
  final String _role = 'user';


  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildCountryCodePicker(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.surfaceDark : AppColors.grey100;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final hintColor = isDark ? AppColors.grey600 : AppColors.grey500;

    OutlineInputBorder pickerBorder({Color? color, double width = 0}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.rM12),
        borderSide: color == null
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );
    }

    return CountryCodePicker(
      onChanged: (c) => setState(() {
        _dial = c.dialCode;
      }),
      initialSelection: 'US',
      favorite: const ['+1', 'US'],
      padding: EdgeInsets.zero,
      dialogBackgroundColor: theme.colorScheme.surface,
      barrierColor: Colors.black54,
      boxDecoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.rL16),
      ),
      closeIcon: Icon(Icons.close, color: textColor),
      dialogTextStyle: theme.textTheme.bodyMedium?.copyWith(color: textColor),
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
        border: pickerBorder(),
        enabledBorder: pickerBorder(),
        focusedBorder: pickerBorder(
          color: theme.colorScheme.primary,
          width: 1.5,
        ),
      ),
      builder: (country) {
        final flagUri = country?.flagUri;
        final dialCode = country?.dialCode ?? _dial ?? '+1';

        return Container(
          height: AppSizes.inputHeight56,
          padding: EdgeInsets.symmetric(horizontal: AppSizes.m16),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppSizes.rM12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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

  Widget _buildFieldLabel(BuildContext context, String label) {
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

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    // Role defaults to 'user' so no selection required
    context.read<AuthCubit>().signUp(
      email: _email.text.trim(),
      password: _password.text,
      name: _name.text.trim(),
      role: _role,
      phoneNumber: _phone.text.trim().isEmpty
          ? null
          : '$_dial${_phone.text.trim()}',


    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.action != AuthAction.signUp) return;

        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess && !state.isEmailVerified) {
          Navigator.pushNamed(
            context,
            Routes.otpVerification,
            arguments: _email.text.trim(),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.isLoading,
            child: Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.l24,
                  vertical: AppSizes.m16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      verticalSpace(AppSizes.screenTopHeight40),

                      Image.asset(
                        AppImages.appLogo,
                        height: AppSizes.logo120,
                      ).fadeInScale(
                        delay: const Duration(milliseconds: 150),
                        duration: AppAnimations.medium,
                        beginScale: AppAnimations.revealScale,
                      ),
                      verticalSpace(AppSizes.m16),
                      Text(
                        'auth.signup.title'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSizes.xxl48),
                      CustomTextField(
                        controller: _name,
                        label: 'auth.signup.name_label'.tr(),
                        hint: 'auth.signup.name_hint'.tr(),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      SizedBox(height: AppSizes.m16),
                      CustomTextField(
                        controller: _email,
                        label: 'auth.login.email_label'.tr(),
                        hint: 'auth.login.email_hint'.tr(),
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        liveValidation: true,
                        validator: AppValidators.validateEmail,
                      ),
                      SizedBox(height: AppSizes.m16),
                      CustomTextField(
                        controller: _password,
                        label: 'auth.login.password_label'.tr(),
                        hint: 'auth.login.password_hint'.tr(),
                        isPassword: true,
                        validator: AppValidators.validatePassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        liveValidation: true,
                        showPasswordStrength: true,
                      ),
                      SizedBox(height: AppSizes.m16),
                      CustomTextField(
                        controller: _confirm,
                        label: 'auth.signup.confirm_password_label'.tr(),
                        hint: 'auth.signup.confirm_password_hint'.tr(),
                        isPassword: true,
                        validator: (v) => AppValidators.validateConfirmPassword(
                          v,
                          _password.text,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      SizedBox(height: AppSizes.m16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(
                            context,
                            'auth.signup.phone_label'.tr(),
                          ),
                          SizedBox(height: AppSizes.xs4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: AppSizes.inputHeight56,
                                child: _buildCountryCodePicker(context),
                              ),
                              SizedBox(width: AppSizes.s8),
                              Expanded(
                                child: CustomTextField(
                                  controller: _phone,
                                  hint: 'auth.signup.phone_hint'.tr(),
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),


                      // RoleSelection removed — default role set to 'user'
                      SizedBox(height: AppSizes.l24),
                      CustomButton(
                        text: 'auth.signup.register_button'.tr(),
                        onPressed: state.isLoading ? null : _register,
                      ),
                      SizedBox(height: AppSizes.l24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
