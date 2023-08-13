import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social_firebase/main.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_screen.dart';
import '../../features/auth/presentation/pages/sign_up_screen.dart';
import '../app/app.dart';
import '../app/blocs/app/app_bloc.dart';

class AppRouter {
  final AppBloc appBloc;
  AppRouter(this.appBloc);

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        name: 'sign-in',
        path: '/sign-in',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignInScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        name: 'sign-up',
        path: '/sign-up',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      // GoRoute(
      //   name: 'feed',
      //   path: '/feed',
      //   pageBuilder: (context, state) => CustomTransitionPage<void>(
      //     key: state.pageKey,
      //     child: const FeedScreen(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      //         FadeTransition(opacity: animation, child: child),
      //   ),
      // ),
      // GoRoute(
      //   name: 'chats',
      //   path: '/chats',
      //   pageBuilder: (context, state) => CustomTransitionPage<void>(
      //     key: state.pageKey,
      //     child: const ChatListScreen(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      //         FadeTransition(opacity: animation, child: child),
      //   ),
      //   routes: [
      //     GoRoute(
      //       name: 'chat',
      //       path: ':chatId',
      //       pageBuilder: (context, state) => CustomTransitionPage<void>(
      //         key: state.pageKey,
      //         child: ChatScreen(
      //           chatId: state.pathParameters['chatId']!,
      //         ),
      //         transitionsBuilder:
      //             (context, animation, secondaryAnimation, child) =>
      //                 FadeTransition(opacity: animation, child: child),
      //       ),
      //     ),
      //   ],
      // ),
    ],
    redirect: (context, state) {
      final bool isAuthenticated =
          appBloc.state.status == AppStatus.authenticated;
      final bool isSignIn = state.matchedLocation == '/sign-in';
      final bool isSignUp = state.matchedLocation == '/sign-up';
      //if user is not authenticated, redirect to sign-in or sign-up
      if (!isAuthenticated) {
        return isSignUp ? '/sign-up' : '/sign-in';
      }
      //if user is authenticated e prova a fare logIn lo mando alla home
      if (isAuthenticated && isSignIn) {
        return '/';
      }
      if (isAuthenticated && isSignUp) {
        return '/';
      }
      //altri casi: non fa redirect
      return null;
    },
    refreshListenable: GoRouterRefreshStream(appBloc.stream),
  );
}

/// Converts a [Stream] into a [Listenable]
///
/// {@tool snippet}
/// Typical usage is as follows:
///
/// ```dart
/// GoRouter(
///  refreshListenable: GoRouterRefreshStream(stream),
/// );
/// ```
/// {@end-tool}
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] receives an event the [GoRouter] will refresh its
  /// current route.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
