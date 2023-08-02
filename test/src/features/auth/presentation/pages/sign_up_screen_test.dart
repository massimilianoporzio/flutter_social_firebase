import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_social_firebase/src/services/service_locator.dart'
    as di;

import 'sign_up_screen_test.mocks.dart';

@GenerateMocks([SignUpCubit])
void main() {
  //le chiavi per trovare i widget
  const emailInputKey = Key('signUp_emailInput_textField');
  const passwordInputKey = Key('signUp_passwordInput_textField');
  const signUpButtonKey = Key('signUp_continue_elevatedButton');

  const tEmail = 'test@gmail.com';
  const tPassword = 'password12345';

  late MockSignUpCubit mockSignUpCubit;

  //metodo per avere una MaterialApp da testare con SignUpScreen come home
  Widget makeTestableWidget() {
    return const MaterialApp(
      home: SignUpScreen(),
    );
  }

  setUp(() async {
    //registro il mock
    final getIt = GetIt.instance;
    getIt.registerFactory<SignUpCubit>(() => mockSignUpCubit);
    mockSignUpCubit = MockSignUpCubit();
    //definisco il comportamento
    when(mockSignUpCubit.state).thenReturn(const SignUpState.initial());
    //stub the state stream (ritorna uno stream con un initial)
    when(mockSignUpCubit.stream).thenAnswer(
        (realInvocation) => Stream.fromIterable([const SignUpState.initial()]));
  });
//testo COSTRUENDO la UI con pumpWidget
  testWidgets('renders a SignUpScreen', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignUpScreen(),
    ));
    //dopo aver creato la UI testo che ci sia un widget e uno solo di tipo SignUpScreen
    expect(find.byType(SignUpScreen), findsOneWidget);
  });
  testWidgets('emailChanged when email changes with 500 milliseconds debounce',
      (tester) async {
    //CREO UI
    await tester.pumpWidget(makeTestableWidget());
    //inserisco il testo tEmail dentro il widget che trovo con la chiave
    await tester.enterText(find.byKey(emailInputKey), tEmail);
    //creo un timer di 500 ms
    await tester.pump(const Duration(milliseconds: 500));
    //verifico che dopo i 500 ms sia chiamato emailChanged
    verify(mockSignUpCubit.emailChanged(tEmail)).called(1);
  });
}
