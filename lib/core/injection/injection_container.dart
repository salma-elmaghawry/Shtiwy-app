//use getit
import 'package:get_it/get_it.dart';
import 'package:nawirni/core/theme/controller/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupInjection() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register ThemeCubit
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt()));
}
