import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/app_header_controls.dart';
import 'package:shtiwy/core/widgets/custom_button.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpControllers = List.generate(8, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess && state.isEmailVerified) {
          // Navigate to home after successful verification
          Navigator.of(context).pushReplacementNamed(Routes.home);
        }
      },
      child: _buildOtpContent(context, email),
    );
  }

  Widget _buildOtpContent(BuildContext context, String email) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              actions: const [AppHeaderControls(showTheme: false)],
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.l,
                  vertical: AppSizes.m,
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
                      SizedBox(height: AppSizes.m),
                      Text(
                        'auth.otp.subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: AppSizes.xxl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          8,
                          (index) => SizedBox(
                            width: 50,
                            child: TextField(
                              controller: _otpControllers[index],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 7) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.xxl),
                      CustomButton(
                        text: 'auth.otp.verify_button'.tr(),
                        onPressed: state.isLoading
                            ? null
                            : () => _handleVerifyOtp(context, email),
                      ),
                      SizedBox(height: AppSizes.l),
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
                              // Handle resend OTP
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
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.isEmpty || otp.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.otp.invalid_otp'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthCubit>().verifyOTP(email: email, token: otp);
  }
}
