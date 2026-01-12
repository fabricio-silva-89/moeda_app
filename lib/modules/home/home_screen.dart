import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../widgets/allocation_widget.dart';
import '../../widgets/portfolio_summary_widget.dart';
import '../../widgets/recent_transactions_widget.dart';
import '../contribution_config/contribution_config_screen.dart';
import '../home/home_controller.dart';
import '../login/login_screen.dart';
import '../settings/settings_screen.dart';
import '../stock_tracking/stock_tracking_screen.dart';
import '../transaction_history/transaction_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authService = AuthService();
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        final controller = context.read<HomeController>();
        controller.createInitialPortfolio(userId);
        controller.loadPortfolioData(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Consumer<HomeController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Moeda App'),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _handleLogout,
                )
              ],
            ),
            body: _buildBody(controller),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.percent),
                  label: 'Contribuição',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up),
                  label: 'Ações',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Histórico',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Config',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeController controller) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab(controller);
      case 1:
        return const ContributionConfigScreen();
      case 2:
        return const StockTrackingScreen();
      case 3:
        return const TransactionHistoryScreen();
      case 4:
        return const SettingsScreen();
      default:
        return _buildHomeTab(controller);
    }
  }

  Widget _buildHomeTab(HomeController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar dados',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final authService = AuthService();
                final userId = authService.currentUser?.uid;
                if (userId != null) {
                  controller.loadPortfolioData(userId);
                }
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (controller.portfolio != null)
            PortfolioSummaryWidget(
              totalInvested: controller.portfolio!.totalInvested,
              currentValue: controller.portfolio!.currentValue,
              returnPercentage: controller.portfolio!.returnPercentage,
            ),
          if (controller.portfolio != null &&
              controller.portfolio!.allocationPercentages.isNotEmpty)
            AllocationWidget(
              allocations: controller.portfolio!.allocationPercentages,
            ),
          if (controller.recentTransactions.isNotEmpty)
            RecentTransactionsWidget(
              transactions: controller.recentTransactions,
            ),
          if (controller.portfolio == null && !controller.isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum portfólio criado',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comece criando um novo portfólio para acompanhar seus investimentos',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
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
        final authService = AuthService();
        await authService.logout();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao fazer logout: $e')),
          );
        }
      }
    }
  }
}
