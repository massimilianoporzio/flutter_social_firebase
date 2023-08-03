import 'dart:async';

import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';

class StreamThemeUseCase {
  final ThemeRepository _themeRepository;
  StreamThemeUseCase({
    required ThemeRepository themeRepository,
  }) : _themeRepository = themeRepository;

  Stream<CustomTheme> call() {
    try {
      return _themeRepository.currentThemeStream;
    } catch (error) {
      throw Exception(error);
    }
  }
}
