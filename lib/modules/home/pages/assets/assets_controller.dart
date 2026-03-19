import 'package:get/get.dart';

import '../../../../core/domain/models/user_model.dart';
import '../../../../core/domain/use_cases/get_current_user_use_case.dart';
import '../../../../ui/helpers/helpers.dart';
import 'domain/models/asset_model.dart';
import 'domain/use_cases/create_asset_use_case.dart';
import 'domain/use_cases/get_user_assets_use_case.dart';
import 'domain/use_cases/update_asset_use_case.dart';

class AssetsController extends GetxController with UIMessagesManager {
  final CreateAssetUseCase _createAssetUseCase;
  final GetUserAssetsUseCase _getUserAssetsUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AssetsController(
    this._createAssetUseCase,
    this._getUserAssetsUseCase,
    this._updateAssetUseCase,
    this._getCurrentUserUseCase,
  );

  final _assets = <AssetModel>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _isSaving = false.obs;

  List<AssetModel> get assets => _assets.toList();
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isSaving => _isSaving.value;

  UserModel? _currentUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadCurrentUser();
    _loadAssets();
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _getCurrentUserUseCase.execute();
    } catch (e) {
      showError(message: 'Erro ao carregar usuário: $e');
    }
  }

  /// Carregar assets do usuário logado
  Future<void> _loadAssets() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final userId = _currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final userAssets = await _getUserAssetsUseCase.execute(userId);
      _assets.assignAll(userAssets);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Converter string para snake_case
  String _toSnakeCase(String str) {
    return str
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^\w_]'), '');
  }

  /// Criar novo asset
  Future<void> createAsset(String name) async {
    try {
      final userId = _currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final now = DateTime.now();
      final asset = AssetModel(
        userId: userId,
        name: name,
        type: _toSnakeCase(name),
        percentage: 0,
        createdAt: now,
      );

      await _createAssetUseCase.execute(asset);
      await _loadAssets();
    } catch (e) {
      showError(message: 'Erro ao criar asset: $e');
    }
  }

  /// Limpar mensagem de erro
  void clearError() {
    _errorMessage.value = null;
  }

  /// Calcular soma dos percentuais
  int _calculateTotalPercentage() {
    return _assets.fold(0, (sum, asset) => sum + asset.percentage);
  }

  /// Validar se a soma dos percentuais é 100
  bool _isValidAllocation() {
    final total = _calculateTotalPercentage();
    return (total - 100).abs() <
        0.01; // Tolerância para erros de ponto flutuante
  }

  /// Atualizar percentage de um asset
  Future<void> updateAssetPercentage(String assetId, int percentage) async {
    try {
      final assetIndex = _assets.indexWhere((a) => a.id == assetId);
      if (assetIndex != -1) {
        final asset = _assets[assetIndex];
        final updatedAsset = asset.copyWith(percentage: percentage);
        _assets[assetIndex] = updatedAsset;
      }
    } catch (e) {
      showError(message: 'Erro ao atualizar asset: $e');
    }
  }

  Future<void> onSave() async {
    _errorMessage.value = null;

    // Validar se a soma dos percentuais é 100
    if (!_isValidAllocation()) {
      final total = _calculateTotalPercentage();
      showError(
        message: 'A soma dos percentuais deve ser 100%. Atual: $total%',
      );
      return;
    }

    _isSaving.value = true;

    try {
      // Atualizar todos os assets no Firestore
      for (final asset in _assets) {
        await _updateAssetUseCase.execute(asset);
      }

      showMessage(
        message: 'Configuração de ativos salva com sucesso!',
      );
    } catch (e) {
      showError(message: 'Erro ao salvar configuração: $e');
    } finally {
      _isSaving.value = false;
    }
  }
}
