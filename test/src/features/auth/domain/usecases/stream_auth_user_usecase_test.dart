import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/stream_auth_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_auth_user_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late StreamAuthUserUseCase streamAuthUserUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    streamAuthUserUsecase =
        StreamAuthUserUseCase(authRepository: mockAuthRepository);
  });
  const tAuthUser = AuthUser(id: "123", email: "test@test.com");

  test('should call the getter on auth repo', () {
    when(mockAuthRepository.authUserStream)
        .thenAnswer((realInvocation) => Stream.value(tAuthUser));

    streamAuthUserUsecase.call();
    verify(mockAuthRepository.authUserStream); //verifico che venga chiamato
  });

  test(
      'should throw an exception when auth repo (authUserStream getter) throws an Exception',
      () {
    when(mockAuthRepository.authUserStream).thenThrow(Exception());
    final call = streamAuthUserUsecase.call;
    expect(() => call(), throwsA(isA<Exception>()));
  });

  test(
      'should return the CORRECT AuthUser when the getter on Auth repo return an AuthUser',
      () async {
    //definisco come risponde il mock repo: con tauthUser (email: 'test@test.com'....)
    when(mockAuthRepository.authUserStream)
        .thenAnswer((realInvocation) => Stream.value(tAuthUser));

    //Stream
    final result = await streamAuthUserUsecase.call();
    //primo elemento dello stream
    final user = await result
        .first; //torna il primo elemento e smette di ascoltare lo stream

    expect(user, equals(tAuthUser));
  });
}
