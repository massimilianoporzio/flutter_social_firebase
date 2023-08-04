// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

enum AppStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  final AppStatus status;
  final AuthUser authUser;
  final ThemeMode themeMode;

  const AppState({
    required this.status,
    this.authUser = AuthUser.empty,
    this.themeMode = ThemeMode.light, //default
  });

  const AppState.authenticated(AuthUser authUser)
      : this(
          status: AppStatus.authenticated,
          authUser: authUser,
        );

  const AppState.unauthenticated()
      : this(
          status: AppStatus.unauthenticated,
        );

  @override
  List<Object?> get props => [status, authUser, themeMode];

  AppState copyWith({
    AppStatus? status,
    AuthUser? authUser,
    ThemeMode? themeMode,
  }) {
    return AppState(
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
