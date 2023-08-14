import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

class AppColorScheme {
  static Color primarySeedColor = const Color(0xFF192256);
  static Color secondarySeedColor = const Color(0xFF9C2540);

  static final ColorScheme appColorSchemeLight = SeedColorScheme.fromSeeds(
      primaryKey: primarySeedColor,
      brightness: Brightness.light,
      secondaryKey: secondarySeedColor,
      tones: FlexTones.vivid(Brightness.light));
  static final ColorScheme appColorSchemeDark = SeedColorScheme.fromSeeds(
      primaryKey: primarySeedColor,
      brightness: Brightness.dark,
      secondaryKey: secondarySeedColor,
      tones: FlexTones.vivid(Brightness.dark));
}
