// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

enum AppStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  final AppStatus status;
  final AuthUser authUser;
  final CustomTheme theme;

  const AppState({
    required this.status,
    required this.theme,
    this.authUser = AuthUser.empty,
  });

  const AppState.authenticated(AuthUser authUser, {required CustomTheme theme})
      : this(status: AppStatus.authenticated, authUser: authUser, theme: theme);

  const AppState.unauthenticated({required CustomTheme theme})
      : this(status: AppStatus.unauthenticated, theme: theme);

  @override
  List<Object?> get props => [status, authUser, theme];

  AppState copyWith({
    AppStatus? status,
    AuthUser? authUser,
    CustomTheme? theme,
  }) {
    return AppState(
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
      theme: theme ?? this.theme,
    );
  }
}
