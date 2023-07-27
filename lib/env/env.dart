import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/.env')
abstract class Env {
  @EnviedField(varName: "FIREBASE_KEY")
  static const String firebaseKey = _Env.firebaseKey;
}
