//il caso d'uso ha bisogno di un repo...ma io voglio testare SOLO il caso
//d'uso NON entrambi QUINDI uso un mock per il repo

import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository]) //MOCKITO
void main() {
  late SignInUsecase signInUsecase;
  late MockAuthRepository mockAuthRepository;
  //initialize tests
  setUp(() {
    mockAuthRepository = MockAuthRepository(); //è FAKE
    signInUsecase = SignInUsecase(authRepository: mockAuthRepository);
  });
  //definisco variabili
  final tEmail = Email((p0) => p0.value = "test@test.com");
  final tPassword = Password((p0) => p0.value = "pippo123");
  final tAuthUser = AuthUser(id: '123', email: tEmail.value);
  final tSignInParams = SignInParams(email: tEmail, password: tPassword);

  test(
      'should call signIn method on the AuthRepository with correct parameters',
      () async {
    //qui dico che ad ogni invocazione di mockAuthRepo con param che si chiamano email e password (qualunque cosa siano)
    //rispondo sempre con una funzione che ritorna tAuthUser
    when(mockAuthRepository.signIn(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((realInvocation) async => tAuthUser);

    await signInUsecase.call(tSignInParams);

    verify(mockAuthRepository.signIn(
        email: tEmail.value, password: tPassword.value)); //VERIFY !
    //STO TESTANDO che se passo un SignInParams costruito con email e passw
    //al mio usecase allora venga CHIAMATO il metodo signIn sul REPO con
    //la String test@test.com come email e pippo123 come password
    //TESTO CHE se chiamo il caso d'uso con il Params creato con tEmail e tPassword
    //che hanno come values test@test.com e pippo123 rispettivamente,
    //ALLORA TESTO CHE VENGA CHIAMATO signIn sul repo con 'test@test.com' e
    // 'pippo123' come stringhe in input
  });

  test(
      'should throw an exception when signIn method on the authRepository throws an exception',
      () async {
    //qui dico che ad ogni invocazione di mockAuthRepo con param che si chiamano email e password (qualunque cosa siano)
    //rispondo sempre con una funzione che ritorna tAuthUser
    when(mockAuthRepository.signIn(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(Exception());

    final call = signInUsecase.call;
    expect(() => call(tSignInParams), throwsA(isInstanceOf<Exception>()));

    verify(mockAuthRepository.signIn(
        email: tEmail.value, password: tPassword.value));
  });

  test(
      'should return the correct AuthUser when the AuthRepo (signIn method) return an AuthUser',
      () async {
    //qui dico che ad ogni invocazione di mockAuthRepo con param che si chiamano email e password (qualunque cosa siano)
    //rispondo sempre con una funzione che ritorna tAuthUser
    when(mockAuthRepository.signIn(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((realInvocation) async => tAuthUser);

    final result = await signInUsecase.call(tSignInParams);

    expect(result, equals(tAuthUser));
  });
}
