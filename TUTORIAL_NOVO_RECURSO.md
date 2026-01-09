# 🎓 Tutorial: Adicionando um Novo Recurso

Este tutorial te guiará através de todas as etapas necessárias para adicionar um novo recurso ao Moeda App.

## Exemplo: Adicionar Recurso de "Metas de Investimento"

### Passo 1: Criar o Model

Arquivo: `lib/models/goal_model.dart`

```dart
class InvestmentGoal {
  final String id;
  final String userId;
  final String title;
  final String description;
  final InvestmentType type;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final DateTime createdAt;

  InvestmentGoal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdAt,
  });

  double get progress => (currentAmount / targetAmount) * 100;
  bool get isCompleted => currentAmount >= targetAmount;

  factory InvestmentGoal.fromMap(Map<String, dynamic> map, String id) {
    return InvestmentGoal(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: InvestmentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => InvestmentType.acoes,
      ),
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      targetDate: DateTime.parse(map['targetDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
```

### Passo 2: Criar o Service

Arquivo: `lib/services/goal_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal_model.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String goalsCollection = 'goals';

  /// Criar uma nova meta
  Future<String> createGoal(InvestmentGoal goal) async {
    try {
      final docRef = await _firestore
          .collection(goalsCollection)
          .add(goal.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar meta: ${e.message}';
    }
  }

  /// Obter todas as metas do usuário
  Future<List<InvestmentGoal>> getUserGoals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(goalsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => InvestmentGoal.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter metas: ${e.message}';
    }
  }

  /// Monitorar metas em tempo real
  Stream<List<InvestmentGoal>> getUserGoalsStream(String userId) {
    return _firestore
        .collection(goalsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InvestmentGoal.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Atualizar meta
  Future<void> updateGoal(InvestmentGoal goal) async {
    try {
      await _firestore
          .collection(goalsCollection)
          .doc(goal.id)
          .update(goal.toMap());
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar meta: ${e.message}';
    }
  }

  /// Deletar meta
  Future<void> deleteGoal(String id) async {
    try {
      await _firestore
          .collection(goalsCollection)
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar meta: ${e.message}';
    }
  }
}
```

### Passo 3: Criar o Controller

Arquivo: `lib/modules/investment_goals/investment_goals_controller.dart`

```dart
import 'package:flutter/material.dart';
import '../../models/goal_model.dart';
import '../../services/goal_service.dart';

class InvestmentGoalsController extends ChangeNotifier {
  final GoalService _goalService = GoalService();

  List<InvestmentGoal> _goals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<InvestmentGoal> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carregar metas do usuário
  Future<void> loadGoals(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _goals = await _goalService.getUserGoals(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Criar nova meta
  Future<bool> createGoal({
    required String userId,
    required String title,
    required String description,
    required InvestmentType type,
    required double targetAmount,
    required DateTime targetDate,
  }) async {
    try {
      final goal = InvestmentGoal(
        id: '',
        userId: userId,
        title: title,
        description: description,
        type: type,
        targetAmount: targetAmount,
        currentAmount: 0,
        targetDate: targetDate,
        createdAt: DateTime.now(),
      );

      await _goalService.createGoal(goal);
      await loadGoals(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Atualizar progresso da meta
  Future<bool> updateGoalProgress(
    InvestmentGoal goal,
    double newAmount,
  ) async {
    try {
      final updatedGoal = InvestmentGoal(
        id: goal.id,
        userId: goal.userId,
        title: goal.title,
        description: goal.description,
        type: goal.type,
        targetAmount: goal.targetAmount,
        currentAmount: newAmount,
        targetDate: goal.targetDate,
        createdAt: goal.createdAt,
      );

      await _goalService.updateGoal(updatedGoal);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Deletar meta
  Future<bool> deleteGoal(String userId, String goalId) async {
    try {
      await _goalService.deleteGoal(goalId);
      await loadGoals(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
```

### Passo 4: Criar a Tela (Widget)

Arquivo: `lib/modules/investment_goals/investment_goals_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import './investment_goals_controller.dart';

class InvestmentGoalsScreen extends StatefulWidget {
  const InvestmentGoalsScreen({super.key});

  @override
  State<InvestmentGoalsScreen> createState() => _InvestmentGoalsScreenState();
}

class _InvestmentGoalsScreenState extends State<InvestmentGoalsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authService = AuthService();
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        context.read<InvestmentGoalsController>().loadGoals(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvestmentGoalsController(),
      child: Consumer<InvestmentGoalsController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Metas de Investimento'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showCreateGoalDialog(context, controller),
                )
              ],
            ),
            body: _buildBody(controller),
          );
        },
      ),
    );
  }

  Widget _buildBody(InvestmentGoalsController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.target,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma meta criada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showCreateGoalDialog(context, controller),
              icon: const Icon(Icons.add),
              label: const Text('Criar Meta'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.goals.length,
      itemBuilder: (context, index) {
        final goal = controller.goals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (goal.isCompleted)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 8),
                Text(goal.description),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progress / 100,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${goal.progress.toStringAsFixed(1)}% - R\$ ${goal.currentAmount} / R\$ ${goal.targetAmount}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateGoalDialog(
    BuildContext context,
    InvestmentGoalsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Meta'),
        content: const SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Título'),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Valor Alvo'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meta criada com sucesso!')),
              );
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }
}
```

### Passo 5: Adicionar à Navegação

No `lib/modules/home/home_screen.dart`, adicione:

```dart
// No BottomNavigationBar:
BottomNavigationBarItem(
  icon: Icon(Icons.target),
  label: 'Metas',
),

// No _buildBody:
case 5:
  return const InvestmentGoalsScreen();
```

### Passo 6: Adicionar Firestore Rules

No Firebase Console, atualize as rules:

```javascript
match /goals/{document=**} {
  allow read, write: if request.auth != null;
}
```

## ✅ Checklist de Implementação

- [x] Model criado com `fromMap` e `toMap`
- [x] Service com operações CRUD
- [x] Controller com lógica de negócio
- [x] Tela com UI responsiva
- [x] Integração com navegação
- [x] Firestore rules configuradas
- [ ] Testes unitários
- [ ] Testes de widget
- [ ] Documentação adicional

## 🎯 Próximas Etapas

1. Adicionar testes automatizados
2. Implementar sinc com Backend em tempo real
3. Adicionar notificações quando meta é atingida
4. Implementar relatórios de progresso

---

Este padrão pode ser seguido para qualquer novo recurso no app!
