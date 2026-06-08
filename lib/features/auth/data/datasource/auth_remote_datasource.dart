import 'package:shtiwy/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  });

  Future<void> signOut();

  Future<void> resetPassword(String email);

  UserModel? getCurrentUser();

  Future<UserModel?> verifyOTP({required String email, required String token});

  Future<void> resendOTP({required String email});

  Stream<bool> authStateChanges();
}
