import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart' as transaction_model;

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String transactionsCollection = 'transactions';

  /// Criar nova transação
  Future<String> createTransaction(
      transaction_model.Transaction transaction) async {
    try {
      final docRef = await _firestore
          .collection(transactionsCollection)
          .add(transaction.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar transação: ${e.message}';
    }
  }

  /// Obter transação por ID
  Future<transaction_model.Transaction?> getTransaction(String id) async {
    try {
      final doc =
          await _firestore.collection(transactionsCollection).doc(id).get();

      if (doc.exists) {
        return transaction_model.Transaction.fromMap(
            doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter transação: ${e.message}';
    }
  }

  /// Obter todas as transações do usuário
  Future<List<transaction_model.Transaction>> getUserTransactions(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection(transactionsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              transaction_model.Transaction.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter transações: ${e.message}';
    }
  }

  /// Obter stream de transações do usuário
  Stream<List<transaction_model.Transaction>> getUserTransactionsStream(
      String userId) {
    return _firestore
        .collection(transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              transaction_model.Transaction.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Obter transações filtradas por tipo de investimento
  Future<List<transaction_model.Transaction>> getTransactionsByType(
    String userId,
    String investmentType,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(transactionsCollection)
          .where('userId', isEqualTo: userId)
          .where('investmentType', isEqualTo: investmentType)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              transaction_model.Transaction.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter transações: ${e.message}';
    }
  }

  /// Obter transações por período
  Future<List<transaction_model.Transaction>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(transactionsCollection)
          .where('userId', isEqualTo: userId)
          .where('date',
              isGreaterThanOrEqualTo: startDate.toIso8601String(),
              isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              transaction_model.Transaction.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter transações: ${e.message}';
    }
  }

  /// Atualizar transação
  Future<void> updateTransaction(
      transaction_model.Transaction transaction) async {
    try {
      await _firestore
          .collection(transactionsCollection)
          .doc(transaction.id)
          .update(transaction.toMap());
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar transação: ${e.message}';
    }
  }

  /// Deletar transação
  Future<void> deleteTransaction(String id) async {
    try {
      await _firestore.collection(transactionsCollection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar transação: ${e.message}';
    }
  }
}
