import 'package:flutter/material.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/shared/app/blocs/app/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    test('creates an unknown AppState by default', () {
      const state = AppState(status: AppStatus.unknown);

      expect(state.status, AppStatus.unknown);
      expect(state.authUser, AuthUser.empty);
    });
    test('should correctly copy state with new valid authenticated status', () {
      const tAuthUser = AuthUser(id: 'testId', email: "test@test.com");
      //stato iniziale

      const initialState = AppState(status: AppStatus.unknown);
      //nuovo stato authenticated
      final newState = initialState.copyWith(
          authUser: tAuthUser, status: AppStatus.authenticated);
      expect(newState.authUser, equals(tAuthUser));
      expect(newState.status, equals(AppStatus.authenticated));
    });
    test('should correctly copy state with new valid UNauthenticated status',
        () {
      //stato iniziale
      const initialState = AppState(status: AppStatus.unknown);
      //nuovo stato authenticated
      final newState = initialState.copyWith(
          authUser: AuthUser.empty, status: AppStatus.unauthenticated);
      expect(newState.authUser, equals(AuthUser.empty));
      expect(newState.status, equals(AppStatus.unauthenticated));
    });
    test('should correctly copy state with new valid ThemeMode', () {
      //stato iniziale
      const initialState =
          AppState(status: AppStatus.unknown, themeMode: ThemeMode.light);
      //nuovo stato authenticated
      final newState = initialState.copyWith(themeMode: ThemeMode.dark);

      expect(newState.themeMode, equals(ThemeMode.dark));
    });
    test('should correctly create Unauthenticated state', () {
      //stato iniziale
      const initialState = AppState.unauthenticated();
      expect(initialState.authUser, equals(AuthUser.empty));
      expect(initialState.status, equals(AppStatus.unauthenticated));
      expect(initialState.themeMode, equals(ThemeMode.light));
    });
    test('should correctly create Authenicated state', () {
      const tAuthUser = AuthUser(id: 'testId', email: "test@test.com");
      //stato iniziale
      const initialState = AppState.authenticated(tAuthUser);
      expect(initialState.authUser, equals(tAuthUser));
      expect(initialState.status, equals(AppStatus.authenticated));
      expect(initialState.themeMode, equals(ThemeMode.light));
    });
    test('props contains all properties', () {
      const tAuthUser = AuthUser(id: 'testId', email: "test@test.com");
      const state = AppState(
        status: AppStatus.authenticated,
        authUser: tAuthUser,
      );

      expect(
          state.props, [AppStatus.authenticated, tAuthUser, ThemeMode.light]);
    });
  });
}
