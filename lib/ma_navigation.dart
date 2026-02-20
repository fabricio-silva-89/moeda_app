import 'package:get/get.dart';

class MaNavigation {
  MaNavigation._();

  static void navigate({required String route, dynamic args}) {
    Get.offNamed(route, arguments: args);
  }

  static Future<dynamic>? push({
    required String route,
    String? path,
    dynamic args,
  }) {
    return Get.toNamed(route, arguments: args);
  }

  static void pop([dynamic result]) {
    Get.back(result: result);
  }
}
