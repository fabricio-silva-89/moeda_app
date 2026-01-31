import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'ma_binding.dart';
import 'ma_pages.dart';
import 'ma_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Moeda App',
      getPages: MaPages.pages,
      initialRoute: MaRoutes.login,
      initialBinding: MaBinding(),
      navigatorKey: Get.key,
    );
  }
}
