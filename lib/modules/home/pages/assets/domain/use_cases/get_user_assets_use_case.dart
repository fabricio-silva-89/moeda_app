import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';

class GetUserAssetsUseCase {
  final AssetRepository _repository;

  GetUserAssetsUseCase(this._repository);

  Future<List<AssetModel>> execute(String userId) async {
    return await _repository.getUserAssets(userId);
  }
}
