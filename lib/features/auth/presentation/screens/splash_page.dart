import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawirni/core/utils/app_sizes.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_state.dart';

@RoutePage()
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
      context.router.replace(const LoginRoute());
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
              Icon(
                Icons.school_rounded,
                size: AppSizes.iconXL,
                color: Theme.of(context).primaryColor,
              ),
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
    context.router.replace(const StudenHomeRoute());
  } else {
    context.router.replace(const InstractorHomeRoute());
  }
}
