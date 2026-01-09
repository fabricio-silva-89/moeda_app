# 📱 Moeda App - Guia de Desenvolvimento

Um aplicativo Flutter para planejamento e acompanhamento de investimentos com integração Firebase.

## 🏗️ Arquitetura do Projeto

O projeto segue a arquitetura **MVC (Model-View-Controller)** com separação clara de responsabilidades:

```
lib/
├── main.dart                           # Ponto de entrada da aplicação
├── modules/                            # Telas e Controllers
│   ├── login/
│   │   ├── login_screen.dart          # Tela de Login
│   │   ├── login_controller.dart       # Controller do Login
│   │   ├── signup_screen.dart          # Tela de Cadastro
│   │   └── signup_controller.dart      # Controller do Cadastro
│   ├── home/
│   │   ├── home_screen.dart            # Tela Inicial (Dashboard)
│   │   └── home_controller.dart        # Controller da Tela Inicial
│   ├── contribution_config/
│   │   └── contribution_config_screen.dart  # Tela de Configuração de Contribuição
│   ├── stock_tracking/
│   │   └── stock_tracking_screen.dart       # Tela de Acompanhamento de Ações
│   ├── transaction_history/
│   │   └── transaction_history_screen.dart  # Tela de Histórico de Transações
│   └── settings/
│       └── settings_screen.dart              # Tela de Configurações
├── models/                             # Modelos de dados
│   ├── user_model.dart
│   ├── investment_model.dart
│   ├── stock_model.dart
│   ├── portfolio_model.dart
│   └── transaction_model.dart
├── services/                           # Serviços Firebase
│   ├── auth_service.dart               # Autenticação
│   ├── user_service.dart               # Gerenciamento de Usuários
│   ├── investment_service.dart         # Gerenciamento de Investimentos
│   ├── stock_service.dart              # Gerenciamento de Ações
│   ├── portfolio_service.dart          # Gerenciamento de Portfólio
│   └── transaction_service.dart        # Gerenciamento de Transações
├── widgets/                            # Componentes reutilizáveis
│   ├── portfolio_summary_widget.dart
│   ├── allocation_widget.dart
│   └── recent_transactions_widget.dart
├── constants/                          # Constantes da aplicação
├── pages/                              # Telas antigas (será descontinuado)
└── firebase_options.dart               # Configurações do Firebase

```

## 🔄 Fluxo MVC

### Models (Modelos)
Os modelos representam a estrutura dos dados da aplicação:
- `User` - Dados do usuário
- `Investment` - Investimentos por tipo (Renda Fixa, FIIs, Ações, BDRs)
- `Stock` - Ações individuais
- `Portfolio` - Portfólio consolidado
- `Transaction` - Histórico de transações

### Views (Telas)
As telas são StatefulWidgets/StatelessWidgets que apresentam os dados ao usuário:
- Exemplo: `LoginScreen` - Tela de login
- Usa `ChangeNotifierProvider` do package `provider` para reatividade

### Controllers
Os controllers gerenciam a lógica de negócio e estado:
- Estendem `ChangeNotifier` para notificar mudanças
- Lidam com operações Firebase
- Mantêm o estado da tela

Exemplo:
```dart
class LoginController extends ChangeNotifier {
  Future<bool> login({required String email, required String password}) async {
    // Lógica de login
    notifyListeners(); // Notifica a UI sobre mudanças
  }
}
```

## 🔧 Services (Serviços Firebase)

Cada `Service` encapsula operações com Firebase:

```dart
// auth_service.dart - Gerencia autenticação
final authService = AuthService();
await authService.login(email: 'user@example.com', password: 'senha');

// investment_service.dart - Gerencia investimentos
final investmentService = InvestmentService();
final investments = await investmentService.getUserInvestments(userId);

// portfolio_service.dart - Gerencia portfólio
final portfolioService = PortfolioService();
final portfolio = await portfolioService.getUserPortfolio(userId);
```

## 📚 Como Adicionar uma Nova Tela

### 1. Criar o Diretório do Módulo
```bash
mkdir lib/modules/nova_tela
```

### 2. Criar os Arquivos

**nova_tela_controller.dart:**
```dart
import 'package:flutter/material.dart';

class NovatelaController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Sua lógica aqui
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
```

**nova_tela_screen.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './nova_tela_controller.dart';

class NovatelaScreen extends StatefulWidget {
  const NovatelaScreen({super.key});

  @override
  State<NovatelaScreen> createState() => _NovatalaScreenState();
}

class _NovatalaScreenState extends State<NovatelaScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NovatelaController(),
      child: Consumer<NovatelaController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Nova Tela')),
            body: _buildBody(controller),
          );
        },
      ),
    );
  }

  Widget _buildBody(NovatelaController controller) {
    // Seu código aqui
    return const Center(child: Text('Nova Tela'));
  }
}
```

### 3. Adicionar Navegação
No `home_screen.dart`, adicione a nova tela ao BottomNavigationBar e ao `_buildBody`.

## 🚀 Próximos Passos (TODO)

- [ ] Implementar dashboard com gráficos usando `fl_chart`
- [ ] Adicionar integração com API de cotações de ações
- [ ] Implementar sistema de recomendações baseado em perfil de risco
- [ ] Adicionar notificações push
- [ ] Implementar sistema de backup e export de dados
- [ ] Melhorar validações de entrada
- [ ] Adicionar testes unitários e de widget
- [ ] Otimizar performance de carregamento
- [ ] Implementar offlineFirst com Hive/SQLite
- [ ] Adicionar themes escuro/claro

## 📦 Dependências Principais

- **firebase_core** ^3.2.0 - Núcleo do Firebase
- **firebase_auth** ^5.1.2 - Autenticação
- **cloud_firestore** ^5.1.0 - Banco de dados em tempo real
- **provider** ^6.1.0 - Gerenciamento de estado
- **intl** ^0.19.0 - Localização e formatação
- **fl_chart** ^0.65.0 - Gráficos

## 🔐 Segurança

### Firebase Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    match /investments/{document=**} {
      allow read, write: if request.auth != null;
    }
    match /stocks/{document=**} {
      allow read, write: if request.auth != null;
    }
    match /portfolios/{document=**} {
      allow read, write: if request.auth != null;
    }
    match /transactions/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🐛 Troubleshooting

### Erro: "Target of URI doesn't exist"
- Verifique se o caminho dos imports está correto
- Use paths relativos: `../` para subir um nível

### Erro: "Ambiguous name 'Transaction'"
- Use alias de import: `import '...' as alias;`
- Isso resolve conflitos com classes do Firebase

### Erro de compilação Android
```bash
fvm flutter clean
fvm flutter pub get
fvm flutter build apk --debug
```

## 📝 Convenções do Código

1. **Imports**: Organize em ordem (dart, package, projeto)
2. **Nomes**: Use camelCase para variáveis, PascalCase para classes
3. **Controllers**: Sempre estendem `ChangeNotifier`
4. **Services**: Métodos devem lançar exceções explícitas
5. **Models**: Incluir `fromMap` e `toMap` para Firebase

## 🔗 Recursos Úteis

- [Documentação Flutter](https://flutter.dev)
- [Firebase Flutter](https://firebase.flutter.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Firestore Docs](https://firebase.google.com/docs/firestore)

## 📞 Suporte

Se tiver dúvidas durante o desenvolvimento, consulte:
1. Este guia
2. Os arquivos existentes (servem como exemplos)
3. A documentação oficial do Flutter e Firebase
