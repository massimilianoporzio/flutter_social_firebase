import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

final appElevatedButtonThemeLight = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    minimumSize: const Size(100, 48),
    foregroundColor: AppColorScheme.appColorSchemeLight.primary,
    backgroundColor: AppColorScheme.appColorSchemeLight.surface,
    disabledForegroundColor:
        AppColorScheme.appColorSchemeLight.onSurface.withOpacity(0.38),
    disabledBackgroundColor:
        AppColorScheme.appColorSchemeLight.onSurface.withOpacity(0.12),
    shadowColor: AppColorScheme.appColorSchemeLight.shadow,
    surfaceTintColor: AppColorScheme.appColorSchemeLight.surfaceTint,
  ),
);

final appElevatedButtonThemeDark = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    minimumSize: const Size(100, 48),
    foregroundColor: AppColorScheme.appColorSchemeDark.primary,
    backgroundColor: AppColorScheme.appColorSchemeDark.surface,
    disabledForegroundColor:
        AppColorScheme.appColorSchemeDark.onSurface.withOpacity(0.38),
    disabledBackgroundColor:
        AppColorScheme.appColorSchemeDark.onSurface.withOpacity(0.12),
    shadowColor: AppColorScheme.appColorSchemeDark.shadow,
    surfaceTintColor: AppColorScheme.appColorSchemeDark.surfaceTint,
  ),
);
