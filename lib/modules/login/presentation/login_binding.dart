import 'package:get/get.dart';

import '../data/repository/login_repository_impl.dart';
import '../domain/use_case/login_use_case.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() {
      return LoginController(LoginUseCase(LoginRepositoryImpl()));
    });
  }
}
