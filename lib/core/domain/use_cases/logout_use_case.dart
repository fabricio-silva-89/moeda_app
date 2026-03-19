import 'package:firebase_auth/firebase_auth.dart';

class LogoutUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> execute() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception('Erro ao fazer logout: ${e.message}');
    }
  }
}
