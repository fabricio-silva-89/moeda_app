# 📚 Exemplos de Uso dos Services

## AuthService - Autenticação

### Login
```dart
final authService = AuthService();

try {
  final user = await authService.login(
    email: 'user@example.com',
    password: 'senha123',
  );
  print('Usuário logado: ${user?.email}');
} catch (e) {
  print('Erro: $e');
}
```

### Registrar novo usuário
```dart
final authService = AuthService();

try {
  final user = await authService.register(
    email: 'novo@example.com',
    password: 'senha123',
    name: 'João Silva',
  );
  print('Usuário registrado: ${user?.displayName}');
} catch (e) {
  print('Erro: $e');
}
```

### Fazer Logout
```dart
final authService = AuthService();
await authService.logout();
```

### Monitorar estado de autenticação
```dart
final authService = AuthService();

authService.authStateChanges.listen((user) {
  if (user != null) {
    print('Usuário logado: ${user.email}');
  } else {
    print('Usuário deslogado');
  }
});
```

## UserService - Gerenciamento de Usuários

### Criar usuário no Firestore
```dart
final userService = UserService();
final user = User(
  uid: 'uid-123',
  email: 'user@example.com',
  name: 'João Silva',
  createdAt: DateTime.now(),
);

await userService.createUser(user);
```

### Obter dados do usuário
```dart
final userService = UserService();
final user = await userService.getUser('uid-123');

if (user != null) {
  print('Nome: ${user.name}');
  print('Email: ${user.email}');
}
```

### Atualizar perfil
```dart
final userService = UserService();
final user = User(
  uid: 'uid-123',
  email: 'novo@example.com',
  name: 'João Atualizado',
  createdAt: DateTime.now(),
);

await userService.updateUser(user);
```

### Monitorar perfil em tempo real
```dart
final userService = UserService();

userService.getUserStream('uid-123').listen((user) {
  if (user != null) {
    print('Perfil atualizado: ${user.name}');
  }
});
```

## InvestmentService - Gerenciamento de Investimentos

### Criar investimento
```dart
final investmentService = InvestmentService();
final investment = Investment(
  id: '',
  userId: 'uid-123',
  type: InvestmentType.acoes,
  percentage: 35.0,
  currentValue: 10000.0,
  initialValue: 8000.0,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final id = await investmentService.createInvestment(investment);
print('Investimento criado: $id');
```

### Obter investimentos do usuário
```dart
final investmentService = InvestmentService();
final investments = await investmentService.getUserInvestments('uid-123');

for (var inv in investments) {
  print('${inv.type.displayName}: R\$ ${inv.currentValue}');
}
```

### Atualizar porcentagem de investimento
```dart
final investmentService = InvestmentService();
await investmentService.updateInvestmentPercentage('investment-id', 40.0);
```

### Monitorar investimentos em tempo real
```dart
final investmentService = InvestmentService();

investmentService.getUserInvestmentsStream('uid-123').listen((investments) {
  print('Total de investimentos: ${investments.length}');
});
```

## StockService - Gerenciamento de Ações

### Adicionar uma ação
```dart
final stockService = StockService();
final stock = Stock(
  id: '',
  userId: 'uid-123',
  ticker: 'PETR4',
  name: 'Petróleo Brasileiro S.A.',
  sector: 'Energia',
  isPreferred: false,
  averageCost: 25.50,
  currentPrice: 28.00,
  quantity: 100,
  percentage: 10.0,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final id = await stockService.createStock(stock);
print('Ação adicionada: $id');
```

### Listar todas as ações
```dart
final stockService = StockService();
final stocks = await stockService.getUserStocks('uid-123');

for (var stock in stocks) {
  print('${stock.ticker}: Retorno ${stock.returnPercentage.toStringAsFixed(2)}%');
}
```

### Atualizar preço da ação
```dart
final stockService = StockService();
await stockService.updateStockPrice('stock-id', 29.50);
```

### Filtrar por setor
```dart
final stockService = StockService();
final energyStocks = await stockService.getStocksBySector('uid-123', 'Energia');

print('Ações do setor Energia: ${energyStocks.length}');
```

### Monitorar ações em tempo real
```dart
final stockService = StockService();

stockService.getUserStocksStream('uid-123').listen((stocks) {
  final totalValue = stocks.fold<double>(0, (sum, stock) => sum + stock.totalCurrentValue);
  print('Valor total em ações: R\$ $totalValue');
});
```

## PortfolioService - Gerenciamento de Portfólio

### Criar portfólio inicial
```dart
final portfolioService = PortfolioService();
final portfolio = Portfolio(
  id: '',
  userId: 'uid-123',
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

final id = await portfolioService.createPortfolio(portfolio);
```

