import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/switch_theme_usecase.dart';
import 'package:flutter_social_firebase/src/logs/bloc_logger.dart';

import '../../domain/entities/custom_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> with BlocLoggy {
  final SwitchThemeUseCase _switchThemeUseCase;

  ThemeCubit({required SwitchThemeUseCase switchThemeUseCase})
      : _switchThemeUseCase = switchThemeUseCase,
        super(const ThemeState());
  // void getCurrentTheme() {
  //   _themeSubscription = _switchThemeUseCase(SwitchThemeParams(isDarkMode: _isDarkTheme)) .getTheme().listen((customTheme) {
  //     if (customTheme.name == CustomTheme.light.name) {
  //       _isDarkTheme = false;
  //       emit(state.copyWith(themeMode: ThemeMode.light));
  //     } else {
  //       _isDarkTheme = true;
  //       emit(state.copyWith(themeMode: ThemeMode.dark));
  //     }
  //   });
  // }

  void switchTheme(ThemeMode themeMode) async {
    loggy.debug("switching");
    bool isDarkMode = themeMode == ThemeMode.dark;
    await _switchThemeUseCase(SwitchThemeParams(isDarkMode: isDarkMode));
  }
}
