import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/utils/firebase_collections.dart';
import '../../domain/models/asset_model.dart';
import '../../domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Criar novo asset
  @override
  Future<String> createAsset(AssetModel asset) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseCollections.investimentsType)
          .add(asset.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw 'Erro ao criar asset: ${e.message}';
    }
  }

  /// Obter asset por ID
  @override
  Future<AssetModel?> getAsset(String id) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.investimentsType)
          .doc(id)
          .get();

      if (doc.exists) {
        return AssetModel.fromMap(doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter asset: ${e.message}';
    }
  }

  /// Obter todos os assets do usuário
  @override
  Future<List<AssetModel>> getUserAssets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.investimentsType)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => AssetModel.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Erro ao obter assets: ${e.message}';
    }
  }

  /// Obter stream de assets do usuário
  @override
  Stream<List<AssetModel>> getUserAssetsStream(String userId) {
    return _firestore
        .collection(FirebaseCollections.investimentsType)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AssetModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Atualizar asset
  @override
  Future<void> updateAsset(AssetModel asset) async {
    try {
      await _firestore
          .collection(FirebaseCollections.investimentsType)
          .doc(asset.id)
          .update({
        'name': asset.name,
        'type': asset.type,
        'percentage': asset.percentage,
        'currentValue': asset.currentValue,
        'score': asset.score,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar asset: ${e.message}';
    }
  }

  /// Deletar asset
  @override
  Future<void> deleteAsset(String id) async {
    try {
      await _firestore
          .collection(FirebaseCollections.investimentsType)
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar asset: ${e.message}';
    }
  }
}
