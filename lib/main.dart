import 'package:shtiwy/core/injection/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shtiwy/core/services/supabase_service.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/shtiwy_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupInjection();
  await dotenv.load(fileName: ".env");
  await SupabaseService.init();

  runApp(
    EasyLocalization(
      fallbackLocale: const Locale('en'),
      supportedLocales: [const Locale('en'), const Locale('ar')],
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => getIt<ThemeCubit>()),
          BlocProvider<AuthCubit>(
            create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
          ),
        ],
        child: const ShtiwyApp(),
      ),
    ),
  );
}
