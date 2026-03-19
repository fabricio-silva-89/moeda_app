import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/domain/use_cases/logout_use_case.dart';
import '../../ma_routes.dart';
import 'pages/assets/assets_page.dart';
import 'pages/contribuition/contribution_page.dart';
import 'pages/wallet/wallet_page.dart';

class HomeController extends GetxController {
  final LogoutUseCase _logoutUseCase;

  HomeController(this._logoutUseCase);

  final pages = [
    const WalletPage(),
    const AssetsPage(),
    const ContributionScreen(),
  ];

  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fazer Logout'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim, sair'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _logoutUseCase.execute();
        Get.offAllNamed(MaRoutes.login);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer logout: $e')),
        );
      }
    }
  }
}
