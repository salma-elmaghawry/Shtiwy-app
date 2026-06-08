import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shtiwy/core/error_handling/failures.dart';
import 'package:shtiwy/core/theme/controller/theme_cubit.dart';
import 'package:shtiwy/features/auth/domain/entities/user.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/repository/auth_repository.dart';
import 'package:shtiwy/shtiwy_app.dart';
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

  testWidgets('renders the app shell', (tester) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      EasyLocalization(
        fallbackLocale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(
              create: (_) => ThemeCubit(sharedPreferences),
            ),
            BlocProvider<AuthCubit>(
              create: (_) => AuthCubit(_FakeAuthRepository()),
            ),
          ],
          child: const ShtiwyApp(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}

class _FakeAuthRepository implements AuthRepository {
  static const _failure = UnexpectedFailure(message: 'Not implemented in test');

  @override
  Stream<bool> authStateChanges() => const Stream<bool>.empty();

  @override
  User? getCurrentUser() => null;

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
