import 'package:flutter/material.dart';

import '../../models/investment_model.dart';
import '../../models/portfolio_model.dart';
import '../../models/stock_model.dart';
import '../../models/transaction_model.dart' as transaction_model;
import '../../services/investment_service.dart';
import '../../services/portfolio_service.dart';
import '../../services/stock_service.dart';
import '../../services/transaction_service.dart';

class HomeController extends ChangeNotifier {
  final InvestmentService _investmentService = InvestmentService();
  final StockService _stockService = StockService();
  final PortfolioService _portfolioService = PortfolioService();
  final TransactionService _transactionService = TransactionService();

  Portfolio? _portfolio;
  List<Investment> _investments = [];
  List<Stock> _stocks = [];
  List<transaction_model.Transaction> _recentTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  Portfolio? get portfolio => _portfolio;
  List<Investment> get investments => _investments;
  List<Stock> get stocks => _stocks;
  List<transaction_model.Transaction> get recentTransactions =>
      _recentTransactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carregar dados do portfólio
  Future<void> loadPortfolioData(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final portfolio = await _portfolioService.getUserPortfolio(userId);
      final investments = await _investmentService.getUserInvestments(userId);
      final stocks = await _stockService.getUserStocks(userId);
      final transactions =
          await _transactionService.getUserTransactions(userId);

      _portfolio = portfolio;
      _investments = investments;
      _stocks = stocks;
      _recentTransactions =
          transactions.length > 5 ? transactions.sublist(0, 5) : transactions;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Criar portfólio inicial (se não existir)
  Future<void> createInitialPortfolio(String userId) async {
    try {
      final existingPortfolio =
          await _portfolioService.getUserPortfolio(userId);

      if (existingPortfolio == null) {
        final newPortfolio = Portfolio(
          id: '',
          userId: userId,
          totalInvested: 0,
          currentValue: 0,
          allocationPercentages: {
            InvestmentType.rendalixo: 25,
            InvestmentType.fiis: 25,
            InvestmentType.acoes: 35,
            InvestmentType.bdrs: 15,
          },
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _portfolioService.createPortfolio(newPortfolio);
        await loadPortfolioData(userId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Limpar erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
