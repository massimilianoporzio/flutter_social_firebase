import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/usecases/stream_theme_use_case.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_theme_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ThemeRepository>()])
void main() {
  late MockThemeRepository mockThemeRepository;
  late StreamThemeUseCase streamThemeUsecase; //ogg del test
  setUp(() {
    mockThemeRepository = MockThemeRepository();
    streamThemeUsecase =
        StreamThemeUseCase(themeRepository: mockThemeRepository);
  });
  const tCustomTheme = CustomTheme.dark;
  test('should call the getter on theme repo', () {
    when(mockThemeRepository.currentThemeStream)
        .thenAnswer((realInvocation) => Stream.value(tCustomTheme));
    //CHIAMO IL CASO D'USO
    streamThemeUsecase.call();
    //VERIFICO SIA CHIAMATO
    verify(mockThemeRepository.currentThemeStream);
  });

  test(
      'should throw an exception when auth repo (themeStream getter) throws an Exception',
      () {
    when(mockThemeRepository.currentThemeStream).thenThrow(Exception());
    final call = streamThemeUsecase.call;
    expect(() => call(), throwsA(isA<Exception>()));
  });
  test(
      'should return the CORRECT CustomTheme when the getter on Theme repo return a CustomTheme',
      () async {
    //definisco come risponde il mock repo: con tauthUser (email: 'test@test.com'....)
    when(mockThemeRepository.currentThemeStream)
        .thenAnswer((realInvocation) => Stream.value(tCustomTheme));

    //Stream
    final result = await streamThemeUsecase.call();
    //primo elemento dello stream
    final theme = await result
        .first; //torna il primo elemento e smette di ascoltare lo stream

    expect(theme, equals(tCustomTheme));
  });
}
