import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';

class CreateAssetUseCase {
  final AssetRepository _repository;

  CreateAssetUseCase(this._repository);

  Future<String> execute(AssetModel asset) async {
    return await _repository.createAsset(asset);
  }
}
