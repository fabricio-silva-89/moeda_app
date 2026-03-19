import '../repositories/asset_repository.dart';

class DeleteAssetUseCase {
  final AssetRepository _repository;

  DeleteAssetUseCase(this._repository);

  Future<void> execute(String id) async {
    await _repository.deleteAsset(id);
  }
}
