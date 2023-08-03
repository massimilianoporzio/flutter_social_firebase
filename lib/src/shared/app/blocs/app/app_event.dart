// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.authUser);

  final AuthUser authUser;

  @override
  List<Object> get props => [authUser];
}

class AppSignOutRequested extends AppEvent {
  const AppSignOutRequested();
}

class AppThemeChanged extends AppEvent {
  final CustomTheme theme;
  const AppThemeChanged(
    this.theme,
  );
}
