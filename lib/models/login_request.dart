import 'user_role.dart';

class LoginRequest {
  final String username;
  final String password;
  final UserRole role;

  LoginRequest({required this.username, required this.password, required this.role});
}
