import 'package:flutter_social_firebase/src/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:flutter_social_firebase/src/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'theme_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ThemeLocalDatasource>()])
void main() {
  //test
  late MockThemeLocalDatasource mockLocalDatasource;

  late ThemeRepositoryImpl themeRepository;
  const tCustomThemeLight = CustomTheme.light;
  const tCustomThemeDark = CustomTheme.dark;
  setUp(() {
    mockLocalDatasource = MockThemeLocalDatasource();
    // when(mockLocalDatasource.getValue(any)).thenReturn(tCustomThemeLight.name);
    themeRepository = ThemeRepositoryImpl(localDatasource: mockLocalDatasource);
  });

  group('currentThemeStream', () {
    test('return [CustomTheme.light] as results of init()', () async {
      //chiamo
      final theme = await themeRepository.getTheme().first;
      //verifico
      expect(theme, tCustomThemeLight);
    });
  });
  group('SaveTheme', () {
    test('Save correctly a theme', () async {
      //testo
      await themeRepository.saveTheme(tCustomThemeDark);
      //verifico che tra gli emessi ci sia dark
      // expect(
      //     themeRepository.currentThemeStream, emitsThrough(CustomTheme.dark));
      //meglio verifico che nell'ordine ci siano light (quando creo il repo)
      //e poi dark (che ho appena scritto)
      expect(themeRepository.getTheme(),
          emitsInOrder([CustomTheme.light, CustomTheme.dark]));
    });
    test('Should throw an exception when themeRepo throws an Exception',
        () async {
      when(mockLocalDatasource.setValue(any, any)).thenThrow(Exception());
      //testo e verifico
      expect(() async => await themeRepository.saveTheme(CustomTheme.dark),
          throwsException);
    });
  });
}
