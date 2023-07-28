import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Email email1;
  late Email email2;
  late Password password1;
  late Password password2;
  setUp(() {
    email1 = Email((b) => b.value = 'test1@test.com');

    email2 = Email((b) => b.value = 'test2@test.com');

    password1 = Password((b) => b.value = "pippo123");

    password2 = Password((b) => b.value = "pluto456");
  });

  test('Two SignUpParams with same emails and passwords are equal', () {
    final params1 = SignUpParams(email: email1, password: password1);
    final params2 = SignUpParams(email: email1, password: password1);
    expect(params1, equals(params2));
  });
  test('Two SignUpParams with different emails are NOT equal', () {
    final params1 = SignUpParams(email: email1, password: password1);
    final params2 = SignUpParams(email: email2, password: password1);
    expect(params1, isNot(equals(params2)));
  });
  test('Two SignUpParams with different passwords are NOT equal', () {
    final params1 = SignUpParams(email: email1, password: password1);
    final params2 = SignUpParams(email: email1, password: password2);
    expect(params1, isNot(equals(params2)));
  });
  test('props returns correct properties (in order)', () {
    final params = SignUpParams(email: email1, password: password1);

    expect(params.props[0] is Email, equals(true));
    expect(params.props[1] is Password, equals(true));
  });
}
