part of 'app_bloc.dart';

enum AppStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  final AppStatus status;
  final AuthUser authUser;
  final CustomTheme customTheme;

  const AppState({
    required this.status,
    this.authUser = AuthUser.empty,
    this.customTheme = CustomTheme.light,
  });

  @override
  List<Object> get props => [];
}
