// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/models/auth_user_model.dart';

import '../../../../services/service_locator.dart';

class AuthRemoteDatasourceFirebase implements AuthRemoteDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  AuthRemoteDatasourceFirebase({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? sl<firebase_auth.FirebaseAuth>();

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      firebase_auth.UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      //TODO gestire le eccezioni firebase (user does not exists ecc.)
      throw Exception('Sign in failed: $error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      //recupero le credentials con email and password
      firebase_auth.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return AuthUserModel.fromFirebaseAuthUser(
          credential.user!); //so che non è null perché ho appena controllato
    } catch (error) {
      //TODO gestire le eccezioni firebase (weak password ecc.)
      throw Exception('Sign up failed: $error');
    }
  }

  @override
  Stream<AuthUserModel?> get user {
    //trasformo lo stream di firebaseUser in uno stream di AuthUserModel
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser);
    });
  }
}
