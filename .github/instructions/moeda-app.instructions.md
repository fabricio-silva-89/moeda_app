---
description: Use este arquivo para fornecer instruções específicas para o agente sobre como lidar com tarefas relacionadas a este projeto. Essas instruções serão carregadas automaticamente quando o agente estiver processando tarefas que correspondam ao padrão definido em `applyTo`.
applyTo: '**'
---

<!-- Tip: Use /create-instructions in chat to generate content with agent assistance -->

# Moeda App — Copilot Instructions

## Sobre o Projeto

Aplicativo Flutter para orientação de investimentos. O usuário configura seus ativos (CDB, LCI/LCA, VISC11, ITUB4 etc.), agrupados por tipo de investimento (Renda Fixa, FIIs, Ações etc.), ajusta pontuações e metas de alocação. Ao inserir o valor da contribuição mensal, o app calcula quanto investir em cada ativo para alinhar a carteira com as porcentagens configuradas.

## Stack

- **Flutter** com **GetX** (state management, DI, routing)
- **Firebase** (Auth + Cloud Firestore)
- **Dart 3+** com null safety
- Linguagem do app: **Português brasileiro**

## Arquitetura — Clean Architecture + GetX

Cada módulo em `lib/modules/` representa uma tela/feature do app e segue a estrutura:

```
lib/modules/{modulo}/
├── presentation/
│   ├── {modulo}_screen.dart        # Widget da tela (GetView<Controller>)
│   ├── {modulo}_controller.dart    # GetxController com estado reativo (.obs)
│   ├── {modulo}_binding.dart       # Bindings de DI do módulo
│   └── components/                 # Componentes exclusivos do módulo (opcional)
├── domain/
│   ├── repository/                 # Interface abstrata do repositório
│   │   └── {modulo}_repository.dart
│   ├── use_case/                   # Casos de uso (1 ação = 1 classe)
│   │   └── {acao}_use_case.dart
│   ├── params/                     # Classes de parâmetros para use cases (opcional)
│   │   └── {acao}_params.dart
│   └── models/                     # Modelos de domínio (opcional)
│       └── {entidade}_model.dart
└── data/
    ├── repository/                 # Implementação concreta do repositório
    │   └── {modulo}_repository_impl.dart
    └── params/                     # Parâmetros de data layer (opcional)
```

### Recursos compartilhados

| O que | Onde |
|-------|------|
| Models compartilhados | `lib/core/domain/models/` |
| Use cases compartilhados | `lib/core/domain/use_cases/` |
| Repositórios compartilhados | `lib/core/domain/` |
| Extensions | `lib/core/extensions/` |
| Utilitários / constantes | `lib/core/utils/` |
| Componentes de UI compartilhados | `lib/ui/components/` |
| Tema e cores | `lib/ui/theme/` |
| Helpers de UI (mixins) | `lib/ui/helpers/` |

## Convenções de Código

### Nomenclatura

| Entidade | Padrão | Exemplo |
|----------|--------|---------|
| Arquivos | `snake_case` | `login_screen.dart` |
| Classes | `PascalCase` | `LoginScreen` |
| Variáveis privadas | `_prefixo` | `_isLoading`, `_auth` |
| Constantes/rotas | `camelCase` com prefixo `Ma` | `MaRoutes`, `MaColors` |
| Use cases | `{Ação}UseCase` | `LoginUseCase`, `GetUserAssetsUseCase` |
| Repositórios abstratos | `{Entidade}Repository` | `LoginRepository` |
| Repositórios concretos | `{Entidade}RepositoryImpl` | `LoginRepositoryImpl` |
| Controllers | `{Modulo}Controller` | `LoginController` |
| Bindings | `{Modulo}Binding` | `LoginBinding` |
| Models | `{Entidade}Model` | `UserModel`, `AssetModel` |
| Params | `{Ação}Params` | `RegisterParams`, `CreateUserParams` |
| Screens | `{Modulo}Screen` | `LoginScreen` |

