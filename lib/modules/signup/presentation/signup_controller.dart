import 'package:get/get.dart';

import '../domain/params/create_user_assets_params.dart';
import '../domain/params/create_user_params.dart';
import '../domain/params/register_params.dart';
import '../domain/use_case/create_user_assets_use_case.dart';
import '../domain/use_case/create_user_use_case.dart';
import '../domain/use_case/register_use_case.dart';

class SignupController extends GetxController {
  final RegisterUseCase _registerUseCase;
  final CreateUserUseCase _createUserUseCase;
  final CreateUserAssetsUseCase _createUserAssetsUseCase;

  SignupController(
    this._registerUseCase,
    this._createUserUseCase,
    this._createUserAssetsUseCase,
  );

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;

  Future<bool> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final userId = await _registerUseCase.execute(
        params: RegisterParams(
          email: email,
          password: password,
          name: name,
        ),
      );

      if (userId != null) {
        await _createUserUseCase.execute(
          params: CreateUserParams(
            uid: userId,
            email: email,
            name: name,
            createdAt: DateTime.now(),
          ),
        );

        await _createDefaultAssets(userId);

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

  void clearError() {
    _errorMessage.value = null;
  }

  Future<void> _createDefaultAssets(String userId) async {
    final now = DateTime.now();
    final defaultAssets = [
      CreateUserAssetsParams(
        userId: userId,
        name: 'Renda Fixa',
        type: 'renda_fixa',
        percentage: 20,
        createdAt: now,
      ),
      CreateUserAssetsParams(
        userId: userId,
        name: 'Ações nacionais',
        type: 'acoes_nacionais',
        percentage: 20,
        createdAt: now,
      ),
      CreateUserAssetsParams(
        userId: userId,
        name: 'Ações Internacionais',
        type: 'acoes_internacionais',
        percentage: 20,
        createdAt: now,
      ),
      CreateUserAssetsParams(
        userId: userId,
        name: 'Fundos Imobiliários',
        type: 'fiis',
        percentage: 20,
        createdAt: now,
      ),
      CreateUserAssetsParams(
        userId: userId,
        name: 'Criptomoedas',
        type: 'cripto',
        percentage: 20,
        createdAt: now,
      ),
    ];

    for (final asset in defaultAssets) {
      await _createUserAssetsUseCase.execute(params: asset);
    }
  }
}
