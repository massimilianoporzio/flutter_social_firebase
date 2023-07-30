import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_remote_datasource_firebase.dart';
import 'package:flutter_social_firebase/src/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mockito/mockito.dart';

import 'auth_remote_datasource_firebase_test.mocks.dart';

@GenerateMocks([
  firebase_auth.FirebaseAuth,
  firebase_auth.UserCredential,
  firebase_auth.User,
])
void main() {
  //dichiaro variabili che userò
  //firebase mocked:
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  //del mio domain
  late AuthRemoteDatasourceFirebase authRemoteDatasourceFirebase;
  //e model
  late AuthUserModel authUserModel;

  const tEmail = 'test@test.com';
  const tPassword = 'password';

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    //definisco il comportamento
    when(mockUser.uid).thenReturn('test_uid');
    when(mockUser.email).thenReturn('test_email');
    when(mockUser.displayName).thenReturn('test_username');
    when(mockUser.photoURL).thenReturn('test_photoURL');

    //creo userModel e datasource
    authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);
    authRemoteDatasourceFirebase =
        AuthRemoteDatasourceFirebase(firebaseAuth: mockFirebaseAuth);
  });
  //testo il metodo signUp
  group('signUpWithEmailAndPassword', () {
    test('should return AuthUserModel when sign up is successfull', () async {
      //qualunque chiamta faccia a createUserWithEmailAndPassword rispondi con
      //mockUserCredential
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((realInvocation) async => mockUserCredential);
      //e quando ci chiamo il getter user rispondo con mockUser
      when(mockUserCredential.user).thenReturn(mockUser);
      //ora faccio la chiamato per testare
      final result = await authRemoteDatasourceFirebase
          .signUpWithEmailAndPassword(email: tEmail, password: tPassword);
      //e ora testo che il risultato sia il mio authUserModel
      expect(result, equals(authUserModel));
      //e che abbia chiamato il metodo sul firebaseAuth (mocked)
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail, password: tPassword));
    });
    test('should throw exception when signUpWithEmailAndPassword fails', () {
      //qualunque chiamta faccia a createUserWithEmailAndPassword rispondi con
      //ECCEZIONE
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Exception());
      //definisco la chiamata
      final call = authRemoteDatasourceFirebase.signUpWithEmailAndPassword;
      expect(() => call(email: tEmail, password: tPassword),
          throwsA(isA<Exception>()));
    });
  });
  group('signInWithEmailAndPassword', () {
    test('should return AuthUserModel when sign in is successfull', () async {
      //qualunque chiamta faccia a signInWithEmailAndPassword rispondi con
      //mockUserCredential
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((realInvocation) async => mockUserCredential);
      //e quando ci chiamo il getter user rispondo con mockUser
      when(mockUserCredential.user).thenReturn(mockUser);
      //ora faccio la chiamato per testare
      final result = await authRemoteDatasourceFirebase
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);
      //e ora testo che il risultato sia il mio authUserModel
      expect(result, equals(authUserModel));
      //e che abbia chiamato il metodo sul firebaseAuth (mocked)
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail, password: tPassword));
    });

    test('should throw exception when signInWithEmailAndPassword fails', () {
      //qualunque chiamta faccia a createUserWithEmailAndPassword rispondi con
      //ECCEZIONE
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Exception());
      //definisco la chiamata
      final call = authRemoteDatasourceFirebase.signInWithEmailAndPassword;
      expect(() => call(email: tEmail, password: tPassword),
          throwsA(isA<Exception>()));
    });
  });
  group('signOut', () {
    test('should call signOut on firebaseAuth', () async {
      //definisco il comportamento mock (mica chiamo Firebase x davvero nei test)
      when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) async {
        //non faccio nulla
      });
      //faccio la chiamata alla mia datasource che voglio testare
      await authRemoteDatasourceFirebase.signOut();
      //verifico che abbia chiamato signOut su firebase
      verify(mockFirebaseAuth.signOut());
    });
    test('should throw an Exception if FirebaseAuth throws an Exception', () {
      when(mockFirebaseAuth.signOut()).thenThrow(Exception());
      //assegno la funzione
      final call = authRemoteDatasourceFirebase.signOut;
      //verifico che vada in eccezione
      expect(() => call(), throwsA(isA<Exception>()));
    });
  });
  group('user (getter of the stream of AuthUser)', () {
    test(
        'should retturn authUserModel as first elem of the stream if firebase authStateChanged has the correct user as first element.',
        () async {
      //faccio tornare il mockUser dentro uno stream
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));
      //faccio la chiamata alla mia datasource che voglio testare
      final result = authRemoteDatasourceFirebase.user;
      final user = await result.first; //primo elemento nello stream
      expect(user, authUserModel);
    });
    test(
        'should return null as first elem of the stream if firebase authStateChanged returns null as first elem of the stream.',
        () async {
      //faccio tornare il mockUser dentro uno stream
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));
      //faccio la chiamata alla mia datasource che voglio testare
      final result = authRemoteDatasourceFirebase.user;
      final user = await result.first; //primo elemento nello stream
      expect(user, isNull);
    });
    test(
        'should throw an Exception  if firebase authStateChanged throws an Excpetion',
        () {
      //faccio tornare il mockUser dentro uno stream
      when(mockFirebaseAuth.authStateChanges()).thenThrow(Exception());
      //faccio la chiamata alla mia datasource che voglio testare

      expect(
          () => authRemoteDatasourceFirebase.user, throwsA(isA<Exception>()));
    });
  });
}
