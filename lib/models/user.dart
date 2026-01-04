import 'user_role.dart';

class User {
  final String id;
  final String username;
  final String name;
  final UserRole role;

  User({required this.id, required this.username, required this.name, required this.role});
}
