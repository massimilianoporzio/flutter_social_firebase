import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser> get authUserStrem;
  Future<AuthUser> signUp({required String email, required String password});
  Future<AuthUser> signIn({required String email, required String password});
  Future<void> signOut();
}
