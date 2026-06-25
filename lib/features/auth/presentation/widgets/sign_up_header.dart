import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shtiwy/core/helpers/spacing.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/animated_logo.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(AppSizes.screenTopHeight20),
        const AnimatedLogo(),
        verticalSpace(AppSizes.m16),
        Text(
          'auth.signup.title'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ).animate().fadeIn(
              delay: 500.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ).slideY(
              begin: 0.15,
              end: 0,
              delay: 500.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
      ],
    );
  }
}
