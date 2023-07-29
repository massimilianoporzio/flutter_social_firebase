import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/models/auth_user_model.dart';

class AuthRemoteDatasourceFake implements AuthRemoteDatasource {
  static const fakeUser = AuthUserModel(
      id: "fake-user-id", email: "fake-user-email", name: "fake-user-name");

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return fakeUser;
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError(); //non implemento
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return fakeUser;
  }

  @override
  Stream<AuthUserModel?> get user => Stream.value(fakeUser);
}
