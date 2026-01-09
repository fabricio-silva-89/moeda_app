import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/investment_model.dart';

class InvestmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String investmentsCollection = 'investments';

  /// Criar novo investimento
  Future<String> createInvestment(Investment investment) async {
    try {
      final docRef = await _firestore
          .collection(investmentsCollection)
          .add(investment.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar investimento: ${e.message}';
    }
  }

  /// Obter investimento por ID
  Future<Investment?> getInvestment(String id) async {
    try {
      final doc = await _firestore
          .collection(investmentsCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return Investment.fromMap(doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter investimento: ${e.message}';
    }
  }

  /// Obter todos os investimentos do usuário
  Future<List<Investment>> getUserInvestments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(investmentsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Investment.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter investimentos: ${e.message}';
    }
  }

  /// Obter stream de investimentos do usuário
  Stream<List<Investment>> getUserInvestmentsStream(String userId) {
    return _firestore
        .collection(investmentsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Investment.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Atualizar investimento
  Future<void> updateInvestment(Investment investment) async {
    try {
      await _firestore
          .collection(investmentsCollection)
          .doc(investment.id)
          .update({
            ...investment.toMap(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar investimento: ${e.message}';
    }
  }

  /// Deletar investimento
  Future<void> deleteInvestment(String id) async {
    try {
      await _firestore
          .collection(investmentsCollection)
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar investimento: ${e.message}';
    }
  }

  /// Atualizar porcentagem de um investimento
  Future<void> updateInvestmentPercentage(
    String investmentId,
    double percentage,
  ) async {
    try {
      await _firestore
          .collection(investmentsCollection)
          .doc(investmentId)
          .update({
            'percentage': percentage,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar porcentagem: ${e.message}';
    }
  }
}
