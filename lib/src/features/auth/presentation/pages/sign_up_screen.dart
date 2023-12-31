import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:loggy/loggy.dart';

import '../../../../services/service_locator.dart';
import '../../../../shared/presentation/widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignUpCubit>(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView({super.key});

  @override
  State<_SignupView> createState() => __SignupViewState();
}

class __SignupViewState extends State<_SignupView> with UiLoggy {
  Timer? debounce; //aspettare tot ms DOPO che user ha smesso di scrivere
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    debounce?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Sign Up',
      ),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          //AZIONI UNA TANTUM
          if (state.formStatus == FormStatus.invalid) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: AwesomeSnackbarContent(
                    title: 'Error!',
                    message: 'Invalid form: please fill in all fields',
                    inMaterialBanner: true,
                    color: Colors.red.shade900,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                ),
              );
          }
          if (state.formStatus == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: AwesomeSnackbarContent(
                    title: 'Error!',
                    message:
                        'There was an error with the sign up process. Try again.',
                    inMaterialBanner: true,
                    color: Colors.red.shade900,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                ),
              );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  key: const Key('signUp_emailInput_textField'),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    suffixIcon: state.emailStatus == EmailStatus.unknown
                        ? null
                        : IconButton(
                            key: const Key('signUp_emailInput_iconButton'),
                            // Icon to
                            icon: const Icon(Icons.clear), // clear text
                            onPressed: clearTextEmail,
                          ),
                    labelText: 'Email',
                    errorText: state.emailStatus == EmailStatus.invalid
                        ? 'Invalid email'
                        : null,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<SignUpCubit>().resetEmailInput();
                      return;
                    }
                    if (debounce?.isActive ?? false) {
                      debounce?.cancel(); //cancello il timer se c'era
                      //(in pratica riparto con altri 500 ms ad ogni carattere inserito)
                    }
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      //dopo 500 ms chiamo evento sul cubit
                      //se nel frattempo ho di nuovo cambiato il testo allora
                      //il timer viene ricreato per altri 500 ms
                      context.read<SignUpCubit>().emailChanged(value);
                    });
                  },
                ),
                TextFormField(
                  key: const Key('signUp_passwordInput_textField'),
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: state.passwordStatus == PasswordStatus.unknown
                          ? null
                          : IconButton(
                              key: const Key('signUp_passwordInput_iconButton'),
                              // Icon to
                              icon: const Icon(Icons.clear), // clear text
                              onPressed: clearTextPassword,
                            ),
                      errorText: state.passwordStatus == PasswordStatus.invalid
                          ? 'Invalid password'
                          : null),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<SignUpCubit>().resetPasswordInput();
                      return;
                    }
                    //NO debounce qui
                    context.read<SignUpCubit>().passwordChanged(value);
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                  key: const Key('signUp_continue_elevatedButton'),
                  onPressed: state.formStatus == FormStatus.submissionInProgress
                      ? null //se ho già inProgress non faccio null
                      : () {
                          loggy.debug('form submitted');
                          context.read<SignUpCubit>().signUp();
                        },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextButton(
                    key: const Key('go_to_signIn_continue_textButton'),
                    onPressed: () {
                      context.goNamed('sign-in');
                    },
                    child: const Text('Go to Sign In'))
              ],
            ),
          );
        },
      ),
    );
  }

  void clearTextPassword() {
    context.read<SignUpCubit>().resetPasswordInput();

    emailController.clear();
  }

  void clearTextEmail() {
    context.read<SignUpCubit>().resetEmailInput();

    passwordController.clear();
  }
}
