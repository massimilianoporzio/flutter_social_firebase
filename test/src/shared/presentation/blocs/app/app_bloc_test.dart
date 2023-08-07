import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/stream_auth_user_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/switch_theme_usecase.dart';
import 'package:flutter_social_firebase/src/shared/app/blocs/app/app_bloc.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<StreamAuthUserUseCase>(),
  MockSpec<StreamThemeUseCase>(),
  MockSpec<SignOutUseCase>(),
  MockSpec<SwitchThemeUseCase>(),
])
void main() {
  late MockStreamAuthUserUseCase mockStreamAuthUserUseCase;
  late MockStreamThemeUseCase mockStreamThemeUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockSwitchThemeUseCase mockSwitchThemeUseCase;

  const initialMode = ThemeMode.dark;

  const tAuthUser = AuthUser(id: 'testId', email: 'test@test.com');

  setUp(() {
    mockSignOutUseCase = MockSignOutUseCase();
    mockStreamAuthUserUseCase = MockStreamAuthUserUseCase();
    mockStreamThemeUseCase = MockStreamThemeUseCase();
    mockSwitchThemeUseCase = MockSwitchThemeUseCase();

    // when(mockStreamThemeUseCase.call())
    //     .thenAnswer((realInvocation) => Stream.value(CustomTheme.light));

    //ogg di test
  });
  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits [] when nothing is added.',
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          streamThemeUseCase: mockStreamThemeUseCase,
          signOutUseCase: mockSignOutUseCase,
          authUser: tAuthUser,
          initialMode: initialMode),
      expect: () => const <AppState>[],
    );
    blocTest('emits  [unauthenticated] when the user is empty',
        setUp: () {
          when(mockStreamAuthUserUseCase())
              .thenAnswer((_) => Stream.value(AuthUser.empty));
        },
        build: () => AppBloc(
            streamAuthUserUseCase: mockStreamAuthUserUseCase,
            streamThemeUseCase: mockStreamThemeUseCase,
            signOutUseCase: mockSignOutUseCase,
            authUser: AuthUser.empty,
            initialMode: ThemeMode.light),
        expect: () => const [AppState.unauthenticated()]);

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when the user is not empty',
      setUp: () {
        when(mockStreamAuthUserUseCase()).thenAnswer(
          (_) => Stream.value(tAuthUser),
        );
      },
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          streamThemeUseCase: mockStreamThemeUseCase,
          authUser: tAuthUser,
          initialMode: ThemeMode.light),
      expect: () => const [AppState.authenticated(tAuthUser)],
    );
    blocTest<AppBloc, AppState>(
      'emits [authenticated: themeMode.dark] when the user is not empty and intialTheme is dark',
      setUp: () {
        when(mockStreamAuthUserUseCase()).thenAnswer(
          (_) => Stream.value(tAuthUser),
        );
      },
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          streamThemeUseCase: mockStreamThemeUseCase,
          authUser: tAuthUser,
          initialMode: ThemeMode.dark),
      expect: () => [
        const AppState.authenticated(tAuthUser)
            .copyWith(themeMode: ThemeMode.dark)
      ],
    );
    blocTest<AppBloc, AppState>(
      'emits [authenticated] when user sign in',
      setUp: () {
        when(mockStreamAuthUserUseCase()).thenAnswer(
          (_) => Stream.value(tAuthUser),
        );
      },
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          authUser: AuthUser.empty,
          initialMode: ThemeMode.light,
          streamThemeUseCase: mockStreamThemeUseCase),
      act: (bloc) => bloc.add(
        const AppUserChanged(
          AuthUser(id: 'testId', email: 'test@test.com'),
        ),
      ),
      expect: () => [
        const AppState.authenticated(
            AuthUser(id: 'testId', email: 'test@test.com'))
      ],
      verify: (_) {
        verify(mockStreamAuthUserUseCase()).called(1);
      },
    );
    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when user sign out and invokes signOut',
      setUp: () {
        when(mockSignOutUseCase.call(NoParams())).thenAnswer(
          (_) => Future.value(),
        );
        when(mockStreamAuthUserUseCase()).thenAnswer(
          (_) => Stream.value(AuthUser.empty),
        );
      },
      build: () => AppBloc(
        streamAuthUserUseCase: mockStreamAuthUserUseCase,
        initialMode: ThemeMode.light,
        streamThemeUseCase: mockStreamThemeUseCase,
        signOutUseCase: mockSignOutUseCase,
        authUser: const AuthUser(id: 'testId', email: 'test@test.com'),
      ),
      act: (bloc) => bloc.add(const AppSignOutRequested()),
      expect: () => const [AppState.unauthenticated()],
      verify: (_) {
        verify(mockSignOutUseCase(NoParams())).called(1);
      },
    );
    blocTest<AppBloc, AppState>(
      'emits [authenticated] when user sign in, does not emit again if the event is added twice',
      setUp: () {
        when(mockStreamAuthUserUseCase()).thenAnswer(
          (_) => Stream.value(tAuthUser),
        );
      },
      build: () => AppBloc(
        streamAuthUserUseCase: mockStreamAuthUserUseCase,
        initialMode: ThemeMode.light,
        signOutUseCase: mockSignOutUseCase,
        streamThemeUseCase: mockStreamThemeUseCase,
        authUser: AuthUser.empty,
      ),
      act: (bloc) => bloc
        ..add(const AppUserChanged(
          AuthUser(id: 'testId', email: 'test@test.com'),
        ))
        ..add(const AppUserChanged(
          AuthUser(id: 'testId', email: 'test@test.com'),
        )),
      expect: () => [
        const AppState.authenticated(
            AuthUser(id: 'testId', email: 'test@test.com'))
      ],
    );
    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when user sign out, does not emit again if the event is added twice',
      setUp: () {
        when(mockSignOutUseCase(NoParams())).thenAnswer(
          (_) => Future.value(),
        );
        when(mockStreamAuthUserUseCase())
            .thenAnswer((_) => Stream.value(AuthUser.empty));
      },
      build: () => AppBloc(
        streamAuthUserUseCase: mockStreamAuthUserUseCase,
        initialMode: ThemeMode.light,
        streamThemeUseCase: mockStreamThemeUseCase,
        signOutUseCase: mockSignOutUseCase,
        authUser: const AuthUser(id: 'testId', email: 'test@test.com'),
      ),
      act: (bloc) => bloc
        ..add(const AppSignOutRequested())
        ..add(const AppSignOutRequested()),
      expect: () => const [AppState.unauthenticated()],
    );
    blocTest<AppBloc, AppState>(
      'emits [themeMode: dark] when user switch from light',
      setUp: () {},
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          authUser: AuthUser.empty,
          initialMode: ThemeMode.light,
          streamThemeUseCase: mockStreamThemeUseCase),
      act: (bloc) => bloc.add(
        const AppThemeChanged(
          CustomTheme.dark,
        ),
      ),
      expect: () => [
        const AppState(
            status: AppStatus.unauthenticated,
            authUser: AuthUser.empty,
            themeMode: ThemeMode.dark)
      ],
      verify: (_) {
        verify(mockStreamAuthUserUseCase()).called(1);
      },
    );
    blocTest<AppBloc, AppState>(
      'emits [themeMode: light] when user switch from dark',
      setUp: () {},
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          authUser: AuthUser.empty,
          initialMode: ThemeMode.dark,
          streamThemeUseCase: mockStreamThemeUseCase),
      act: (bloc) => bloc.add(
        const AppThemeChanged(
          CustomTheme.light,
        ),
      ),
      expect: () => [
        const AppState(
            status: AppStatus.unauthenticated,
            authUser: AuthUser.empty,
            themeMode: ThemeMode.light)
      ],
      verify: (_) {
        verify(mockStreamAuthUserUseCase()).called(1);
      },
    );
    blocTest<AppBloc, AppState>(
      'emits [themeMode: light] when user switch from dark,does not emit again if the event is added twice ',
      setUp: () {},
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          authUser: AuthUser.empty,
          initialMode: ThemeMode.dark,
          streamThemeUseCase: mockStreamThemeUseCase),
      act: (bloc) => bloc
        ..add(const AppThemeChanged(
          CustomTheme.light,
        ))
        ..add(
          const AppThemeChanged(
            CustomTheme.light,
          ),
        ),
      expect: () => [
        const AppState(
            status: AppStatus.unauthenticated,
            authUser: AuthUser.empty,
            themeMode: ThemeMode.light)
      ],
    );
    blocTest<AppBloc, AppState>(
      'emits [themeMode: dark] when user switch from light,does not emit again if the event is added twice ',
      setUp: () {},
      build: () => AppBloc(
          streamAuthUserUseCase: mockStreamAuthUserUseCase,
          signOutUseCase: mockSignOutUseCase,
          authUser: AuthUser.empty,
          initialMode: ThemeMode.light,
          streamThemeUseCase: mockStreamThemeUseCase),
      act: (bloc) => bloc
        ..add(const AppThemeChanged(
          CustomTheme.dark,
        ))
        ..add(
          const AppThemeChanged(
            CustomTheme.dark,
          ),
        ),
      expect: () => [
        const AppState(
            status: AppStatus.unauthenticated,
            authUser: AuthUser.empty,
            themeMode: ThemeMode.dark)
      ],
    );
  });
}
