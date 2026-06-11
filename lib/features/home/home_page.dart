import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shtiwy/features/packages/presentation/widgets/packages_list.dart';

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
            body: Column(
              children: [
                Text(
                  'app_name'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ).tr(),
                const PackagesList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
