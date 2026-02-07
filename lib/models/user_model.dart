class UserModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String? school;
  final String? linkingCode;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.school,
    this.linkingCode,
  });
}
