// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  //Fa uso di local E remote datasources
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;
  AuthRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });
  @override
  Stream<AuthUser> get authUserStream {
    //restituisco uno stream di ENTITIES e man mano che mappo le metto in cache
    return remoteDatasource.user.map((authUserModel) {
      //scrivo dentro la local in cache

      localDatasource.write(key: 'user', value: authUserModel);
      //una entity non è NULLA quindi se arriva un userModel null lo mappo
      //in una entity EMPTY.
      return authUserModel == null ? AuthUser.empty : authUserModel.toEntity();
    });
  }

  @override
  Future<AuthUser> signIn(
      {required String email, required String password}) async {
    final authUserModel = await remoteDatasource.signInWithEmailAndPassword(
        email: email, password: password);
    //metto in cache
    localDatasource.write(key: 'user', value: authUserModel);
    //restituisco la entity
    return authUserModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await remoteDatasource.signOut();
    //se NON va' in eccezione allora RIMUOVO dalla cache locale
    //(se no risulta ancora loggato)
    localDatasource.write(key: 'user', value: null);
  }

  @override
  Future<AuthUser> signUp(
      {required String email, required String password}) async {
    //creo con signup sulla remote
    final authUserModel = await remoteDatasource.signUpWithEmailAndPassword(
        email: email, password: password);
    //FIREBASE NON ritorna mai null al max va' in eccezione
    //lo metto in cache
    localDatasource.write(key: 'user', value: authUserModel);
    //restituisco la entity
    return authUserModel.toEntity();
  }
}
