import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stock_model.dart';

class StockService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String stocksCollection = 'stocks';

  /// Criar nova ação
  Future<String> createStock(Stock stock) async {
    try {
      final docRef = await _firestore
          .collection(stocksCollection)
          .add(stock.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar ação: ${e.message}';
    }
  }

  /// Obter ação por ID
  Future<Stock?> getStock(String id) async {
    try {
      final doc = await _firestore
          .collection(stocksCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return Stock.fromMap(doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter ação: ${e.message}';
    }
  }

  /// Obter todas as ações do usuário
  Future<List<Stock>> getUserStocks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(stocksCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Stock.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter ações: ${e.message}';
    }
  }

  /// Obter stream de ações do usuário
  Stream<List<Stock>> getUserStocksStream(String userId) {
    return _firestore
        .collection(stocksCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Stock.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Obter ações filtradas por setor
  Future<List<Stock>> getStocksBySector(String userId, String sector) async {
    try {
      final snapshot = await _firestore
          .collection(stocksCollection)
          .where('userId', isEqualTo: userId)
          .where('sector', isEqualTo: sector)
          .get();

      return snapshot.docs
          .map((doc) => Stock.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter ações por setor: ${e.message}';
    }
  }

  /// Atualizar ação
  Future<void> updateStock(Stock stock) async {
    try {
      await _firestore
          .collection(stocksCollection)
          .doc(stock.id)
          .update({
            ...stock.toMap(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar ação: ${e.message}';
    }
  }

  /// Deletar ação
  Future<void> deleteStock(String id) async {
    try {
      await _firestore
          .collection(stocksCollection)
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar ação: ${e.message}';
    }
  }

  /// Atualizar porcentagem de uma ação
  Future<void> updateStockPercentage(
    String stockId,
    double percentage,
  ) async {
    try {
      await _firestore
          .collection(stocksCollection)
          .doc(stockId)
          .update({
            'percentage': percentage,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar porcentagem: ${e.message}';
    }
  }

  /// Atualizar preço atual da ação
  Future<void> updateStockPrice(
    String stockId,
    double currentPrice,
  ) async {
    try {
      await _firestore
          .collection(stocksCollection)
          .doc(stockId)
          .update({
            'currentPrice': currentPrice,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar preço: ${e.message}';
    }
  }
}
