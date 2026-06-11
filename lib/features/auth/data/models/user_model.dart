import 'package:shtiwy/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.phoneNumber,
    super.country,
    super.latitude,
    super.longitude,
    super.accountType,
    super.isEmailVerified = false,
    super.role,
  });

  factory UserModel.fromAuthUser(supabase.User user) {
    final metadata = user.userMetadata ?? {};
    return UserModel(
      id: user.id,
      email: user.email ?? "",
      name: metadata['full_name'] as String?,
      phoneNumber: metadata['phone_number'] as String?,
      country: metadata['country'] as String?,
      latitude: metadata['latitude'] != null
          ? double.tryParse(metadata['latitude'].toString())
          : null,
      longitude: metadata['longitude'] != null
          ? double.tryParse(metadata['longitude'].toString())
          : null,
      accountType: metadata['account_type'] as String?,
      isEmailVerified: user.emailConfirmedAt != null,
      role: metadata['role']?.toString(),
    );
  }
  // fromjosn -> deserealization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      country: json['country'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      accountType: json['accountType'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      role: json['role'] as String?,
    );
  }
  //tojosn -> seralization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'accountType': accountType,
      'isEmailVerified': isEmailVerified,
      'role': role,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? country,
    double? latitude,
    double? longitude,
    String? accountType,
    bool? isEmailVerified,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accountType: accountType ?? this.accountType,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
    );
  }

  User toEntity() => this;
}
