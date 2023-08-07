import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/switch_theme_usecase.dart';
import 'package:flutter_social_firebase/src/shared/app/blocs/app/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'switch_theme_usecase_test.mocks.dart' as switchMocks;

@GenerateNiceMocks([
  MockSpec<ThemeRepository>(),
  MockSpec<AppBloc>(),
])
void main() {
  late switchMocks.MockThemeRepository mockThemeRepository;
  // late switchMocks.MockAppBloc mockAppBloc;
  late SwitchThemeUseCase switchThemeUseCase; //ogg da testare
  setUp(() {
    mockThemeRepository = switchMocks.MockThemeRepository();
    // mockAppBloc = switchMocks.MockAppBloc();
    switchThemeUseCase =
        SwitchThemeUseCase(themeRepository: mockThemeRepository);
  });
  const tCustomThemeDark = CustomTheme.dark;
  const tCustomThemeLight = CustomTheme.light;

  final tParamsDark = SwitchThemeParams(isDarkMode: true);
  final tParamsLight = SwitchThemeParams(isDarkMode: false);
  group('Switch Theme', () {
    test('should call the setValue method on theme repo with the right params',
        () async {
      when(mockThemeRepository.saveTheme(any)).thenAnswer(
        (realInvocation) async {}, //non fa nulla
      );

      //chiamo il caso d'uso
      await switchThemeUseCase.call(tParamsDark);

      //verifico
      verify(mockThemeRepository.saveTheme(tCustomThemeLight));

      await switchThemeUseCase.call(tParamsLight);
      verify(mockThemeRepository.saveTheme(tCustomThemeDark));
    });
  });
}
