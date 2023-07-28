import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Email email1 = Email((b) => b.value = 'test1@test.com');

  Email email2 = Email((b) => b.value = 'test2@test.com');

  Password password1 = Password((b) => b.value = "pippo123");

  Password password2 = Password((b) => b.value = "pluto456");

  test('Two SignInParams with same emails and passwords are equal', () {
    final params1 = SignInParams(email: email1, password: password1);
    final params2 = SignInParams(email: email1, password: password1);
    expect(params1, equals(params2));
  });
  test('Two SignInParams with different emails are NOT equal', () {
    final params1 = SignInParams(email: email1, password: password1);
    final params2 = SignInParams(email: email2, password: password1);
    expect(params1, isNot(equals(params2)));
  });
  test('Two SignInParams with different passwords are NOT equal', () {
    final params1 = SignInParams(email: email1, password: password1);
    final params2 = SignInParams(email: email1, password: password2);
    expect(params1, isNot(equals(params2)));
  });
  test('props returns correct properties (in order)', () {
    final params = SignInParams(email: email1, password: password1);

    expect(params.props[0] is Email, equals(true));
    expect(params.props[1] is Password, equals(true));
  });
}