### Padrão de Repositório

```dart
// domain/repository/{modulo}_repository.dart — Interface
abstract interface class LoginRepository {
  Future<String?> login(String email, String password);
}

// data/repository/{modulo}_repository_impl.dart — Implementação
class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  LoginRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth, _firestore = firestore;

  @override
  Future<String?> login(String email, String password) async {
    // Implementação com Firebase
  }
}
```

### Padrão de Use Case

```dart
class LoginUseCase {
  final LoginRepository _repository;

  LoginUseCase({required LoginRepository repository})
      : _repository = repository;

  Future<String?> execute(String email, String password) =>
      _repository.login(email, password);
}
```

### Padrão de Controller (GetX)

```dart
class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;

  LoginController({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase;

  // Estado reativo
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;

  Future<bool> login(String email, String password) async {
    _isLoading.value = true;
    _errorMessage.value = null;
    try {
      final userId = await _loginUseCase.execute(email, password);
      return userId != null;
    } on Exception catch (e) {
      _errorMessage.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
```

### Padrão de Screen (GetView)

```dart
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Widgets reativos com Obx
      }),
    );
  }
}
```

### Padrão de Binding

```dart
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(
      loginUseCase: Get.find(),
    ));
  }
}
```

### Padrão de Model (Firestore)

```dart
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final String createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({String? name, String? photoUrl}) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}
```

## Registro de Rotas e DI

### Rotas (`lib/ma_routes.dart`)

```dart
abstract class MaRoutes {
  static const String home = '/';
  static const String login = '/login';
  // Novas rotas seguem o mesmo padrão
}
```

### Páginas (`lib/ma_pages.dart`)

```dart
abstract class MaPages {
  static List<GetPage> pages = [
    GetPage(
      name: MaRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
  ];
}
```

### DI Global (`lib/ma_binding.dart`)

Repositórios e use cases são registrados no `MaBinding` (root). Controllers são registrados nos bindings dos módulos.

## Tema e UI

### Acesso a cores e tema via extension

```dart
context.colors.primary    // ColorScheme (light/dark automático)
context.colors.error
context.isDark            // Verifica se é dark mode
context.theme             // ThemeData
context.text              // TextTheme
```

### Helpers disponíveis (mixins)

```dart
// Em controllers ou widgets que usem UIMessagesManager:
showMessage(message: 'Sucesso!');
showError(message: 'Erro!');
showModalInfo(title: '...', message: '...');
showModalQuestion(message: '...', onPressedYes: () {});
```

## Firebase

### Coleções (constantes em `lib/core/utils/firebase_collections.dart`)

- `users` — Documento ID = UID do usuário
- `assets` — Documentos com campo `userId` para associar ao usuário

### Tratamento de erros

Usar extensions em `lib/core/extensions/` para mapear exceções do Firebase em mensagens legíveis em português.

## Regras Gerais

1. **Idioma**: código (variáveis, classes, funções) em **inglês**, strings voltadas ao usuário em **português**
2. **1 use case = 1 ação**: cada use case tem um método `execute()` que faz uma única coisa
3. **Repositório abstrato no domain, implementação no data**: nunca importar Firebase no domain/presentation
4. **Estado reativo**: usar `.obs` e `Obx()` — não usar `setState`
5. **DI com GetX**: repositórios e use cases no `MaBinding`, controllers nos bindings dos módulos
6. **Null safety**: sempre tipar corretamente, usar `Rxn<T>` para valores opcionais reativos
7. **Não usar `dynamic`**: sempre tipar explicitamente
8. **Navegação**: usar `MaNavigation.navigate()`, `.push()`, `.pop()`
9. **Novos módulos**: seguir exatamente a estrutura de pastas documentada acima
10. **Componentes reutilizáveis**: em `lib/ui/components/`, não dentro de módulos
