import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_out_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignOutUsecase signOutUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signOutUsecase = SignOutUsecase(authRepository: mockAuthRepository);
  });

  test('should call signOut method on AuthRepository', () async {
    when(mockAuthRepository.signOut()).thenAnswer((realInvocation) async {});
    await signOutUsecase.call(NoParams());

    verify(
        mockAuthRepository.signOut()); //verifico che chiamo il metodo sul repo
  });
  test('should throws and Excpetion when authRepo throws an Exception', () {
    when(mockAuthRepository.signOut()).thenThrow(Exception());
    expect(() async => await signOutUsecase.call(NoParams()),
        throwsA(isA<Exception>()));
  });
}
