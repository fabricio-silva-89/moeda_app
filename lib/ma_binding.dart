import 'package:get/get.dart';

import 'services/asset_service.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';

class MaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<UserService>(UserService(), permanent: true);
    Get.put<AssetService>(AssetService(), permanent: true);
  }
}
