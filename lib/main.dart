// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_social_firebase/firebase_options.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/stream_auth_user_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/switch_theme_usecase.dart';

import 'package:flutter_social_firebase/src/services/service_locator.dart'
    as di;
import 'package:flutter_social_firebase/src/shared/app/blocs/app/app_bloc.dart';
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
      final user = await sl<AuthRepository>().authUserStream.first;
      final initialTheme = await ThemeRepositoryImpl(localDatasource: sl())
          .getTheme()
          .first; //leggo lo stream da UN ALTRA ISTANZA DI REPO
      return BlocProvider<AppBloc>(
        create: (context) => AppBloc(
            streamAuthUserUseCase: sl<StreamAuthUserUseCase>(),
            streamThemeUseCase: sl<StreamThemeUseCase>(),
            signOutUseCase: sl<SignOutUseCase>(),
            authUser: user,
            initialMode: initialTheme == CustomTheme.dark
                ? ThemeMode.dark
                : ThemeMode.light)
          ..add(AppUserChanged(user))
          ..add(AppThemeChanged(initialTheme)),
        child: App(
          authUser: user,
          initialTheme: initialTheme,
        ),
      ); //init da shared_prefs
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
