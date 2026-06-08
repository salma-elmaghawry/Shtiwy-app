//use getit
import 'package:get_it/get_it.dart';
import 'package:shtiwy/core/routes/app_router.dart';
import 'package:shtiwy/core/services/supabase_service.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:shtiwy/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:shtiwy/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/repository/auth_repository.dart';
import 'package:shtiwy/features/auth/repository/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupInjection() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //Routes
  getIt.registerLazySingleton(() => AppRouter());

  // Register ThemeCubit
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt()));
  //services
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
  //=====================AuthService================
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDatasourceImpl(),
  );

  //Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  //Auth cubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
}
