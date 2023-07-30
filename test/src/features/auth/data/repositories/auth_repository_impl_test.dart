//TESTO IL REPO AUTH che ha bisogno di 2 datasource (le faccio con mockito)
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_social_firebase/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthRemoteDatasource,
  AuthLocalDatasource,
])
void main() {
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockAuthLocalDatasource mockLocalDatasource;
  //
  //la classe che testo
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockLocalDatasource = MockAuthLocalDatasource();
    mockRemoteDatasource = MockAuthRemoteDatasource();
    //
    authRepository = AuthRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
    );
  });
  const email = 'test@gmail.com';
  const password = 'password12345';
  const authUserModel = AuthUserModel(id: '123', email: 'test@test.com');
  group('authUserStream', () {
    test('call the remote data source ', () async {
      //comportamento
      when(mockRemoteDatasource.user)
          .thenAnswer((realInvocation) => Stream.value(authUserModel));
      //ORA CHIAMO PER TESTARE
      authRepository.authUserStream;

      verify(
        mockRemoteDatasource.user,
      );
    });
    test(
        'returns AuthUser.empty as first elem of stream when remote datasource returns null AND clear the cache',
        () async {
      //comportamento
      when(mockRemoteDatasource.user)
          .thenAnswer((realInvocation) => Stream.value(null));
      //chiamo il metodo getter
      final stream = authRepository.authUserStream;
      final user = await stream.first;
      expect(user, AuthUser.empty);
      verify(mockLocalDatasource.write(key: 'user', value: null)).called(1);
    });
    test(
        'returns an AuthUser as first elem of stream when remote datasource returns non-null and write it corerctly in the local data source',
        () async {
      //comportamento
      when(mockRemoteDatasource.user)
          .thenAnswer((realInvocation) => Stream.value(authUserModel));
      //chiamo il metodo getter
      final stream = authRepository.authUserStream;
      final user = await stream.first;
      expect(user, authUserModel.toEntity());
      verify(mockLocalDatasource.write(key: 'user', value: authUserModel))
          .called(1);
    });
  });
  group('sign up', () {
    test('call in order the remote THEN the local', () async {
      when(mockRemoteDatasource.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((realInvocation) async => authUserModel);

      //Faccio la chiamata
      await authRepository.signUp(email: email, password: password);
      verifyInOrder([
        mockRemoteDatasource.signUpWithEmailAndPassword(
            email: email, password: password),
        mockLocalDatasource.write(key: 'user', value: authUserModel),
      ]);
    });
    test('calls and write with correct arguments', () async {
      when(mockRemoteDatasource.signUpWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => authUserModel);
      //CHIAMO per testare
      await authRepository.signUp(email: email, password: password);
      //VERIFICO CHE HO CHIAMTO CON i corretti argomenti
      verify(mockRemoteDatasource.signUpWithEmailAndPassword(
              email: email, password: password))
          .called(1);
      //e che ho chiamto per scrivere in cache con aithUsuerModel
      verify(mockLocalDatasource.write(key: 'user', value: authUserModel))
          .called(1);
    });
    test(
        'returns AuthUserModel when remote data source signupWithEmailAndPassword returns a userModel',
        () async {
      when(mockRemoteDatasource.signUpWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => authUserModel);
      final result =
          await authRepository.signUp(email: email, password: password);
      expect(result, authUserModel.toEntity());
    });
  });
  group('sign in', () {
    test('call in order the remote THEN the local', () async {
      when(mockRemoteDatasource.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((realInvocation) async => authUserModel);

      //Faccio la chiamata
      await authRepository.signIn(email: email, password: password);
      verifyInOrder([
        mockRemoteDatasource.signInWithEmailAndPassword(
            email: email, password: password),
        mockLocalDatasource.write(key: 'user', value: authUserModel),
      ]);
    });
    test('calls and write with correct arguments', () async {
      when(mockRemoteDatasource.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => authUserModel);
      //CHIAMO per testare
      await authRepository.signIn(email: email, password: password);
      //VERIFICO CHE HO CHIAMTO CON i corretti argomenti
      verify(mockRemoteDatasource.signInWithEmailAndPassword(
              email: email, password: password))
          .called(1);
      //e che ho chiamto per scrivere in cache con aithUsuerModel
      verify(mockLocalDatasource.write(key: 'user', value: authUserModel))
          .called(1);
    });
    test(
        'returns AuthUserModel when remote data source signInWithEmailAndPassword returns a userModel',
        () async {
      when(mockRemoteDatasource.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => authUserModel);
      final result =
          await authRepository.signIn(email: email, password: password);
      expect(result, authUserModel.toEntity());
    });
  });
  group('sign Out', () {
    test('calls signOut on the remote data source AND clear the cache',
        () async {
      when(mockRemoteDatasource.signOut())
          .thenAnswer((realInvocation) async {});
      await authRepository.signOut();
      verifyInOrder([
        mockRemoteDatasource.signOut(),
        mockLocalDatasource.write(key: 'user', value: null),
      ]);
    });
  });
} //FINE TESTS
