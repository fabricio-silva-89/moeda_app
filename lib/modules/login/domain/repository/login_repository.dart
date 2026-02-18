import '../../../../models/user_model.dart';

abstract interface class LoginRepository {
  Future<String?> login(String email, String password);
  Future<UserModel?> getUser(String uuid);
}
