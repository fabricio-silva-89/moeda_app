import '../../../../core/domain/models/user_model.dart';
import '../repository/login_repository.dart';

class GetUserUseCase {
  final LoginRepository _repository;

  GetUserUseCase(this._repository);

  Future<UserModel?> execute(String id) {
    return _repository.getUser(id);
  }
}
