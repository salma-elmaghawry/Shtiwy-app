import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawirni/core/injection/injection_container.dart';
import 'package:nawirni/core/theme/controller/theme_cubit.dart';
import 'package:nawirni/nawirni_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupInjection();
  runApp(
    EasyLocalization(
      fallbackLocale: const Locale('en'),
      supportedLocales: [const Locale('en'), const Locale('ar')],
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => getIt<ThemeCubit>(),
        ),
        ],
        child: const NawirniApp(),
      ),
    ),
  );
}
