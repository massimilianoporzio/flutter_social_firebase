import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_use_case.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';

import '../../../../features/auth/domain/entities/auth_user.dart';
import '../../../../features/auth/domain/usecases/stream_auth_user_usecase.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final StreamAuthUserUseCase _streamAuthUserUseCase;
  final StreamThemeUseCase _streamThemeUseCase;
  final SignOutUseCase _signOutUseCase;
  late StreamSubscription<AuthUser> _authUserSubscription;
  late StreamSubscription<CustomTheme> _themSubscription;

  AppBloc({
    required StreamAuthUserUseCase streamAuthUserUseCase,
    required StreamThemeUseCase streamThemeUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthUser authUser,
    required CustomTheme customTheme,
  })  : _streamAuthUserUseCase = streamAuthUserUseCase,
        _streamThemeUseCase = streamThemeUseCase,
        _signOutUseCase = signOutUseCase,
        super(
          authUser == AuthUser.empty
              ? AppState.unauthenticated(theme: customTheme)
              : AppState.authenticated(authUser, theme: customTheme),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppSignOutRequested>(_onSignOutRequested);
    on<AppThemeChanged>(_onThemeChanged);

    _authUserSubscription = _streamAuthUserUseCase().listen(_userChanged);
    _themSubscription = _streamThemeUseCase().listen(_themeChanged);
  }

  void _userChanged(AuthUser authUser) => add(AppUserChanged(authUser));
  void _themeChanged(CustomTheme theme) => add(AppThemeChanged(theme));

  void _onThemeChanged(AppThemeChanged event, Emitter<AppState> emit) {
    return event.theme == CustomTheme.light
        ? emit(state.copyWith(theme: CustomTheme.light))
        : emit(state.copyWith(theme: CustomTheme.dark));
  }

  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    return event.authUser.isEmpty
        ? emit(AppState.unauthenticated(theme: state.theme))
        : emit(AppState.authenticated(event.authUser, theme: state.theme));
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
    _themSubscription.cancel();
    return super.close();
  }
}
