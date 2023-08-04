// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';

class StreamThemeUseCase {
  final ThemeRepository themeRepository;

  StreamThemeUseCase({required this.themeRepository});

  Stream<CustomTheme> call() {
    try {
      return themeRepository.getTheme();
    } catch (error) {
      throw Exception(error);
    }
  }
}
