import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource_firebase.dart';
import 'package:flutter_social_firebase/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_local_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //*firebase
  sl.registerSingleton<firebase_auth.FirebaseAuth>(
      firebase_auth.FirebaseAuth.instance);

  //**** DATASOURCES ****
  //*AUTH
  //local
  sl.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasource());
  //remote
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceFirebase());

  //**** REPOSITORIES ****/
  //*AUTH
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        localDatasource: sl<AuthLocalDatasource>(),
        remoteDatasource: sl<AuthRemoteDatasource>(),
      ));

  //**** USECASE ****/
  //*AUTH
  //signup
  sl.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(authRepository: sl<AuthRepository>()));

  //**** BLOCS/CUBITS ****/
  //*AUTH
  //signup
  sl.registerFactory<SignUpCubit>(
      () => SignUpCubit(signupUseCase: sl<SignUpUsecase>()));
}
