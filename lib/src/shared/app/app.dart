import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/stream_auth_user_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_use_case.dart';
import 'package:loggy/loggy.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/pages/sign_in_screen.dart';
import '../../features/theme/domain/entities/custom_theme.dart';
import '../../services/service_locator.dart';
import 'blocs/app/app_bloc.dart';

class App extends StatelessWidget with UiLoggy {
  final AuthUser _authUser;
  final CustomTheme _theme;
  const App({
    required AuthUser authUser,
    required CustomTheme theme,
    super.key,
  })  : _theme = theme,
        _authUser = authUser;

  @override
  Widget build(BuildContext context) {
    loggy.debug("BUILDING APP with user: $_authUser and theme: $_theme");
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: sl<AuthRepository>()),
        RepositoryProvider.value(value: sl<ThemeRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(
              streamAuthUserUseCase: sl<StreamAuthUserUseCase>(),
              streamThemeUseCase: sl<StreamThemeUseCase>(),
              signOutUseCase: sl<SignOutUseCase>(),
              authUser: _authUser,
              customTheme: _theme,
            )
              ..add(AppUserChanged(_authUser))
              ..add(AppThemeChanged(_theme)),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture',
      themeMode: context.watch<AppBloc>().state.theme == CustomTheme.light
          ? ThemeMode.light
          : ThemeMode.dark,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SignInScreen(),
    );
  }
}
