import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/pages/sign_in_screen.dart';

class App extends StatelessWidget {
  final AuthUser? authUser;
  const App({
    Key? key,
    this.authUser,
  }) : super(key: key);

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
