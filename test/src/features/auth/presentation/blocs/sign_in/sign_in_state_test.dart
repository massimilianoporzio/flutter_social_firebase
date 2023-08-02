import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInState', () {
    test('should correctly copy state with new valid email', () {
      //creo stato iniziale
      const initialState = SignInState.initial();
      //nuova email
      final email = Email(
        (p0) => p0.value = "test@test.com",
      );
      final newState = initialState.copyWith(
        email: email,
        emailStatus: EmailStatus.valid,
      );
      expect(newState.email, equals(email));
      expect(newState.emailStatus, equals(EmailStatus.valid));
    });

    test('should NOT update the state if email is invalid', () {
      //creo stato iniziale
      const initialState = SignInState.initial();
      //nuova email
      try {
        final email = Email(
          (p0) => p0.value = "test",
        ); //questo già dovrebbe andare in eccezione
        final newState = initialState.copyWith(
          email: email,
        );
        fail('Should have thrown an ArgumentError');
      } on ArgumentError {
        expect(initialState.email, isNull);
      }
    });

    test('should correctly copy state with new valid password', () {
      //creo stato iniziale
      const initialState = SignInState.initial();
      //nuova email
      final password = Password(
        (p0) => p0.value = "pippo123",
      );
      final newState = initialState.copyWith(
        password: password,
        passwordStatus: PasswordStatus.valid,
      );
      expect(newState.password, equals(password));
      expect(newState.passwordStatus, equals(PasswordStatus.valid));
    });

    test('should NOT update the state if password is invalid', () {
      //creo stato iniziale
      const initialState = SignInState.initial();
      //nuova email
      try {
        final password = Password(
          (p0) => p0.value = "pass", //invalid password
        ); //questo già dovrebbe andare in eccezione
        final newState = initialState.copyWith(
          password: password,
        );
        fail('Should have thrown an ArgumentError');
      } on ArgumentError {
        expect(initialState.password, isNull);
      }
    });
    test('should correctly copy state with new formStatus', () {
      const initialState = SignInState.initial();
      final newState =
          initialState.copyWith(formStatus: FormStatus.submissionInProgress);
      expect(newState.formStatus, equals(FormStatus.submissionInProgress));
      // The other fields do not change
      expect(newState.email, equals(initialState.email));
      expect(newState.password, equals(initialState.password));
      expect(newState.emailStatus, equals(initialState.emailStatus));
      expect(newState.passwordStatus, equals(initialState.passwordStatus));
    });
  });
}
