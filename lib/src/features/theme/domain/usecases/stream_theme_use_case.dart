import 'dart:async';

import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';

import '../../../../shared/domain/usecases/base_usecase.dart';

class StreamThemeUsecase extends UseCase<Stream<CustomTheme>, NoParams> {
  final ThemeRepository _themeRepository;
  StreamThemeUsecase({
    required ThemeRepository themeRepository,
  }) : _themeRepository = themeRepository;

  @override
  FutureOr<Stream<CustomTheme>> call(NoParams params) {
    try {
      return _themeRepository.currentThemeStream;
    } catch (error) {
      throw Exception(error);
    }
  }
}
