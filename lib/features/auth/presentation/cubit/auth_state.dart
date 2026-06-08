import 'package:shtiwy/core/bloc/base_bloc.dart';
import 'package:shtiwy/core/error_handling/failures.dart';
import 'package:shtiwy/features/auth/domain/entities/user.dart';

class AuthStates extends BaseState {
  final User? user;
  final bool isAuthenticated;
  final bool isEmailVerified;
  final Failure? failure;

  const AuthStates({
    super.status = Status.initial,
    super.message,
    this.user,
    this.isAuthenticated = false,
    this.isEmailVerified = false,
    this.failure,
  });

  AuthStates copyWith({
    Status? status,
    String? message,
    User? user,
    bool? isAuthenticated,
    bool? isEmailVerified,
    Failure? failure,
  }) {
    return AuthStates(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    user,
    isAuthenticated,
    isEmailVerified,
    failure,
  ];
}
