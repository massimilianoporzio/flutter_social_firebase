import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_screen.dart';
import '../app/blocs/app/app_bloc.dart';

class AppRouter {
  final AppBloc appBloc;
  AppRouter(this.appBloc);

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: 'sign-in',
        path: '/',
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
          child: const SignInScreen(),
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
  );
}
