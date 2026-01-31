import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();

  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _user = Rxn<User>();

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  User? get user => _user.value;

  /// Fazer login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final firebaseUser = await _authService.login(
        email: email,
        password: password,
      );

      if (firebaseUser != null) {
        _user.value = await _userService.getUser(firebaseUser.uid);
        _isLoading.value = false;
        return true;
      }
      throw Exception('Falha ao fazer login');
    } catch (e) {
      _errorMessage.value = e.toString();
      _isLoading.value = false;
      return false;
    }
  }

  /// Limpar mensagem de erro
  void clearError() {
    _errorMessage.value = null;
  }
}
