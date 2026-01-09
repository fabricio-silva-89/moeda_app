# 🎯 Roteiro de Implementação - Próximas Features

## Fase 1: Melhorias no Dashboard (Semana 1-2)

### ✅ Tela Home Inicial
- [x] Resumo do Portfólio
- [x] Alocação por tipo de investimento
- [x] Transações recentes
- [ ] Gráfico de evolução do portfólio
- [ ] Notícias/Insights do mercado

**Implementação:**
```dart
// Adicionar fl_chart ao home_screen.dart
import 'package:fl_chart/fl_chart.dart';

// Criar widget para o gráfico
class PortfolioChartWidget extends StatelessWidget {
  final List<double> monthlyValues;
  
  const PortfolioChartWidget({required this.monthlyValues});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: LineChart(
        LineChartData(
          // Configurar dados do gráfico
        ),
      ),
    );
  }
}
```

## Fase 2: Sistema de Contribuições (Semana 2-3)

### Tela de Configuração de Contribuição
- [ ] Salvar configurações no Firestore
- [ ] Simulação em tempo real
- [ ] Histórico de configurações
- [ ] Sugestões baseadas no histórico

**Controllers:**
```dart
// contribution_config_controller.dart
class ContributionConfigController extends ChangeNotifier {
  final InvestmentService _investmentService = InvestmentService();
  
  Map<InvestmentType, double> _percentages = {};
  
  Future<void> saveConfiguration(String userId, Map<InvestmentType, double> percentages) async {
    // Salvar no Firestore
  }
  
  Future<Map<String, double>> simulateContribution(
    double amount,
    Map<InvestmentType, double> percentages,
  ) async {
    // Calcular distribuição
    return {
      'rendalixo': amount * (percentages[InvestmentType.rendalixo] ?? 0) / 100,
      'fiis': amount * (percentages[InvestmentType.fiis] ?? 0) / 100,
      // ...
    };
  }
}
```

## Fase 3: Acompanhamento de Ações (Semana 3-4)

### Tela de Ações
- [ ] Listar ações do usuário com dados em tempo real
- [ ] Filtrar por setor
- [ ] Detalhes individuais de cada ação
- [ ] Gráfico de evolução de preço
- [ ] Ajuste de porcentagem de alocação

**Services:**
```dart
// stock_service.dart - Adicionar métodos
class StockService {
  /// Obter ações agrupadas por setor
  Future<Map<String, List<Stock>>> getStocksByUserGroupedBySector(String userId) async {
    final stocks = await getUserStocks(userId);
    final grouped = <String, List<Stock>>{};
    
    for (var stock in stocks) {
      grouped.putIfAbsent(stock.sector, () => []).add(stock);
    }
    
    return grouped;
  }
}
```

## Fase 4: Análise e Relatórios (Semana 4-5)

### Features Avançadas
- [ ] Relatórios mensais/anuais
- [ ] Análise de performance
- [ ] Comparação com índices (IBOVESPA, etc)
- [ ] Exportar relatórios em PDF

```dart
// analytics_service.dart (novo)
class AnalyticsService {
  Future<PortfolioReport> generateMonthlyReport(
    String userId,
    DateTime month,
  ) async {
    // Gerar relatório consolidado
  }
}
```

## Fase 5: Integração com APIs Externas (Semana 5-6)

### Cotações em Tempo Real
- [ ] Integrar com API de ações (exemplo: Alpha Vantage, Finnhub)
- [ ] Atualizar cotações automaticamente
- [ ] Notificações de alertas de preço

```dart
// stock_api_service.dart (novo)
class StockApiService {
  final String _apiKey = 'YOUR_API_KEY';
  
  Future<double> getCurrentPrice(String ticker) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/quote/$ticker'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['price'].toDouble();
    }
    
    throw Exception('Erro ao buscar cotação');
  }
}
```

## Fase 6: Melhorias na UX (Semana 6-7)

### Design e Experiência
- [ ] Implementar tema escuro/claro
- [ ] Animações suaves
- [ ] Skeleton loaders
- [ ] Pull-to-refresh

```dart
// theme_service.dart (novo)
class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
      ? ThemeMode.dark 
      : ThemeMode.light;
    notifyListeners();
  }
}
```

## Fase 7: Testes (Semana 7-8)

### Cobertura de Testes
- [ ] Testes unitários dos controllers
- [ ] Testes de widgets
- [ ] Testes de integração

```dart
// test/modules/home/home_controller_test.dart
void main() {
  group('HomeController', () {
    late HomeController controller;
    
    setUp(() {
      controller = HomeController();
    });
    
    test('deve carregar portfólio com sucesso', () async {
      // Arrange
      final userId = 'test-user-id';
      
      // Act
      await controller.loadPortfolioData(userId);
      
      // Assert
      expect(controller.portfolio, isNotNull);
      expect(controller.isLoading, false);
    });
  });
}
```

## 🎯 Checklist de Desenvolvimento

### Antes de cada commit:
- [ ] Código segue as convenções do projeto
- [ ] Não há erros de análise (`flutter analyze`)
- [ ] Testes passam (se aplicável)
- [ ] Mensagem de commit é descritiva

### Antes de cada PR:
- [ ] Features completamente implementadas
- [ ] Documentação atualizada
- [ ] Sem debug prints no código
- [ ] Teste manual em diferentes dispositivos

## 📊 Métricas de Sucesso

| Métrica | Objetivo | Atual |
|---------|----------|-------|
| Taxa de cobertura de testes | > 80% | 0% |
| Performance (FPS) | > 60 | N/A |
| Tamanho do APK | < 50MB | N/A |
| Tempo de startup | < 2s | N/A |

## 🐛 Bugs Conhecidos

- [ ] Nenhum no momento

## 📝 Notas

- Usar sempre imports com alias para evitar conflitos
- Manter Controllers leves, delegue lógica complexa para Services
- Adicione documentação para métodos públicos
- Use comentarios para código complexo
