import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/helpers/app_validatore.dart';
import 'package:shtiwy/core/helpers/spacing.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/custom_button.dart';
import 'package:shtiwy/core/widgets/custom_text_field.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shtiwy/features/auth/presentation/widgets/phone_field_row.dart';
import 'package:shtiwy/features/auth/presentation/widgets/sign_up_header.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  // ─── Form ────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  String? _dial = '+20';
  final String _role = 'user';

  // ─── Lifecycle ───────────────────────────────────────────────────────────
  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  // ─── Actions ─────────────────────────────────────────────────────────────
  void _register() {
    if (!_formKey.currentState!.validate()) return;
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

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: _handleAuthState,
      child: BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state) => LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding24,
                vertical: AppSizes.screenPadding24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SignUpHeader(),
                    verticalSpace(AppSizes.xl32),
                    _buildNameField(),
                    verticalSpace(AppSizes.m16),
                    _buildEmailField(),
                    verticalSpace(AppSizes.m16),
                    _buildPasswordField(),
                    verticalSpace(AppSizes.m16),
                    _buildConfirmPasswordField(),
                    verticalSpace(AppSizes.m16),
                    PhoneFieldRow(
                      phoneController: _phone,
                      onDialChanged: (dial) => setState(() => _dial = dial),
                    ),
                    verticalSpace(AppSizes.l24),
                    _buildRegisterButton(state),
                    verticalSpace(AppSizes.l24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Field builders ──────────────────────────────────────────────────────

  Widget _buildNameField() => CustomTextField(
    controller: _name,
    label: 'auth.signup.name_label'.tr(),
    hint: 'auth.signup.name_hint'.tr(),
    prefixIcon: const Icon(Icons.person_outline),
  );

  Widget _buildEmailField() => CustomTextField(
    controller: _email,
    label: 'auth.login.email_label'.tr(),
    hint: 'auth.login.email_hint'.tr(),
    prefixIcon: const Icon(Icons.email_outlined),
    keyboardType: TextInputType.emailAddress,
    liveValidation: true,
    validator: AppValidators.validateEmail,
  );

  Widget _buildPasswordField() => CustomTextField(
    controller: _password,
    label: 'auth.login.password_label'.tr(),
    hint: 'auth.login.password_hint'.tr(),
    isPassword: true,
    validator: AppValidators.validatePassword,
    prefixIcon: const Icon(Icons.lock_outline),
    liveValidation: true,
    showPasswordStrength: true,
  );

  Widget _buildConfirmPasswordField() => CustomTextField(
    controller: _confirm,
    label: 'auth.signup.confirm_password_label'.tr(),
    hint: 'auth.signup.confirm_password_hint'.tr(),
    isPassword: true,
    validator: (v) => AppValidators.validateConfirmPassword(v, _password.text),
    prefixIcon: const Icon(Icons.lock_outline),
  );

  Widget _buildRegisterButton(AuthStates state) => CustomButton(
    text: 'auth.signup.register_button'.tr(),
    onPressed: state.isLoading ? null : _register,
  );

  // ─── Listener ────────────────────────────────────────────────────────────

  void _handleAuthState(BuildContext context, AuthStates state) {
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
  }
}
