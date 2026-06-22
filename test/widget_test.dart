import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shtiwy/core/error_handling/failures.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:shtiwy/features/auth/domain/entities/user.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/repository/auth_repository.dart';
import 'package:shtiwy/features/settings/presentation/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders settings page without preferences', (tester) async {
    tester.view.physicalSize = const Size(360, 690);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      EasyLocalization(
        fallbackLocale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                  create: (_) => ThemeCubit(sharedPreferences),
                ),
                BlocProvider<AuthCubit>(
                  create: (_) => AuthCubit(const _FakeAuthRepository()),
                ),
              ],
              child: MaterialApp(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: const SettingsScreen(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsNothing);
    expect(find.text('Sign Out'), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository();

  static const _failure = UnexpectedFailure(message: 'Not implemented in test');

  @override
  Stream<bool> authStateChanges() => const Stream<bool>.empty();

  @override
  getCurrentUser() => null;

  @override
  Future<Either<Failure, void>> resendOTP({required String email}) async {
    return left(_failure);
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    return left(_failure);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return right(null);
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
    String? country,
    double? latitude,
    double? longitude,
  }) async {
    return left(_failure);
  }

  @override
  Future<Either<Failure, User>> verifyOTP({
    required String email,
    required String token,
  }) async {
    return left(_failure);
  }
}
