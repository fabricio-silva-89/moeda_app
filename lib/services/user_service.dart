import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String usersCollection = 'users';

  /// Criar novo usuário no Firestore
  Future<void> createUser(User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.uid)
          .set(user.toMap());
    } on FirebaseException catch (e) {
      throw 'Erro ao criar usuário: ${e.message}';
    }
  }

  /// Obter usuário por UID
  Future<User?> getUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Erro ao obter usuário: ${e.message}';
    }
  }

  /// Atualizar usuário
  Future<void> updateUser(User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.uid)
          .update(user.toMap());
    } on FirebaseException catch (e) {
      throw 'Erro ao atualizar usuário: ${e.message}';
    }
  }

  /// Deletar usuário
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .delete();
    } on FirebaseException catch (e) {
      throw 'Erro ao deletar usuário: ${e.message}';
    }
  }

  /// Obter stream de usuário em tempo real
  Stream<User?> getUserStream(String uid) {
    return _firestore
        .collection(usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    });
  }
}
