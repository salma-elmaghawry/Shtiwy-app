import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/custom_button.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
import 'package:shtiwy/core/widgets/premium_otp_input.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.action == AuthAction.verifyOTP) {
          if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'errors.unexpected_error'.tr()),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.isSuccess && state.isEmailVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('auth.otp.success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home after successful verification
            Navigator.of(context).pushReplacementNamed(Routes.home);
          }
        } else if (state.action == AuthAction.resendOTP) {
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
                content: Text('auth.otp.otp_resent'.tr()),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      },
      child: _buildOtpContent(context, email),
    );
  }

  Widget _buildOtpContent(BuildContext context, String email) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        final resolvedEmail = email.isNotEmpty ? email : (state.user?.email ?? '');

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
                      Text(
                        'auth.otp.title'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSizes.m16),
                      Text(
                        'auth.otp.subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: AppSizes.xxl48),
                      PremiumOtpInput(
                        controller: _otpController,
                        focusNode: _focusNode,
                        isVerifying: state.isLoading,
                        isError: state.isFailure,
                        isSuccess: state.isSuccess && state.isEmailVerified,
                        onCompleted: (otp) => _handleVerifyOtp(context, resolvedEmail),
                      ),
                      SizedBox(height: AppSizes.xxl48),
                      CustomButton(
                        text: 'auth.otp.verify_button'.tr(),
                        onPressed: state.isLoading
                            ? null
                            : () => _handleVerifyOtp(context, resolvedEmail),
                      ),
                      SizedBox(height: AppSizes.l24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'auth.otp.didnt_receive'.tr(),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              if (resolvedEmail.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email address is missing.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              context.read<AuthCubit>().resendOTP(email: resolvedEmail);
                            },
                            child: Text(
                              'auth.otp.resend'.tr(),
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

  void _handleVerifyOtp(BuildContext context, String email) {
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.otp.invalid_otp'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email address is missing. Please try signing up again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthCubit>().verifyOTP(email: email, token: otp);
  }
}
