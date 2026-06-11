import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? accountType;
  final bool? isEmailVerified;
  final String? role;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.country,
    this.latitude,
    this.longitude,
    this.accountType,
    this.isEmailVerified,
    this.role,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phoneNumber,
    country,
    latitude,
    longitude,
    accountType,
    isEmailVerified,
    role,
  ];
}
