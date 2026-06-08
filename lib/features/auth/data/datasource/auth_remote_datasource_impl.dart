import 'package:shtiwy/core/services/supabase_service.dart';
import 'package:shtiwy/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:shtiwy/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  AuthRemoteDatasourceImpl();

  GoTrueClient get _auth => SupabaseService.auth;

  UserModel _mapUser(User user) => UserModel.fromAuthUser(user);

  // Implementing the signIn method to authenticate the user with email and password
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw Exception("invalid credentials");
    }
    return _mapUser(response.user!);
  }

  // Implementing the signUp method to register a new user with email, password, name, and role
  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name, 'role': role},
    );
    final user = response.user;

    if (user == null) {
      throw AuthException("Registration failed");
    }
    if (user.identities?.isEmpty ?? false) {
      throw AuthException("Email already in use");
    }
    return _mapUser(user);
  }

  // Implementing the signOut method to log out the current user
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // verifying the OTP sent to the user's email during the sign-up process
  @override
  Future<UserModel?> verifyOTP({
    required String email,
    required String token,
  }) async {
    final response = await _auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
    final user = response.user;
    if (user == null) {
      throw Exception("Invalid OTP");
    }
    return _mapUser(user);
  }

  //resending the OTP to the user's email if they did not receive it during the sign-up process
  @override
  Future<void> resendOTP({required String email}) async {
    await _auth.resend(email: email, type: OtpType.signup);
  }

  //to listen to authentication state changes, such as when a user signs in or out, and returns a stream of boolean values indicating whether the user is currently authenticated or not
  @override
  Stream<bool> authStateChanges() {
    return _auth.onAuthStateChange.map((event) => event.session != null);
  }

  // Implementing the getCurrentUser method to retrieve the currently authenticated user, if any
  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  // Implementing the resetPassword method to send a password reset email to the user
  @override
  Future<void> resetPassword(String email) {
    throw UnimplementedError();
  }
}
