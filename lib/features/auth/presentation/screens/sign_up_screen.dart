import 'package:flutter/material.dart';
import 'package:shtiwy/features/auth/presentation/widgets/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          bottom: true,
          child: SignUpBody(),
        ),
      );
}
