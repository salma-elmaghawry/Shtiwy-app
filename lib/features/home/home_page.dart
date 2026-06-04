import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawirni/core/routes/routes.dart';
import 'package:nawirni/core/widgets/app_header_controls.dart';
import 'package:nawirni/core/widgets/loading_overlay.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        } else if (!state.isAuthenticated && !state.isLoading) {
          Navigator.of(context).pushReplacementNamed(Routes.splash);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: [
                const AppHeaderControls(showLanguage: false),
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: state.isLoading
                      ? null
                      : () => context.read<AuthCubit>().signOut(),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: const Center(child: Text('Welcome to SHITAWY')),
          ),
        );
      },
    );
  }
}
