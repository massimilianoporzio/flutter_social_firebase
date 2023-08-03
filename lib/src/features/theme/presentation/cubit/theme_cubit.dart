import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';

import '../../domain/entities/custom_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository _themeRepository;

  static late bool _isDarkTheme;
  ThemeCubit({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository,
        super(const ThemeState());
  // void getCurrentTheme() {
  //   _themeSubscription =
  //       _themeRepository.currentThemeStream.listen((customTheme) {
  //     if (customTheme.name == CustomTheme.light.name) {
  //       _isDarkTheme = false;
  //       emit(state.copyWith(themeMode: ThemeMode.light));
  //     } else {
  //       _isDarkTheme = true;
  //       emit(state.copyWith(themeMode: ThemeMode.dark));
  //     }
  //   });
  // }

  void switchTheme() {
    if (_isDarkTheme) {
      _themeRepository.saveTheme(CustomTheme.light); //salvo light
    } else {
      _themeRepository.saveTheme(CustomTheme.dark);
    }
  }

  //per siurezza ma lo userò come singleton come AuthBloc
  @override
  Future<void> close() {
    _themeRepository.dispose();
    return super.close();
  }
}
