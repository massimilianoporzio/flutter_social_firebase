import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';

abstract interface class ThemeRepository {
  Stream<CustomTheme> getTheme();
  Future<void> saveTheme(CustomTheme theme);
  void dispose();
}
