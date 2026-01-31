import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/asset_model.dart';

class AssetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String assetsCollection = 'assets';

  /// Criar novo asset
  Future<String> createAsset(Asset asset) async {
    try {
      final docRef =
          await _firestore.collection(assetsCollection).add(asset.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar asset: ${e.message}';
    }
  }

  /// Obter asset por ID
  Future<Asset?> getAsset(String id) async {
    try {
      final doc = await _firestore.collection(assetsCollection).doc(id).get();

      if (doc.exists) {
        return Asset.fromMap(doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter asset: ${e.message}';
    }
  }

  /// Obter todos os assets do usuário
  Future<List<Asset>> getUserAssets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(assetsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Asset.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter assets: ${e.message}';
    }
  }

  /// Obter stream de assets do usuário
  Stream<List<Asset>> getUserAssetsStream(String userId) {
    return _firestore
        .collection(assetsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Asset.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Atualizar nome e tipo do asset
  Future<void> updateAsset(Asset asset) async {
    try {
      await _firestore.collection(assetsCollection).doc(asset.id).update({
        'name': asset.name,
        'type': asset.type,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar asset: ${e.message}';
    }
  }

  /// Deletar asset
  Future<void> deleteAsset(String id) async {
    try {
      await _firestore.collection(assetsCollection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar asset: ${e.message}';
    }
  }
}
