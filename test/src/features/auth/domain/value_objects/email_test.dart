import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email', () {
    test('Valid email does not throw exception', () {
      expect(
          () => Email(
                (b) => b.value = 'test@test.com',
              ),
          returnsNormally); //creazione usando il builder di Built_value
    });
    test('Invalid email throw exception', () {
      expect(
          () => Email(
                (b) => b.value = 'test@test.',
              ),
          throwsArgumentError); //creazione usando il builder di Built_value
    });
    test('email value is correctly set', () {
      final Email email = Email(
        (p0) => p0.value = "test@test.com",
      );
      expect(email.value, equals("test@test.com"));
    });

    test('Two Email instances with the same argument are equal', () {
      final email1 = Email(
        (p0) => p0.value = "test@test.com",
      );
      final email2 = Email(
        (p0) => p0.value = "test@test.com",
      );
      expect(email1, equals(email2));
    });
    test('Two Email instances with different values are NOT equal', () {
      final email1 = Email(
        (p0) => p0.value = "test1@test.com",
      );
      final email2 = Email(
        (p0) => p0.value = "test2@test.com",
      );
      expect(email1, isNot(equals(email2)));
    });
  });
}
