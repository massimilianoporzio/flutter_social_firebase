import 'package:flutter_social_firebase/src/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mockito/mockito.dart';

import 'auth_user_model_test.mocks.dart';

//QUI FACCIO UN FINTO user di firebase con mockito
@GenerateMocks([firebase_auth.User])
void main() {
  late MockUser mockUser;

  setUp(() {
    mockUser = MockUser();
    when(mockUser.uid).thenReturn('testId');
    when(mockUser.email).thenReturn('test@test.com');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockUser.photoURL).thenReturn('http://example.com/photo.jpg');
    //ho definito come risponde il finto MockUser di firebase
  });

//   //definisco costanti (che tra l'altro matchano con i dati farlocchi di mockito)
  const String id = "testId";
  const String email = "test@test.com";
  const String name = "Test User";
  const String photoURL = "http://example.com/photo.jpg";

  //modello
  const authUserModel = AuthUserModel(
    id: id,
    email: email,
    name: name,
    photoURL: photoURL,
  );
  group('AuthUserModel', () {
    // testo che se passo le proprietà per creare un user model
    // poi dentro lo user model le proprietà sono correttamente settate
    test('properties are correctly assigned on creation', () {
      expect(authUserModel.id, equals(id));
      expect(authUserModel.email, equals(email));
      expect(authUserModel.name, equals(name));
      expect(authUserModel.photoURL, equals(photoURL));
    });
//testo la factory da oggetto firebase
    test("creates AuthUserModel from Firebase", () {
      final authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);
      expect(authUserModel.id, equals(mockUser.uid));
      expect(authUserModel.email, equals(mockUser.email));
      expect(authUserModel.name, equals(mockUser.displayName));
      expect(authUserModel.photoURL, equals(mockUser.photoURL));
    });
    test('entity correctly created', () {
      //testo la creazione di entity
      final authUser = authUserModel.toEntity();
      expect(authUser.id, equals(authUserModel.id));
      expect(authUser.email, equals(authUserModel.email));
      expect(authUser.name, equals(authUserModel.name));
      expect(authUser.photoURL, equals(authUserModel.photoURL));
    });

    //testo che name e photoUrl possono essere null
    test("photoURL and name can be null", () {
      const userModel = AuthUserModel(id: id, email: email);
      expect(userModel.name, isNull);
      expect(userModel.photoURL, isNull);
    });

    test('props returns correct properties (in order)', () {
      final props = authUserModel.props;
      expect(props, containsAll([id, email, name, photoURL]));
    });

    test('Handle null values from firebase properly', () {
      when(mockUser.email).thenReturn('');
      when(mockUser.displayName).thenReturn(null);
      when(mockUser.photoURL).thenReturn(null);

      final authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);
      expect(authUserModel.email, equals(''));
      expect(authUserModel.name, isNull);
      expect(authUserModel.photoURL, isNull);
    });
  });
}
