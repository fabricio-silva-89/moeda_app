import 'package:firebase_auth/firebase_auth.dart';

extension AuthExceptionExtension on FirebaseAuthException {
  Exception get exception {
    switch (code) {
      case 'invalid-email':
        return Exception('O email fornecido é inválido.');
      case 'user-disabled':
        return Exception('A conta do usuário foi desativada.');
      case 'user-not-found':
        return Exception('Nenhum usuário encontrado com este email.');
      case 'wrong-password':
        return Exception('Senha incorreta. Tente novamente.');
      case 'email-already-in-use':
        return Exception('Este email já está em uso por outra conta.');
      case 'operation-not-allowed':
        return Exception('Operação não permitida. Contate o suporte.');
      case 'weak-password':
        return Exception('A senha é muito fraca. Use uma senha mais forte.');
      default:
        return Exception('Ocorreu um erro desconhecido: $message');
    }
  }
}
