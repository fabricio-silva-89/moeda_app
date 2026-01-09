import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class SignupController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  /// Registrar novo usuário
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final firebaseUser = await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      if (firebaseUser != null) {
        // Criar documento do usuário no Firestore
        final user = User(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? email,
          name: name,
          createdAt: DateTime.now(),
        );

        await _userService.createUser(user);
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Falha ao criar conta');
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
