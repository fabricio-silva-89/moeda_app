import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class GetCurrentUserUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> execute() async {
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
    }
    return null;
  }
}
