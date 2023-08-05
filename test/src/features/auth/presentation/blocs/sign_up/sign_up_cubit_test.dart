import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_cubit_test.mocks.dart';

@GenerateMocks([SignUpUseCase])
void main() {
  late MockSignUpUseCase mockSignUpUsecase;
  setUp(() {
    mockSignUpUsecase = MockSignUpUseCase();
  });
  final validEmail = Email(
    (p0) => p0.value = 'test@test.com',
  );

  final validPassword = Password(
    (p0) => p0.value = "pippo123",
  );

  group('SignUpCubit', () {
    blocTest<SignUpCubit, SignUpState>(
      'emits [] when nothing is added.',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      expect: () => const <SignUpState>[],
    );
    blocTest(
      'emits [valid email state] when valid email is added',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      act: (cubit) => cubit.emailChanged(validEmail.value),
      expect: () => [
        //mi aspetto lista di emits
        SignUpState(email: validEmail, emailStatus: EmailStatus.valid)
      ],
    );
    blocTest(
      'emits [invalid email state] when invalid email is added',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      act: (cubit) => cubit.emailChanged('invalid_at_runtime'),
      expect: () => [
        //mi aspetto lista di emits
        const SignUpState(emailStatus: EmailStatus.invalid)
      ],
    );
    blocTest(
      'emits [unknown email state] when user clear email fiels',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      act: (bloc) => bloc.resetEmailInput(),
      expect: () => [const SignUpState(emailStatus: EmailStatus.unknown)],
    );
    blocTest(
      'emits [valid password state] when valid password is added',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      act: (cubit) => cubit.passwordChanged(validPassword.value),
      expect: () => [
        //mi aspetto lista di emits
        SignUpState(
          password: validPassword,
          passwordStatus: PasswordStatus.valid,
        )
      ],
    );
    blocTest(
      'emits [invalid password state] when invalid password is added',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      act: (cubit) => cubit.passwordChanged('invalid'),
      expect: () => [
        //mi aspetto lista di emits
        const SignUpState(
          passwordStatus: PasswordStatus.invalid,
        ),
      ],
    );
    blocTest(
      'emits [unknown password state] when user clear password fiels',
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      act: (bloc) => bloc.resetPasswordInput(),
      expect: () => [const SignUpState(passwordStatus: PasswordStatus.unknown)],
    );
    blocTest<SignUpCubit, SignUpState>(
      'emits formStatus [invalid, initial] when the form is not validated',
      //mi aspetto PRIMA invalid POI initial
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      //metto uno stato come 'seme' con cui far partire il bloc
      seed: () => const SignUpState(
        passwordStatus: PasswordStatus.unknown,
        emailStatus: EmailStatus.unknown,
      ),
      //QUI TESTO il cubit e gli faccio fare signUp con form non validata
      act: (cubit) => cubit.signUp(),
      expect: () => const [
        SignUpState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.invalid,
        ),
        SignUpState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.initial,
        ),
      ],
    );
    blocTest<SignUpCubit, SignUpState>(
      'emits [submissionInProgress, submissionSuccess] when signUp is successful',
      setUp: () {
        when(mockSignUpUsecase(any)).thenAnswer(
          (_) => Future.value(
            const AuthUser(id: 'id', email: 'test@test.com'),
          ),
        );
      },
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      seed: () => SignUpState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
      ),
      act: (cubit) => cubit.signUp(),
      expect: () => [
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionInProgress,
        ),
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionSuccess,
        ),
      ],
      //verifico che il bloc/cubit abbia chiamato il caso d'uso
      //(con any come argomento tanto dovrei passarci NoArgs)
      verify: (bloc) {
        verify(mockSignUpUsecase(any)).called(1);
      },
    );
    blocTest<SignUpCubit, SignUpState>(
      'emits [submissionInProgress, submissionFailure] when signUp is NOT successful',
      setUp: () {
        when(mockSignUpUsecase(any)).thenThrow(Exception());
      },
      build: () => SignUpCubit(signupUseCase: mockSignUpUsecase),
      seed: () => SignUpState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
      ),
      act: (cubit) => cubit.signUp(),
      //mi aspetto PRIMA in Progress POI Failure
      expect: () => [
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionInProgress,
        ),
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionFailure,
        ),
      ],
      //verifico che il bloc/cubit abbia chiamato il caso d'uso
      //(con any come argomento tanto dovrei passarci NoArgs)
      verify: (bloc) {
        verify(mockSignUpUsecase(any)).called(1);
      },
    );
  });
}
