import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource_firebase.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/sign_out_usecase.dart';
import '../features/auth/domain/usecases/sign_up_usecase.dart';
import '../features/auth/domain/usecases/stream_auth_user_usecase.dart';
import '../features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import '../features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import '../features/theme/data/datasources/theme_local_datasource.dart';
import '../features/theme/data/repositories/theme_repository_impl.dart';
import '../features/theme/domain/repositories/theme_repository.dart';
import '../features/theme/domain/usecases/stream_theme_usecase.dart';
import '../features/theme/domain/usecases/switch_theme_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //*shared preferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  //*firebase
  sl.registerSingleton<firebase_auth.FirebaseAuth>(
      firebase_auth.FirebaseAuth.instance);
  //*firestore
  sl.registerLazySingleton<cloud_firestore.FirebaseFirestore>(
      () => cloud_firestore.FirebaseFirestore.instance);

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
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(authRepository: sl<AuthRepository>()));
  //signin
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(authRepository: sl<AuthRepository>()));

  //signout
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(authRepository: sl<AuthRepository>()));
  //streamAuth SINGLETON per tutta la app
  sl.registerSingleton<StreamAuthUserUseCase>(
      StreamAuthUserUseCase(authRepository: sl<AuthRepository>()));

  //*THEME
  //streamTheme SINGLETON per tutta la app
  sl.registerSingleton<StreamThemeUseCase>(
      StreamThemeUseCase(themeRepository: sl<ThemeRepository>()));
  sl.registerLazySingleton<SwitchThemeUseCase>(
      () => SwitchThemeUseCase(themeRepository: sl<ThemeRepository>()));

  //**** BLOCS/CUBITS ****/
  //*AUTH
  //signup
  sl.registerFactory<SignUpCubit>(
      () => SignUpCubit(signupUseCase: sl<SignUpUseCase>()));
  //signin
  sl.registerFactory<SignInCubit>(
      () => SignInCubit(signInUsecase: sl<SignInUseCase>()));
}
