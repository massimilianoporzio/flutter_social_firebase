// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_social_firebase/firebase_options.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';

import 'package:flutter_social_firebase/src/services/service_locator.dart'
    as di;
import 'package:loggy/loggy.dart';

import 'src/services/service_locator.dart';
import 'src/shared/app/app.dart';

typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: const String.fromEnvironment("DARTDEFINE_APP_NAME"),
      options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  //iniziallizza il logger con la stampa a video colorata
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(),
  );
  runApp(await builder());
}

void main() {
  bootstrap(
    () async {
      return App(
          authUser: await sl<AuthRepository>()
              .authUserStream
              .first, //recupero il primo dallo stream e smetto di ascoltare
          theme: await sl<ThemeRepository>()
              .currentThemeStream
              .first); //init da shared_prefs
    },
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clean Architecture')),
      body: const Column(children: []),
    );
  }
}
