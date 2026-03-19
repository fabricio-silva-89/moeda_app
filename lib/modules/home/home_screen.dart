import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.pages,
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Carteira',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: 'Ativos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Aporte',
            ),
          ],
        );
      }),
    );
  }
}
