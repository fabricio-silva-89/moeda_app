import '../repository/login_repository.dart';

class LoginUseCase {
  final LoginRepository _repository;

  LoginUseCase(this._repository);

  Future<String?> execute(String email, String password) {
    return _repository.login(email, password);
  }
}
