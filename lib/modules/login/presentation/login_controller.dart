import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../domain/use_case/login_use_case.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase);

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;

  final _user = Rxn<UserModel>();
  UserModel? get user => _user.value;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final userId = await _loginUseCase.execute(
        email,
        password,
      );

      if (userId == null) throw Exception('Falha ao fazer login');

      _isLoading.value = false;
      return true;
    } catch (e) {
      _errorMessage.value = e.toString();
      _isLoading.value = false;
      return false;
    }
  }

  void clearError() {
    _errorMessage.value = null;
  }
}
