import '../models/user.dart';
import '../models/user_role.dart';
import '../models/login_request.dart';

class MockAuthService {
  static final List<User> _sampleUsers = [
    User(id: 's1', username: 'student1', name: 'Ali Student', role: UserRole.student),
    User(id: 't1', username: 'teacher1', name: 'Mr. Tan', role: UserRole.teacher),
    User(id: 'p1', username: 'parent1', name: 'Mrs. Ong', role: UserRole.parent),
    User(id: 'a1', username: 'admin', name: 'Admin', role: UserRole.admin),
  ];

  // Simple password map for UI-only validation
  static final Map<String, String> _passwords = {
    'student1': 'pass123',
    'teacher1': 'pass123',
    'parent1': 'pass123',
    'admin': 'admin123',
  };

  /// Simulate authentication against the sample list. Returns User on success or null.
  static Future<User?> authenticate(LoginRequest req) async {
    // simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    User? found;
    for (final u in _sampleUsers) {
      if (u.username.toLowerCase() == req.username.toLowerCase() && u.role == req.role) {
        found = u;
        break;
      }
    }

    if (found == null) return null;
    final pw = _passwords[found.username];
    if (pw != null && pw == req.password) return found;
    return null;
  }
}
