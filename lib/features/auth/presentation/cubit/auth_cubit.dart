import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/bloc/base_bloc.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shtiwy/features/auth/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(const AuthStates());

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.login));
    final result = await _authRepository.signIn(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.login,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: user.isEmailVerified,
          action: AuthAction.login,
        ),
      ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
    String? country,
    double? latitude,
    double? longitude,
  }) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.signUp));
    final result = await _authRepository.signUp(
      email: email,
      password: password,
      name: name,
      role: role,
      phoneNumber: phoneNumber,
      country: country,
      latitude: latitude,
      longitude: longitude,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.signUp,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: user.isEmailVerified ?? false,
          action: AuthAction.signUp,
        ),
      ),
    );
  }

  Future<void> verifyOTP({required String email, required String token}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.verifyOTP));
    final result = await _authRepository.verifyOTP(email: email, token: token);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.verifyOTP,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: true,
          action: AuthAction.verifyOTP,
        ),
      ),
    );
  }

  // resend otp

  Future<void> resendOTP({required String email}) async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.resendOTP));
    final result = await _authRepository.resendOTP(email: email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.resendOTP,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          message: "OTP resent successfully",
          action: AuthAction.resendOTP,
        ),
      ),
    );
  }

  // sign out
  Future<void> signOut() async {
    emit(state.copyWith(status: Status.loading, action: AuthAction.signOut));
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: AuthAction.signOut,
        ),
      ),
      (_) => emit(
        const AuthStates(
          status: Status.initial,
          isAuthenticated: false,
          action: AuthAction.signOut,
        ),
      ),
    );
  }

  // check auth status
  Future<void> checkAuthStatus() async {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: user.isEmailVerified,
          action: AuthAction.checkStatus,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: Status.initial,
          user: null,
          isAuthenticated: false,
          isEmailVerified: false,
          action: AuthAction.checkStatus,
        ),
      );
    }
  }
}
