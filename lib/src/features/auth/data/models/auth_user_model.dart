import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/auth_user.dart';

//MODELS DEVONO PRENDERE I DATI DALLA DATASOURCE E CONVERTIRE IN ENTITY
// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthUserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoURL;
  const AuthUserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoURL,
  });

  factory AuthUserModel.fromFirebaseAuthUser(firebase_auth.User firebaseUser) {
    return AuthUserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      photoURL: photoURL,
    );
  }

  @override
  List<Object?> get props => [id, email, name, photoURL];
}
