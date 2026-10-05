import '../models/user.dart';

class AuthService {
  static final AuthService _instance =
      AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  User? login({
    required String username,
    required String password,
    required UserRole role,
  }) {
    if (username.trim().isEmpty ||
        password.isEmpty) {
      return null;
    }

    _currentUser = User(
      id: role == UserRole.admin
          ? 'admin_001'
          : 'student_001',
      username: username.trim(),
      role: role,
    );

    return _currentUser;
  }

  void logout() {
    _currentUser = null;
  }
}