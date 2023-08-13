import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:flutter_social_firebase/src/shared/app/blocs/app/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SignUpCubit>(), MockSpec<AppBloc>()])
void main() {
  //le chiavi per trovare i widget
  const emailInputKey = Key('signUp_emailInput_textField');
  const passwordInputKey = Key('signUp_passwordInput_textField');
  const signUpButtonKey = Key('signUp_continue_elevatedButton');

  const passwordClearIconButtonKey = Key('signUp_passwordInput_iconButton');
  const emailClearIconButtonKey = Key('signUp_emailInput_iconButton');

  const tEmail = 'test@gmail.com';
  const tPassword = 'password12345';

  late MockSignUpCubit mockSignUpCubit;
  late MockAppBloc mockAppBloc;

  //metodo per avere una MaterialApp da testare con SignUpScreen come home
  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<SignUpCubit>.value(
        value: mockSignUpCubit,
        child: BlocProvider<AppBloc>.value(
            value: mockAppBloc, child: const SignUpScreen()),
      ),
    );
  }

  setUpAll(() {
    mockSignUpCubit = MockSignUpCubit();
    mockAppBloc = MockAppBloc();
    //registro il mock
    final getIt = GetIt.instance;
    getIt.registerFactory<SignUpCubit>(() => mockSignUpCubit);
    getIt.registerSingleton<AppBloc>(mockAppBloc);
    when(mockAppBloc.state).thenReturn(
        const AppState.unauthenticated().copyWith(themeMode: ThemeMode.light));
  });
  setUp(() async {
    //definisco il comportamento
    when(mockSignUpCubit.state).thenReturn(const SignUpState.initial());
    //stub the state stream (ritorna uno stream con un initial)
    when(mockSignUpCubit.stream).thenAnswer(
        (realInvocation) => Stream.fromIterable([const SignUpState.initial()]));
  });
//testo COSTRUENDO la UI con pumpWidget
  testWidgets('renders a SignUpScreen', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
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
  testWidgets('passwordChanged when passsword changes ', (tester) async {
    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(find.byKey(passwordInputKey), tPassword);

    verify(mockSignUpCubit.passwordChanged(tPassword)).called(1);
  });
  testWidgets('AppBar & ElevatedButton are present with correct text',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    expect(find.byType(AppBar), findsOneWidget); //che ci sia UNA appBar
    expect(find.byType(ElevatedButton), findsOneWidget); //UN ElevatedButton
    expect(find.text('Sign Up'), findsWidgets); //UN Text('Sign Up)
  });

  testWidgets('Two TextFormFields are present', (tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('Show snack bar when the form status is invalid',
      (WidgetTester tester) async {
    //Arrange
    const text = 'Invalid form: please fill in all fields';
    final expectedStates = [
      const SignUpState(formStatus: FormStatus.initial),
      const SignUpState(formStatus: FormStatus.invalid),
    ];

    when(mockSignUpCubit.stream).thenAnswer(
      (_) => Stream.fromIterable(expectedStates),
    );

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(find.text(text), findsNothing);
    await tester.pump(); //forza rebuild con conseguente richiesta dello stato

    //Assert
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('Show snack bar when the form status is submissionFailure',
      (WidgetTester tester) async {
    //Arrange
    const text = 'There was an error with the sign up process. Try again.';
    final expectedStates = [
      const SignUpState(formStatus: FormStatus.initial),
      const SignUpState(formStatus: FormStatus.submissionFailure),
    ];

    when(mockSignUpCubit.stream).thenAnswer(
      (_) => Stream.fromIterable(expectedStates),
    );

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(find.text(text), findsNothing);
    await tester.pump();

    //Assert
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('Email field shows error for invalid email', (tester) async {
    when(mockSignUpCubit.state).thenReturn(
      const SignUpState(
        emailStatus:
            EmailStatus.invalid, //quando chiedo lo stato ritorno invalid
      ),
    );
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Invalid email'), findsOneWidget);
  });

  testWidgets('Password field shows error for invalid password',
      (tester) async {
    when(mockSignUpCubit.state)
        .thenReturn(const SignUpState(passwordStatus: PasswordStatus.invalid));
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Invalid password'), findsOneWidget);
  });
  testWidgets('resetEmail function is called when emailInput is cleared',
      (tester) async {
    //CREO UI

    await tester.pumpWidget(makeTestableWidget());
    //inserisco il testo tEmail dentro il widget che trovo con la chiave
    await tester.enterText(find.byKey(emailInputKey), tEmail);
    await tester.pump(const Duration(milliseconds: 500));
    //rimetto a zero
    await tester.enterText(find.byKey(emailInputKey), "");
    //creo un timer di 500 ms
    await tester.pump(const Duration(milliseconds: 500));
    //verifico che dopo i 500 ms sia chiamato resetEmailInput
    verify(mockSignUpCubit.resetEmailInput()).called(1);

    //verifico che lo stato sia email.null
    expect(mockSignUpCubit.state.email, isNull);
  });

  testWidgets('resetPassword function is called when passwordInput is cleared',
      (tester) async {
    //CREO UI
    final ui = makeTestableWidget() as MaterialApp;
    await tester.pumpWidget(ui);
    //inserisco il testo tEmail dentro il widget che trovo con la chiave
    await tester.enterText(find.byKey(passwordInputKey), tPassword);
    await tester.pump(const Duration(milliseconds: 500));
    //rimetto a zero
    await tester.enterText(find.byKey(passwordInputKey), "");

    verify(mockSignUpCubit.resetPasswordInput()).called(1);

    //verifico che lo stato sia password.null
    expect(mockSignUpCubit.state.password, isNull);
  });
  testWidgets('resetPassword function is called when clear icon is tapped',
      (tester) async {
    when(mockSignUpCubit.state).thenReturn(
      const SignUpState(
          formStatus: FormStatus.valid, passwordStatus: PasswordStatus.valid),
    );
    //CREO UI
    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.byKey(passwordClearIconButtonKey));

    verify(mockSignUpCubit.resetPasswordInput()).called(1);

    //verifico che lo stato sia password.null
    expect(mockSignUpCubit.state.password, isNull);
  });
  testWidgets('resetEmail function is called when clear icon is tapped',
      (tester) async {
    when(mockSignUpCubit.state).thenReturn(
      const SignUpState(
          formStatus: FormStatus.valid, emailStatus: EmailStatus.valid),
    );
    //CREO UI
    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.byKey(emailClearIconButtonKey));

    verify(mockSignUpCubit.resetEmailInput()).called(1);

    //verifico che lo stato sia password.null
    expect(mockSignUpCubit.state.email, isNull);
  });
  testWidgets('SignUp function is called when button is pressed',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(find.byType(ElevatedButton));
    verify(mockSignUpCubit.signUp()).called(1);
  });

  testWidgets(
      'SignUp button is disabled when formStatus is submissionInProgress',
      (tester) async {
    when(mockSignUpCubit.state).thenReturn(
      const SignUpState(
        formStatus: FormStatus.submissionInProgress,
      ),
    );
    await tester.pumpWidget(makeTestableWidget());
    expect(
      // tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
      tester.widget<ElevatedButton>(find.byKey(signUpButtonKey)).enabled,
      isFalse,
    );
  });
}
