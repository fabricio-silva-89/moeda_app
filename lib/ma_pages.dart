import 'package:get/get.dart';

import 'ma_routes.dart';
import 'modules/home/home_binding.dart';
import 'modules/home/home_screen.dart';
import 'modules/login/login_binding.dart';
import 'modules/login/login_screen.dart';
import 'modules/signup/signup_binding.dart';
import 'modules/signup/signup_screen.dart';

abstract class MaPages {
  static List<GetPage> pages = [
    GetPage(
      name: MaRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: MaRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: MaRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
