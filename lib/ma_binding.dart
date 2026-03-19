import 'package:get/get.dart';

import 'core/domain/use_cases/get_current_user_use_case.dart';
import 'core/domain/use_cases/logout_use_case.dart';
import 'modules/home/pages/assets/data/repositories/asset_repository_impl.dart';
import 'modules/home/pages/assets/domain/repositories/asset_repository.dart';
import 'modules/home/pages/assets/domain/use_cases/create_asset_use_case.dart';
import 'modules/home/pages/assets/domain/use_cases/delete_asset_use_case.dart';
import 'modules/home/pages/assets/domain/use_cases/get_user_assets_use_case.dart';
import 'modules/home/pages/assets/domain/use_cases/update_asset_use_case.dart';
import 'modules/login/data/repository/login_repository_impl.dart';
import 'modules/login/domain/repository/login_repository.dart';
import 'modules/login/domain/use_case/get_user_use_case.dart';
import 'modules/login/domain/use_case/login_use_case.dart';
import 'modules/signup/data/repository/signup_repository_impl.dart';
import 'modules/signup/domain/repository/signup_repository.dart';
import 'modules/signup/domain/use_case/create_user_assets_use_case.dart';
import 'modules/signup/domain/use_case/create_user_use_case.dart';
import 'modules/signup/domain/use_case/register_use_case.dart';

class MaBinding extends Bindings {
  @override
  void dependencies() {
    _registerRepositories();
    _registerUseCases();
  }

  void _registerRepositories() {
    Get.put<AssetRepository>(AssetRepositoryImpl());
    Get.put<LoginRepository>(LoginRepositoryImpl());
    Get.put<SignupRepository>(SignupRepositoryImpl());
  }

  void _registerUseCases() {
    Get.put(CreateAssetUseCase(Get.find()));
    Get.put(GetUserAssetsUseCase(Get.find()));
    Get.put(UpdateAssetUseCase(Get.find()));
    Get.put(DeleteAssetUseCase(Get.find()));
    Get.put(GetUserUseCase(Get.find()));
    Get.put(LoginUseCase(Get.find()));
    Get.put(RegisterUseCase(Get.find()));
    Get.put(CreateUserUseCase(Get.find()));
    Get.put(CreateUserAssetsUseCase(Get.find()));
    Get.put(GetCurrentUserUseCase());
    Get.put(LogoutUseCase());
  }
}
