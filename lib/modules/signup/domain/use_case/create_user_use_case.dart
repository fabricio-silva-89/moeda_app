import '../params/create_user_params.dart';
import '../repository/signup_repository.dart';

class CreateUserUseCase {
  final SignupRepository _repository;

  CreateUserUseCase(this._repository);

  Future<void> execute({required CreateUserParams params}) {
    return _repository.createUser(params: params);
  }
}
