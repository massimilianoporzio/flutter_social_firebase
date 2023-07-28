import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password', () {
    test('Valid Password does not throw exception', () {
      expect(
          () => Password(
                (b) => b.value = 'pippo123',
              ),
          returnsNormally); //creazione usando il builder di Built_value
    });
    group('Invalid Password does throw exception', () {
      test("less than 8 characters", () {
        expect(
            () => Password(
                  (b) => b.value = 'pippo',
                ),
            throwsArgumentError);
      }); //creazione usando il builder di Built_value);}
      test("Not alphanumeric", () {
        expect(
            () => Password(
                  (b) => b.value = 'pippo!',
                ),
            throwsArgumentError);
      });
    });
  });

  test('password value is correctly set', () {
    final Password email = Password(
      (p0) => p0.value = "pippo123",
    );
    expect(email.value, equals("pippo123"));
  });

  test('Two Password instances with the same argument are equal', () {
    final email1 = Password(
      (p0) => p0.value = "pippo123",
    );
    final email2 = Password(
      (p0) => p0.value = "pippo123",
    );
    expect(email1, equals(email2));
  });
  test('Two Password instances with different values are NOT equal', () {
    final email1 = Password(
      (p0) => p0.value = "pippo123",
    );
    final email2 = Password(
      (p0) => p0.value = "Paperino123",
    );
    expect(email1, isNot(equals(email2)));
  });
}
