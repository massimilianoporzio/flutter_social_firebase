import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_cubit_test.mocks.dart';

@GenerateMocks([SignInUseCase])
void main() {
  late MockSignInUseCase mockSignInUsecase;

  setUp(() {
    mockSignInUsecase = MockSignInUseCase();
  });

  final validEmail = Email(
    (p0) => p0.value = 'test@test.com',
  );

  final validPassword = Password(
    (p0) => p0.value = "pippo123",
  );

  group('SignInCubit', () {
    blocTest<SignInCubit, SignInState>(
      'emits [] when nothing is added.',
      build: () => SignInCubit(signInUsecase: mockSignInUsecase),
      expect: () => const <SignInState>[],
    );
    blocTest(
      'emits [valid email state] when valid email is added',
      build: () => SignInCubit(signInUsecase: mockSignInUsecase),
      act: (cubit) => cubit.emailChanged(validEmail.value),
      expect: () => [
        //mi aspetto lista di emits
        SignInState(email: validEmail, emailStatus: EmailStatus.valid)
      ],
    );
    blocTest(
      'emits [invalid email state] when invalid email is added',
      build: () => SignInCubit(signInUsecase: mockSignInUsecase),
      act: (cubit) => cubit.emailChanged('invalid_at_runtime'),
      expect: () => [
        //mi aspetto lista di emits
        const SignInState(emailStatus: EmailStatus.invalid)
      ],
    );
    blocTest(
      'emits [unknown email state] when user clear email fiels',
      build: () => SignInCubit(signInUsecase: mockSignInUsecase),
      act: (bloc) => bloc.resetEmailInput(),
      expect: () => [const SignInState(emailStatus: EmailStatus.unknown)],
    );
  });
  blocTest(
    'emits [valid password state] when valid password is added',
    build: () => SignInCubit(signInUsecase: mockSignInUsecase),
    act: (cubit) => cubit.passwordChanged(validPassword.value),
    expect: () => [
      //mi aspetto lista di emits
      SignInState(
        password: validPassword,
        passwordStatus: PasswordStatus.valid,
      )
    ],
  );
  blocTest(
    'emits [invalid password state] when invalid password is added',
    build: () => SignInCubit(signInUsecase: mockSignInUsecase),
    act: (cubit) => cubit.passwordChanged('invalid'),
    expect: () => [
      //mi aspetto lista di emits
      const SignInState(
        passwordStatus: PasswordStatus.invalid,
      ),
    ],
  );
  blocTest(
    'emits [unknown password state] when user clear password fiels',
    build: () => SignInCubit(signInUsecase: mockSignInUsecase),
    act: (bloc) => bloc.resetPasswordInput(),
    expect: () => [const SignInState(passwordStatus: PasswordStatus.unknown)],
  );
  blocTest<SignInCubit, SignInState>(
    'emits formStatus [invalid, initial] when the form is not validated',
    //mi aspetto PRIMA invalid POI initial
    build: () => SignInCubit(signInUsecase: mockSignInUsecase),
    //metto uno stato come 'seme' con cui far partire il bloc
    seed: () => const SignInState(
      passwordStatus: PasswordStatus.unknown,
      emailStatus: EmailStatus.unknown,
    ),
    //QUI TESTO il cubit e gli faccio fare signUp con form non validata
    act: (cubit) => cubit.signIn(),
    expect: () => const [
      SignInState(
        passwordStatus: PasswordStatus.unknown,
        emailStatus: EmailStatus.unknown,
        formStatus: FormStatus.invalid,
      ),
      SignInState(
        passwordStatus: PasswordStatus.unknown,
        emailStatus: EmailStatus.unknown,
        formStatus: FormStatus.initial,
      ),
    ],
  );
  blocTest<SignInCubit, SignInState>(
    'emits [submissionInProgress, submissionSuccess] when signIn is successful',
    setUp: () {
      when(mockSignInUsecase(any)).thenAnswer(
        (_) => Future.value(
          const AuthUser(id: 'id', email: 'test@test.com'),
        ),
      );
    },
    build: () => SignInCubit(signInUsecase: mockSignInUsecase),
    seed: () => SignInState(
      email: Email((e) => e..value = 'test@test.com'),
      password: Password((p) => p..value = 'password123'),
      passwordStatus: PasswordStatus.valid,
      emailStatus: EmailStatus.valid,
    ),
    act: (cubit) => cubit.signIn(),
    expect: () => [
      SignInState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
        formStatus: FormStatus.submissionInProgress,
      ),
      SignInState(
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
      verify(mockSignInUsecase(any)).called(1);
    },
  );
  blocTest<SignInCubit, SignInState>(
    'emits [submissionInProgress, submissionFailure] when signIn is NOT successful',
    setUp: () {
      when(mockSignInUsecase(any)).thenThrow(Exception());
    },
    build: () => SignInCubit(signInUsecase: mockSignInUsecase),
    seed: () => SignInState(
      email: Email((e) => e..value = 'test@test.com'),
      password: Password((p) => p..value = 'password123'),
      passwordStatus: PasswordStatus.valid,
      emailStatus: EmailStatus.valid,
    ),
    act: (cubit) => cubit.signIn(),
    //mi aspetto PRIMA in Progress POI Failure
    expect: () => [
      SignInState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
        formStatus: FormStatus.submissionInProgress,
      ),
      SignInState(
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
      verify(mockSignInUsecase(any)).called(1);
    },
  );
}
