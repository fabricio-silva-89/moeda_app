import 'package:get/get.dart';

import '../../models/asset_model.dart';
import '../../models/user_model.dart';
import '../../services/asset_service.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();
  final AssetService _assetService = Get.find<AssetService>();

  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _user = Rxn<User>();

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  User? get user => _user.value;

  /// Registrar novo usuário
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = null;

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

        // Criar assets padrão para o usuário
        await _createDefaultAssets(user.uid);

        _user.value = user;
        _isLoading.value = false;
        return true;
      }
      throw Exception('Falha ao criar conta');
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

  /// Criar assets padrão para o usuário
  Future<void> _createDefaultAssets(String userId) async {
    final now = DateTime.now();
    final defaultAssets = [
      Asset(
        userId: userId,
        name: 'Renda Fixa',
        type: 'renda_fixa',
        percentage: 20,
        createdAt: now,
        updatedAt: now,
      ),
      Asset(
        userId: userId,
        name: 'Ações nacionais',
        type: 'acoes_nacionais',
        percentage: 20,
        createdAt: now,
        updatedAt: now,
      ),
      Asset(
        userId: userId,
        name: 'Ações Internacionais',
        type: 'acoes_internacionais',
        percentage: 20,
        createdAt: now,
        updatedAt: now,
      ),
      Asset(
        userId: userId,
        name: 'Fundos Imobiliários',
        type: 'fiis',
        percentage: 20,
        createdAt: now,
        updatedAt: now,
      ),
      Asset(
        userId: userId,
        name: 'Criptomoedas',
        type: 'cripto',
        percentage: 20,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final asset in defaultAssets) {
      await _assetService.createAsset(asset);
    }
  }
}
