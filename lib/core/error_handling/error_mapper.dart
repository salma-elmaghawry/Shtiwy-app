import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'failures.dart';

class ErrorMapper {
  static Failure map(dynamic error) {
    if (error is supabase.AuthException) {
      final msg = error.message.toLowerCase();
      final code = error.code?.toLowerCase();

      if (msg.contains('invalid login credentials')) {
        return InvalidCredentialsFailure(
          message: 'auth.errors.invalid_credentials'.tr(),
        );
      }

      if (msg.contains('already registered') ||
          msg.contains('user already exists')) {
        return EmailAlreadyInUseFailure(
          message: 'auth.errors.email_in_use'.tr(),
        );
      }

      if (code == 'email_not_confirmed') {
        return EmailNotConfirmedFailure(
          message: 'auth.errors.email_not_confirmed'.tr(),
        );
      }

      if (msg.contains('invalid token') ||
          msg.contains('token expired') ||
          msg.contains('otp') ||
          msg.contains('token has expired or is invalid')) {
        return InvalidOtpFailure(message: 'auth.errors.invalid_otp'.tr());
      }

      if (code == 'over_email_send_rate_limit' ||
          msg.contains('rate limit exceeded')) {
        return TooManyRequestsFailure(
          message: 'auth.errors.rate_limit_exceeded'.tr(),
        );
      }

      if (msg.contains('network')) {
        return NetworkFailure(message: 'errors.network_error'.tr());
      }

      return UnexpectedFailure(message: error.message);
    }

    if (error is supabase.PostgrestException) {
      return ServerFailure(message: 'errors.server_error'.tr());
    }

    return UnexpectedFailure(message: 'errors.unexpected_error'.tr());
  }
}