import '../params/register_params.dart';
import '../repository/signup_repository.dart';

class RegisterUseCase {
  final SignupRepository _repository;

  RegisterUseCase(this._repository);

  Future<String?> execute({required RegisterParams params}) {
    return _repository.register(params: params);
  }
}
