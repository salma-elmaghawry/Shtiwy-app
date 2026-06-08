import 'package:dartz/dartz.dart';
import 'package:shtiwy/core/error_handling/failures.dart';
import 'package:shtiwy/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<Either<Failure, void>> signOut();
  // otp
  Future<Either<Failure, User>> verifyOTP({
    required String email,
    required String token,
  });
  Future<Either<Failure, void>> resendOTP({required String email});
  User? getCurrentUser();
  Stream<bool> authStateChanges();
}
