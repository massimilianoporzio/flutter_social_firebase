import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //*firebase
  sl.registerSingleton<firebase_auth.FirebaseAuth>(
      firebase_auth.FirebaseAuth.instance);
}
