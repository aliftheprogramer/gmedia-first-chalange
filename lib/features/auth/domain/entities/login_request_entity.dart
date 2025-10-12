// lib/features/auth/domain/entities/login_request_entity.dart

class LoginRequestEntity {
  final String email;
  final String password;

  LoginRequestEntity({required this.email, required this.password});
}