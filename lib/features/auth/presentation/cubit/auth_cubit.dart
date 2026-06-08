import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/bloc/base_bloc.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shtiwy/features/auth/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(const AuthStates());

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: Status.loading));
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
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: user.isEmailVerified,
        ),
      ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _authRepository.signUp(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: false,
        ),
      ),
    );
  }

  Future<void> verifyOTP({required String email, required String token}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _authRepository.verifyOTP(email: email, token: token);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: Status.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: true,
        ),
      ),
    );
  }

  // resend otp

  Future<void> resendOTP({required String email}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _authRepository.resendOTP(email: email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          message: "OTP resent successfully",
        ),
      ),
    );
  }

  // sign out
  Future<void> signOut() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
        ),
      ),
      (_) => emit(
        const AuthStates(status: Status.initial, isAuthenticated: false),
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
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: Status.initial,
          user: null,
          isAuthenticated: false,
          isEmailVerified: false,
        ),
      );
    }
  }
}
