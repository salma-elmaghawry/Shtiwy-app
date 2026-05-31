//use getit
import 'package:get_it/get_it.dart';
import 'package:nawirni/core/services/supabase_service.dart';
import 'package:nawirni/core/theme/controller/theme_cubit.dart';
import 'package:nawirni/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:nawirni/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:nawirni/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nawirni/features/auth/repository/auth_repository.dart';
import 'package:nawirni/features/auth/repository/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupInjection() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register ThemeCubit
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt()));
  //services
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
  //=====================AuthService================
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDatasourceImpl(getIt()),
  );

  //Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  //Auth cubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
}
