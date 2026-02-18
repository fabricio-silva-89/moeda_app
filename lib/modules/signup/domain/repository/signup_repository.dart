import '../params/create_user_assets_params.dart';
import '../params/create_user_params.dart';
import '../params/register_params.dart';

abstract interface class SignupRepository {
  Future<String?> register({required RegisterParams params});
  Future<void> createUserAssets({required CreateUserAssetsParams params});
  Future<void> createUser({required CreateUserParams params});
}
