import 'package:get/get.dart';

import '../../../../core/domain/models/user_model.dart';
import '../../../../core/domain/use_cases/get_current_user_use_case.dart';
import '../../../../ui/helpers/helpers.dart';
import '../assets/domain/models/asset_model.dart';
import '../assets/domain/use_cases/create_asset_use_case.dart';
import '../assets/domain/use_cases/delete_asset_use_case.dart';
import '../assets/domain/use_cases/get_user_assets_use_case.dart';
import '../assets/domain/use_cases/update_asset_use_case.dart';

class WalletController extends GetxController with UIMessagesManager {
  final CreateAssetUseCase _createAssetUseCase;
  final GetUserAssetsUseCase _getUserAssetsUseCase;
  final UpdateAssetUseCase _updateAssetUseCase;
  final DeleteAssetUseCase _deleteAssetUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  WalletController(
    this._createAssetUseCase,
    this._getUserAssetsUseCase,
    this._updateAssetUseCase,
    this._deleteAssetUseCase,
    this._getCurrentUserUseCase,
  );

  final _assets = <AssetModel>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _searchQuery = ''.obs;

  List<AssetModel> get assets => _assets.toList();
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;

  List<AssetModel> get filteredAssets {
    final query = _searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return _assets.toList();
    return _assets.where((a) => a.name.toLowerCase().contains(query)).toList();
  }

  Map<String, List<AssetModel>> get assetsByType {
    final filtered = filteredAssets;
    final map = <String, List<AssetModel>>{};
    for (final asset in filtered) {
      map.putIfAbsent(asset.type, () => []).add(asset);
    }
    return map;
  }

  double get totalValue => _assets.fold(0.0, (sum, a) => sum + a.currentValue);

  double typeTotal(String type) {
    return _assets
        .where((a) => a.type == type)
        .fold(0.0, (sum, a) => sum + a.currentValue);
  }

  UserModel? _currentUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadCurrentUser();
    await loadAssets();
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _getCurrentUserUseCase.execute();
    } catch (e) {
      showError(message: 'Erro ao carregar usuário: $e');
    }
  }

  Future<void> loadAssets() async {
    _isLoading.value = true;
    _errorMessage.value = null;
    try {
      final userId = _currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado');
      final userAssets = await _getUserAssetsUseCase.execute(userId);
      _assets.assignAll(userAssets);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addAsset({
    required String name,
    required String type,
    required double currentValue,
    required int score,
  }) async {
    try {
      final userId = _currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado');
      final now = DateTime.now();
      final asset = AssetModel(
        userId: userId,
        name: name.trim(),
        type: type,
        percentage: 0,
        currentValue: currentValue,
        score: score,
        createdAt: now,
      );
      await _createAssetUseCase.execute(asset);
      await loadAssets();
    } catch (e) {
      showError(message: 'Erro ao adicionar ativo: $e');
    }
  }

  Future<void> updateAsset(AssetModel asset) async {
    try {
      await _updateAssetUseCase.execute(asset);
      await loadAssets();
    } catch (e) {
      showError(message: 'Erro ao atualizar ativo: $e');
    }
  }

  Future<void> deleteAsset(String id) async {
    try {
      await _deleteAssetUseCase.execute(id);
      _assets.removeWhere((a) => a.id == id);
    } catch (e) {
      showError(message: 'Erro ao remover ativo: $e');
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void clearError() {
    _errorMessage.value = null;
  }
}
