import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository]) //MOCKITO
void main() {
  late SignUpUsecase signUpUsecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository(); //è FAKE
    signUpUsecase = SignUpUsecase(authRepository: mockAuthRepository);
  });

  //definisco variabili per poi testare il caso d'uso
  final tEmail = Email((p0) => p0.value = "test@test.com");
  final tPassword = Password((p0) => p0.value = "pippo123");
  final tAuthUser = AuthUser(id: '123', email: tEmail.value);
  final tSignUpParams = SignUpParams(email: tEmail, password: tPassword);

  test(
      'should call signUp method on the AuthRepository with correct parameters',
      () async {
    //qui dico che ad ogni invocazione di mockAuthRepo con param che si chiamano email e password (qualunque cosa siano)
    //rispondo sempre con una funzione che ritorna tAuthUser
    when(mockAuthRepository.signUp(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((realInvocation) async => tAuthUser);

    await signUpUsecase.call(tSignUpParams);

    verify(mockAuthRepository.signUp(
        email: tEmail.value, password: tPassword.value)); //VERIFY !
  });

  test(
      'should throw an exception when signUp method on the authRepository throws an exception',
      () async {
    //qui dico che ad ogni invocazione di mockAuthRepo con param che si chiamano email e password (qualunque cosa siano)
    //rispondo sempre con una funzione che ritorna tAuthUser
    when(mockAuthRepository.signUp(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(Exception());

    final call = signUpUsecase.call;
    expect(() => call(tSignUpParams), throwsA(isA<Exception>()));
  });

  test(
      'should return the correct AuthUser when the AuthRepo (signUp method) return an AuthUser',
      () async {
    //qui dico che ad ogni invocazione di mockAuthRepo con param che si chiamano email e password (qualunque cosa siano)
    //rispondo sempre con una funzione che ritorna tAuthUser
    when(mockAuthRepository.signUp(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((realInvocation) async => tAuthUser);

    final result = await signUpUsecase.call(tSignUpParams);

    expect(result, equals(tAuthUser));
  });
}
