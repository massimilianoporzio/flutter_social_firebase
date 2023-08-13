import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter_social_firebase/src/shared/app/blocs/app/app_bloc.dart';
import 'package:flutter_social_firebase/src/shared/presentation/widgets/custon_app_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'custom_app_bar_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppBloc>(), MockSpec<ThemeCubit>()])
void main() {
  const title = "App Bar";
  late MockAppBloc mockAppBloc;
  late MockThemeCubit mockThemeCubit;
  const switchThemeIconButtonKey = Key('custmomAppBarSwitchThemeIconButton');
  //metodo per avere una MaterialApp da testare con SignUpScreen come home
  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ThemeCubit>(
        create: (context) => mockThemeCubit,
        child: BlocProvider<AppBloc>.value(
            value: mockAppBloc,
            child: const CustomAppBar(
              title: title,
            )),
      ),
    );
  }

  setUpAll(() {
    mockAppBloc = MockAppBloc();
    mockThemeCubit = MockThemeCubit();
    //registro il mock
    final getIt = GetIt.instance;
    getIt.registerFactory<ThemeCubit>(() => mockThemeCubit);
    getIt.registerSingleton<AppBloc>(mockAppBloc);
    when(mockAppBloc.state).thenReturn(
        const AppState.unauthenticated().copyWith(themeMode: ThemeMode.light));
  });

  testWidgets('renders a CustomAppBar with the correct title', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    //dopo aver creato la UI testo che ci sia un widget e uno solo di tipo SignUpScreen
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text(title), findsWidgets);
  });
  testWidgets('switchTheme', (tester) async {
//CREO UI
    await tester.pumpWidget(makeTestableWidget());
    //cerco l'icona e la premo
    await tester.tap(find.byKey(switchThemeIconButtonKey));
    //verifico di aver chiamato il cubit
    verify(mockThemeCubit.switchTheme(any)).called(1);
  });
}
