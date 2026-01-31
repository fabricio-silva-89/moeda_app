import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/asset_model.dart';
import '../../../../services/asset_service.dart';
import '../../../../services/auth_service.dart';

class AssetsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AssetService _assetService = Get.find<AssetService>();

  final _assets = <Asset>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _isSaving = false.obs;

  List<Asset> get assets => _assets.toList();
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isSaving => _isSaving.value;

  @override
  void onInit() {
    super.onInit();
    _loadAssets();
  }

  /// Carregar assets do usuário logado
  Future<void> _loadAssets() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final userAssets = await _assetService.getUserAssets(userId);
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
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final now = DateTime.now();
      final asset = Asset(
        userId: userId,
        name: name,
        type: _toSnakeCase(name),
        percentage: 0,
        createdAt: now,
      );

      await _assetService.createAsset(asset);
      await _loadAssets();
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  /// Limpar mensagem de erro
  void clearError() {
    _errorMessage.value = null;
  }

  /// Calcular soma dos percentuais
  double _calculateTotalPercentage() {
    return _assets.fold(0.0, (sum, asset) => sum + asset.percentage);
  }

  /// Validar se a soma dos percentuais é 100
  bool _isValidAllocation() {
    final total = _calculateTotalPercentage();
    return (total - 100).abs() <
        0.01; // Tolerância para erros de ponto flutuante
  }

  /// Atualizar percentage de um asset
  Future<void> updateAssetPercentage(String assetId, double percentage) async {
    try {
      final assetIndex = _assets.indexWhere((a) => a.id == assetId);
      if (assetIndex != -1) {
        final asset = _assets[assetIndex];
        final updatedAsset = asset.copyWith(percentage: percentage);
        await _assetService.updateAsset(updatedAsset);
        _assets[assetIndex] = updatedAsset;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> onSave() async {
    _errorMessage.value = null;

    // Validar se a soma dos percentuais é 100
    if (!_isValidAllocation()) {
      final total = _calculateTotalPercentage();
      _errorMessage.value =
          'A soma dos percentuais deve ser 100%. Atual: ${total.toStringAsFixed(1)}%';
      return;
    }

    _isSaving.value = true;

    try {
      // Atualizar todos os assets no Firestore
      for (final asset in _assets) {
        await _assetService.updateAsset(asset);
      }

      Get.snackbar(
        'Sucesso',
        'Configuração de ativos salva com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _errorMessage.value = 'Erro ao salvar configuração: $e';
    } finally {
      _isSaving.value = false;
    }
  }
}
