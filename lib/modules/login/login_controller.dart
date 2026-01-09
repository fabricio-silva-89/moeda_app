import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class LoginController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  /// Fazer login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final firebaseUser = await _authService.login(
        email: email,
        password: password,
      );

      if (firebaseUser != null) {
        _user = await _userService.getUser(firebaseUser.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Falha ao fazer login');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Limpar mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
