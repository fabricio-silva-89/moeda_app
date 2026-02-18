import '../params/create_user_assets_params.dart';
import '../repository/signup_repository.dart';

class CreateUserAssetsUseCase {
  final SignupRepository _repository;

  CreateUserAssetsUseCase(this._repository);

  Future<void> execute({required CreateUserAssetsParams params}) async {
    await _repository.createUserAssets(params: params);
  }
}
