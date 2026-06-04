import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawirni/core/helpers/app_validatore.dart';
import 'package:nawirni/core/routes/routes.dart';
import 'package:nawirni/core/utils/app_sizes.dart';
import 'package:nawirni/core/widgets/app_header_controls.dart';
import 'package:nawirni/core/widgets/custom_text_field.dart';
import 'package:nawirni/core/widgets/custom_button.dart';
import 'package:nawirni/core/widgets/loading_overlay.dart';
import 'package:nawirni/features/auth/presentation/widgets/role_selection.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedRole;
  bool _showRoleError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess && !state.isEmailVerified) {
          // Navigate to OTP verification page after successful signup
          Navigator.of(context).pushReplacementNamed(
            Routes.otpVerification,
            arguments: _emailController.text.trim(),
          );
        }
      },
      child: _buildSignUpContent(context),
    );
  }

  Widget _buildSignUpContent(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.l,
                vertical: AppSizes.m,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SignUpHeader(),
                    SizedBox(height: AppSizes.xxl),
                    _SignUpFormFields(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                    ),
                    SizedBox(height: AppSizes.m),
                    RoleSelectionSection(
                      selectedRole: _selectedRole,
                      showRoleError: _showRoleError,
                      onSelect: (role) {
                        setState(() {
                          _selectedRole = role;
                          _showRoleError = false;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.l),
                    CustomButton(
                      text: 'auth.signup.register_button'.tr(),
                      onPressed: state.isLoading ? null : _handleRegister,
                    ),
                    const _LoginSection(),
                    SizedBox(height: AppSizes.l),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRole == null) {
      setState(() {
        _showRoleError = true;
      });
      return;
    }

    context.read<AuthCubit>().signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole!,
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    actions: const [AppHeaderControls()],
  );
}

class _SignUpHeader extends StatelessWidget {
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'auth.signup.title'.tr(),
          textAlign: TextAlign.center,

          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        SizedBox(height: AppSizes.s),

        Text(
          'auth.signup.subtitle'.tr(),
          textAlign: TextAlign.center,

          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

class _SignUpFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _SignUpFormFields({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          label: 'auth.signup.name_label'.tr(),
          hint: 'auth.signup.name_hint'.tr(),
          prefixIcon: const Icon(Icons.person_outline),
        ),

        SizedBox(height: AppSizes.m),

        CustomTextField(
          controller: emailController,
          label: 'auth.login.email_label'.tr(),
          hint: 'auth.login.email_hint'.tr(),
          prefixIcon: const Icon(Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          liveValidation: true,
        ),

        SizedBox(height: AppSizes.m),

        CustomTextField(
          controller: passwordController,
          label: 'auth.login.password_label'.tr(),
          hint: 'auth.login.password_hint'.tr(),
          isPassword: true,
          validator: (value) => AppValidators.validateConfirmPassword(
            value,
            passwordController.text,
          ),
          prefixIcon: const Icon(Icons.lock_outline),
          liveValidation: true,
          showPasswordStrength: true,
        ),

        SizedBox(height: AppSizes.m),

        CustomTextField(
          controller: confirmPasswordController,
          label: 'auth.signup.confirm_password_label'.tr(),
          hint: 'auth.signup.confirm_password_hint'.tr(),
          isPassword: true,
          prefixIcon: const Icon(Icons.lock_outline),
        ),
      ],
    );
  }
}

class _LoginSection extends StatelessWidget {
  const _LoginSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'auth.signup.already_have_account'.tr(),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'auth.signup.login_link'.tr(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
