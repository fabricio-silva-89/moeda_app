import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/domain/models/user_model.dart';
import '../../../../core/extensions/auth_exception.dart';
import '../../../../core/utils/firebase_collections.dart';
import '../../domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUser(String id) async {
    try {
      final doc =
          await _firestore.collection(FirebaseCollections.users).doc(id).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw Exception('Erro ao obter usuário: ${e.message}');
    }
  }

  @override
  Future<String?> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw e.exception;
    }
  }
}
