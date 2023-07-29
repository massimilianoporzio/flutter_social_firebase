import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty Auth User has correct default values', () {
    expect(AuthUser.empty.id, equals(''));
    expect(AuthUser.empty.email, equals(''));
    expect(AuthUser.empty.name, equals(''));
    expect(AuthUser.empty.photoURL, equals(''));
  });

  test('Two Auth User with same values are equal', () {
    const user1 =
        AuthUser(id: "id", email: "email", name: "name", photoURL: 'photoURL');

    const user2 =
        AuthUser(id: "id", email: "email", name: "name", photoURL: 'photoURL');

    expect(user1, equals(user2));
  });

  test('Two Auth User with different id values are NOT equal', () {
    const user1 =
        AuthUser(id: "id1", email: "email", name: "name", photoURL: 'photoURL');

    const user2 =
        AuthUser(id: "id2", email: "email", name: "name", photoURL: 'photoURL');

    expect(user1, isNot(equals(user2)));
  });
  test('Two Auth User with different email values are NOT equal', () {
    const user1 =
        AuthUser(id: "id", email: "email1", name: "name", photoURL: 'photoURL');

    const user2 =
        AuthUser(id: "id", email: "email2", name: "name", photoURL: 'photoURL');

    expect(user1, isNot(equals(user2)));
  });
  test('Two Auth User with different name values are NOT equal', () {
    const user1 =
        AuthUser(id: "id", email: "email", name: "name1", photoURL: 'photoURL');

    const user2 =
        AuthUser(id: "id", email: "email", name: "name2", photoURL: 'photoURL');

    expect(user1, isNot(equals(user2)));
  });
  test('Two Auth User with different photoURL values are NOT equal', () {
    const user1 =
        AuthUser(id: "id", email: "email", name: "name", photoURL: 'photoURL1');

    const user2 =
        AuthUser(id: "id", email: "email", name: "name", photoURL: 'photoURL2');

    expect(user1, isNot(equals(user2)));
  });

  test('props returns correct properties (in order)', () {
    const user =
        AuthUser(id: "id", email: "email", name: "name", photoURL: "photoURL");
    expect(user.props, ["id", "email", "name", "photoURL"]);
  });

  test("photoURL and name can be null", () {
    const user = AuthUser(id: "id", email: "email");
    expect(user.name, isNull);
    expect(user.photoURL, isNull);
  });
}
