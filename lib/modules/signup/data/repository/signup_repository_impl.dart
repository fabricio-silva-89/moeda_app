import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/extensions/auth_exception.dart';
import '../../../../core/utils/firebase_collections.dart';
import '../../domain/params/create_user_assets_params.dart';
import '../../domain/params/create_user_params.dart';
import '../../domain/params/register_params.dart';
import '../../domain/repository/signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createUserAssets({
    required CreateUserAssetsParams params,
  }) async {
    try {
      await _firestore
          .collection(FirebaseCollections.assets)
          .add(params.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Erro ao criar asset: ${e.message}');
    }
  }

  @override
  Future<String?> register({required RegisterParams params}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
      await userCredential.user?.updateDisplayName(params.name);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw e.exception;
    }
  }

  @override
  Future<void> createUser({required CreateUserParams params}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(params.uid)
          .set(params.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Erro ao criar usuário: ${e.message}');
    }
  }
}
