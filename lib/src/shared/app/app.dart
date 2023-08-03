import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/pages/sign_in_screen.dart';

class App extends StatelessWidget {
  final AuthUser _authUser;
  const App({
    required AuthUser authUser,
    super.key,
  }) : _authUser = authUser;

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture',
      themeMode: ThemeMode.light,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SignInScreen(),
    );
  }
}
