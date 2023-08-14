import 'package:flutter/material.dart';
import 'package:flutter_social_firebase/src/shared/theme/app_color_scheme.dart';
import 'package:flutter_social_firebase/src/shared/theme/app_elevated_button_theme.dart';
import 'package:flutter_social_firebase/src/shared/theme/app_text_theme.dart';

import 'app_text_button_theme.dart';

class AppTheme {
  static final ThemeData theme = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
      colorScheme: AppColorScheme.appColorSchemeLight,
      textTheme: appTextThemeLight,
      elevatedButtonTheme: appElevatedButtonThemeLight,
      textButtonTheme: appTextButtonThemeLight,
      appBarTheme: appBarThemeLight);
  static final ThemeData darkTheme = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
      colorScheme: AppColorScheme.appColorSchemeDark,
      textTheme: appTextThemeDark,
      elevatedButtonTheme: appElevatedButtonThemeDark,
      textButtonTheme: appTextButtonThemeDark,
      appBarTheme: appBarThemeDark);
}
