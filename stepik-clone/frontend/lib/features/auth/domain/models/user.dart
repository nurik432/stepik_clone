// frontend/lib/features/auth/domain/models/user.dart
class User {
  final int id;
  final String email;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      isActive: json['is_active'],
    );
  }
}
