import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Simulate loading for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final state = context.read<AuthCubit>().state;
      _handleNavigation(state);
    });
  }

  void _handleNavigation(AuthStates state) {
    if (state.isLoading) return;
    if (state.isAuthenticated) {
      handleHomeNavigation(context, state);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        _handleNavigation(state);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.appLogo, height: AppSizes.logo),
              SizedBox(height: AppSizes.l),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

void handleHomeNavigation(BuildContext context, AuthStates state) {
  if (state.user?.role == 'student') {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  } else {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }
}
