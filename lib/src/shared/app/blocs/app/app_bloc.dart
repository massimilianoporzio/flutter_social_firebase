import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/switch_theme_usecase.dart';
import 'package:flutter_social_firebase/src/logs/bloc_logger.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';

import '../../../../features/auth/domain/entities/auth_user.dart';
import '../../../../features/auth/domain/usecases/stream_auth_user_usecase.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> with BlocLoggy {
  final StreamAuthUserUseCase _streamAuthUserUseCase;
  final StreamThemeUseCase _streamThemeUseCase;
  final SignOutUseCase _signOutUseCase;
  late StreamSubscription<AuthUser> _authUserSubscription;
  late StreamSubscription<CustomTheme> _themeSubscription;

  AppBloc({
    required StreamAuthUserUseCase streamAuthUserUseCase,
    required StreamThemeUseCase streamThemeUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthUser authUser,
    required ThemeMode initialMode,
  })  : _streamAuthUserUseCase = streamAuthUserUseCase,
        _streamThemeUseCase = streamThemeUseCase,
        _signOutUseCase = signOutUseCase,
        super(
          authUser == AuthUser.empty
              ? const AppState.unauthenticated()
                  .copyWith(themeMode: initialMode)
              : AppState.authenticated(
                  authUser,
                ).copyWith(themeMode: initialMode),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppSignOutRequested>(_onSignOutRequested);
    on<AppThemeChanged>(_onThemeChanged);

    _authUserSubscription = _streamAuthUserUseCase().listen(_userChanged);
    _themeSubscription = _streamThemeUseCase().listen(_themeChanged);
  }

  void _userChanged(AuthUser authUser) {
    loggy.debug('User changed');
    add(AppUserChanged(authUser));
  }

  void _themeChanged(CustomTheme theme) {
    ThemeMode themeMode =
        theme == CustomTheme.dark ? ThemeMode.dark : ThemeMode.light;
    if (themeMode != state.themeMode) {
      loggy.debug("THEME CHANGED!");
      return add(AppThemeChanged(theme));
    }
  }

  void _onThemeChanged(AppThemeChanged event, Emitter<AppState> emit) {
    return event.theme == CustomTheme.light
        ? emit(state.copyWith(themeMode: ThemeMode.light))
        : emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    return event.authUser.isEmpty
        ? emit(state.copyWith(
            authUser: AuthUser.empty, status: AppStatus.unauthenticated))
        : emit(state.copyWith(
            authUser: event.authUser,
            status: AppStatus.authenticated,
          ));
  }

  void _onSignOutRequested(
    AppSignOutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_signOutUseCase(NoParams()));
  }

  @override
  Future<void> close() {
    _authUserSubscription.cancel();
    _themeSubscription.cancel();
    return super.close();
  }
}
