import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/portfolio_model.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String portfoliosCollection = 'portfolios';

  /// Criar novo portfólio
  Future<String> createPortfolio(Portfolio portfolio) async {
    try {
      final docRef = await _firestore
          .collection(portfoliosCollection)
          .add(portfolio.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar portfólio: ${e.message}';
    }
  }

  /// Obter portfólio do usuário
  Future<Portfolio?> getUserPortfolio(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(portfoliosCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Portfolio.fromMap(
            snapshot.docs.first.data(), snapshot.docs.first.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter portfólio: ${e.message}';
    }
  }

  /// Obter stream do portfólio do usuário
  Stream<Portfolio?> getUserPortfolioStream(String userId) {
    return _firestore
        .collection(portfoliosCollection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return Portfolio.fromMap(
            snapshot.docs.first.data(), snapshot.docs.first.id);
      }
      return null;
    });
  }

  /// Atualizar portfólio
  Future<void> updatePortfolio(Portfolio portfolio) async {
    try {
      await _firestore
          .collection(portfoliosCollection)
          .doc(portfolio.id)
          .update({
        ...portfolio.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar portfólio: ${e.message}';
    }
  }

  /// Atualizar valor total investido e atual
  Future<void> updatePortfolioValues(
    String portfolioId,
    double totalInvested,
    double currentValue,
  ) async {
    try {
      await _firestore
          .collection(portfoliosCollection)
          .doc(portfolioId)
          .update({
        'totalInvested': totalInvested,
        'currentValue': currentValue,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar valores: ${e.message}';
    }
  }

  /// Atualizar alocações percentuais
  Future<void> updateAllocationPercentages(
    String portfolioId,
    Map<String, double> percentages,
  ) async {
    try {
      await _firestore
          .collection(portfoliosCollection)
          .doc(portfolioId)
          .update({
        'allocationPercentages': percentages,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar alocações: ${e.message}';
    }
  }

  /// Deletar portfólio
  Future<void> deletePortfolio(String id) async {
    try {
      await _firestore.collection(portfoliosCollection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar portfólio: ${e.message}';
    }
  }
}
