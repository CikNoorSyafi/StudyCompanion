import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/login_request.dart';
import '../services/mock_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(LoginRequest req) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final user = await MockAuthService.authenticate(req);

    _isLoading = false;
    if (user != null) {
      _currentUser = user;
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid username/password/role';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