### Obter portfólio do usuário
```dart
final portfolioService = PortfolioService();
final portfolio = await portfolioService.getUserPortfolio('uid-123');

if (portfolio != null) {
  print('Valor total: R\$ ${portfolio.currentValue}');
  print('Retorno: ${portfolio.returnPercentage.toStringAsFixed(2)}%');
}
```

### Atualizar valores do portfólio
```dart
final portfolioService = PortfolioService();
await portfolioService.updatePortfolioValues(
  'portfolio-id',
  totalInvested: 50000,
  currentValue: 65000,
);
```

### Monitorar portfólio em tempo real
```dart
final portfolioService = PortfolioService();

portfolioService.getUserPortfolioStream('uid-123').listen((portfolio) {
  if (portfolio != null) {
    print('Portfólio atualizado!');
    print('Valor: R\$ ${portfolio.currentValue}');
  }
});
```

## TransactionService - Histórico de Transações

### Registrar uma contribuição
```dart
final transactionService = TransactionService();
final transaction = Transaction(
  id: '',
  userId: 'uid-123',
  type: TransactionType.contribution,
  investmentType: 'Ações',
  amount: 1000.0,
  date: DateTime.now(),
  notes: 'Contribuição mensal',
);

final id = await transactionService.createTransaction(transaction);
```

### Obter histórico de transações
```dart
final transactionService = TransactionService();
final transactions = await transactionService.getUserTransactions('uid-123');

for (var tx in transactions) {
  print('${tx.type.displayName}: R\$ ${tx.amount}');
}
```

### Filtrar por tipo de investimento
```dart
final transactionService = TransactionService();
final stockTransactions = await transactionService.getTransactionsByType(
  'uid-123',
  'Ações',
);

print('Transações em ações: ${stockTransactions.length}');
```

### Filtrar por período
```dart
final transactionService = TransactionService();
final startDate = DateTime(2024, 1, 1);
final endDate = DateTime(2024, 1, 31);

final transactions = await transactionService.getTransactionsByDateRange(
  'uid-123',
  startDate,
  endDate,
);

print('Transações em janeiro: ${transactions.length}');
```

### Monitorar transações em tempo real
```dart
final transactionService = TransactionService();

transactionService.getUserTransactionsStream('uid-123').listen((transactions) {
  final totalContributed = transactions
    .where((tx) => tx.type == TransactionType.contribution)
    .fold<double>(0, (sum, tx) => sum + tx.amount);
  
  print('Total contribuído: R\$ $totalContributed');
});
```

## Exemplo Completo: Atualizar Portfólio com uma Contribuição

```dart
class ContributionController extends ChangeNotifier {
  final InvestmentService _investmentService = InvestmentService();
  final PortfolioService _portfolioService = PortfolioService();
  final TransactionService _transactionService = TransactionService();

  Future<void> contributeAmount(
    String userId,
    double amount,
    Map<InvestmentType, double> percentages,
  ) async {
    try {
      // 1. Registrar a transação
      for (var entry in percentages.entries) {
        final transactionAmount = amount * (entry.value / 100);
        
        await _transactionService.createTransaction(
          Transaction(
            id: '',
            userId: userId,
            type: TransactionType.contribution,
            investmentType: entry.key.displayName,
            amount: transactionAmount,
            date: DateTime.now(),
          ),
        );
      }

      // 2. Atualizar investimentos
      final investments = await _investmentService.getUserInvestments(userId);
      
      for (var investment in investments) {
        if (percentages.containsKey(investment.type)) {
          final contributionAmount = amount * (percentages[investment.type]! / 100);
          final newValue = investment.currentValue + contributionAmount;
          
          await _investmentService.updateInvestment(
            investment.copyWith(
              currentValue: newValue,
              updatedAt: DateTime.now(),
            ),
          );
        }
      }

      // 3. Atualizar portfólio
      final portfolio = await _portfolioService.getUserPortfolio(userId);
      
      if (portfolio != null) {
        final newTotal = portfolio.totalInvested + amount;
        final newValue = portfolio.currentValue + amount;
        
        await _portfolioService.updatePortfolioValues(
          portfolio.id,
          totalInvested: newTotal,
          currentValue: newValue,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao registrar contribuição: $e');
      rethrow;
    }
  }
}
```

## ✅ Boas Práticas

1. **Sempre trate exceções** nas chamadas dos services
2. **Use Streams** para dados que mudam frequentemente
3. **Cache dados localmente** quando apropriado
4. **Valide dados** antes de enviar ao Firestore
5. **Use aliases** para evitar conflitos de nomes
6. **Documente** métodos públicos dos services
