import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';

import '../../../../features/auth/domain/entities/auth_user.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState(status: AppStatus.unknown)) {
    on<AppEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
