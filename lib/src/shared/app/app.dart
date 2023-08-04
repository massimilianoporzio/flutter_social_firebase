import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/stream_auth_user_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/switch_theme_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:loggy/loggy.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/pages/sign_in_screen.dart';
import '../../features/theme/domain/entities/custom_theme.dart';
import '../../services/service_locator.dart';
import 'blocs/app/app_bloc.dart';

class App extends StatelessWidget with UiLoggy {
  final AuthUser _authUser;
  final ThemeMode _themeMode;

  const App({
    required AuthUser authUser,
    required CustomTheme initialTheme,
    super.key,
  })  : _authUser = authUser,
        _themeMode =
            initialTheme == CustomTheme.dark ? ThemeMode.dark : ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    loggy.debug("BUILDING APP with user: $_authUser");
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: sl<AuthRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (context) =>
                ThemeCubit(switchThemeUseCase: sl<SwitchThemeUseCase>()),
          ),
          BlocProvider<SignInCubit>(
            create: (context) => sl<SignInCubit>(),
          )
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
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Clean Architecture',
          themeMode: state.themeMode,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const SignInScreen(),
        );
      },
    );
  }
}
