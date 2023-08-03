import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource_firebase.dart';
import 'package:flutter_social_firebase/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/stream_auth_user_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:flutter_social_firebase/src/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:flutter_social_firebase/src/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/data/datasources/auth_local_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //*shared preferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

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

  //*THEME
  sl.registerLazySingleton<ThemeLocalDatasource>(
      () => ThemeLocalDatasource(prefs: prefs));

  //**** REPOSITORIES ****/
  //*AUTH
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        localDatasource: sl<AuthLocalDatasource>(),
        remoteDatasource: sl<AuthRemoteDatasource>(),
      ));
  //*THEME
  sl.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(localDatasource: sl<ThemeLocalDatasource>()));

  //**** USECASE ****/
  //*AUTH
  //signup
  sl.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(authRepository: sl<AuthRepository>()));
  //signin
  sl.registerLazySingleton<SignInUsecase>(
      () => SignInUsecase(authRepository: sl<AuthRepository>()));
  //streamAuth SINGLETON per tutta la app
  sl.registerSingleton<StreamAuthUserUsecase>(
      StreamAuthUserUsecase(authRepository: sl<AuthRepository>()));
  //streamTheme SINGLETON per tutta la app
  sl.registerSingleton<StreamThemeUsecase>(
      StreamThemeUsecase(themeRepository: sl()));

  //**** BLOCS/CUBITS ****/
  //*AUTH
  //signup
  sl.registerFactory<SignUpCubit>(
      () => SignUpCubit(signupUseCase: sl<SignUpUsecase>()));
  //signin
  sl.registerFactory<SignInCubit>(
      () => SignInCubit(signInUsecase: sl<SignInUsecase>()));
}
