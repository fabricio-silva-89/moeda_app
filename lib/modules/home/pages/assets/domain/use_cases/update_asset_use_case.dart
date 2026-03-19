import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';

class UpdateAssetUseCase {
  final AssetRepository _repository;

  UpdateAssetUseCase(this._repository);

  Future<void> execute(AssetModel asset) async {
    await _repository.updateAsset(asset);
  }
}
