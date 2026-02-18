import 'package:get/get.dart';

import '../data/repository/signup_repository_impl.dart';
import '../domain/use_case/create_user_assets_use_case.dart';
import '../domain/use_case/create_user_use_case.dart';
import '../domain/use_case/register_use_case.dart';
import 'signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() {
      final respository = SignupRepositoryImpl();

      return SignupController(
        RegisterUseCase(respository),
        CreateUserUseCase(respository),
        CreateUserAssetsUseCase(respository),
      );
    });
  }
}
