import 'package:dartz/dartz.dart';
import 'package:nawirni/core/error_handling/error_mapper.dart';
import 'package:nawirni/core/error_handling/failures.dart';
import 'package:nawirni/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:nawirni/features/auth/domain/entities/user.dart';
import 'package:nawirni/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  AuthRepositoryImpl(this._remoteDataSource);
  @override
  Stream<bool> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }

  @override
  User? getCurrentUser() {
    return _remoteDataSource.getCurrentUser()?.toEntity();
  }

  @override
  Future<Either<Failure, void>> resendOTP({required String email}) async {
    try {
      return Right(_remoteDataSource.resendOTP(email: email));
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      return Right(_remoteDataSource.signOut());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final user = await _remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      return Right(user.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      final user = await _remoteDataSource.verifyOTP(
        email: email,
        token: token,
      );
      if (user == null) {
        return Left(ErrorMapper.map("Invalid OTP"));
      }
      return Right(user.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }
}
