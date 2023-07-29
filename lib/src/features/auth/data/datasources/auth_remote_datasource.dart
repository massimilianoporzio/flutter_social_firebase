//HANDLES AUTHUSERMODEL NOT ENTITY
import '../models/auth_user_model.dart';

abstract class AuthRemoteDatasource {
  Stream<AuthUserModel?> get user;
  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
