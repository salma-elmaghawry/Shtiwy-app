import 'package:shtiwy/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.isEmailVerified = false,
    super.role,
  });

  factory UserModel.fromAuthUser(supabase.User user) {
    final metadata = user.userMetadata ?? {};
    return UserModel(
      id: user.id,
      email: user.email ?? "",
      name: metadata['full_name'] as String?,
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
      'isEmailVerified': isEmailVerified,
      'role': role,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    bool? isEmailVerified,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
    );
  }

  User toEntity() => this;
}
