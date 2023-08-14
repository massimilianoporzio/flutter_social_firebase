import 'dart:async';

import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';

class SwitchThemeParams extends Params {
  final bool isDarkMode;
  SwitchThemeParams({
    required this.isDarkMode,
  });
  @override
  List<Object?> get props => [isDarkMode];
}

class SwitchThemeUseCase extends UseCase<void, SwitchThemeParams> {
  final ThemeRepository themeRepository;
  SwitchThemeUseCase({
    required this.themeRepository,
  });

  @override
  Future<void> call(SwitchThemeParams params) async {
    if (params.isDarkMode) {
      themeRepository.saveTheme(CustomTheme.light);
    } else {
      themeRepository.saveTheme(CustomTheme.dark);
    }
  }
}
