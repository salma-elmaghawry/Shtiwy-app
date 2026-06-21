import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/animations/animations.dart';
import 'package:shtiwy/core/helpers/app_validatore.dart';
import 'package:shtiwy/core/helpers/spacing.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
import 'package:shtiwy/core/widgets/custom_button.dart';
import 'package:shtiwy/core/widgets/custom_text_field.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.action != AuthAction.login) return;

        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('auth.login.success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed(Routes.home);
        }
      },
      child: _buildLoginContent(context),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
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
                      ).popIn(),

                      verticalSpace(AppSizes.m16),
                      Text(
                        'auth.login.title'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'auth.login.subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: AppSizes.xl32),
                      CustomTextField(
                        controller: _emailController,
                        label: 'auth.login.email_label'.tr(),
                        hint: 'auth.login.email_hint'.tr(),
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.validateEmail,
                        liveValidation: true,
                      ),
                      SizedBox(height: AppSizes.m16),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'auth.login.password_label'.tr(),
                        hint: 'auth.login.password_hint'.tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        isPassword: true,
                        validator: AppValidators.validatePassword,
                        liveValidation: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forgot password
                          },
                          child: Text(
                            'auth.login.forgot_password'.tr(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.l24),
                      CustomButton(
                        text: 'auth.login.login_button'.tr(),
                        onPressed: state.isLoading ? null : _handleLogin,
                      ),
                      SizedBox(height: AppSizes.xl32),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'auth.login.no_account'.tr(),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.signUp);
                            },
                            child: Text(
                              'auth.login.signup_link'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }
}
