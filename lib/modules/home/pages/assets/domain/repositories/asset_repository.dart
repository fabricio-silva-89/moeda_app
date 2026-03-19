import '../models/asset_model.dart';

abstract interface class AssetRepository {
  Future<String> createAsset(AssetModel asset);
  Future<AssetModel?> getAsset(String id);
  Future<List<AssetModel>> getUserAssets(String userId);
  Stream<List<AssetModel>> getUserAssetsStream(String userId);
  Future<void> updateAsset(AssetModel asset);
  Future<void> deleteAsset(String id);
}
