import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';

import '../../../../services/service_locator.dart';
import '../blocs/email_status.dart';
import '../blocs/form_status.dart';
import '../blocs/password_status.dart';
import '../blocs/sign_in/sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignInCubit>(),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView({key = const Key('_signInView_key')}) : super(key: key);

  @override
  State<_SignInView> createState() => __SignInViewState();
}

class __SignInViewState extends State<_SignInView> with UiLoggy {
  Timer? debounce;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    debounce?.cancel(); //se non null lo cancello
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign In'),
      ),
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
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
                  key: const Key('signIn_emailInput_textField'),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    suffixIcon: state.emailStatus == EmailStatus.unknown
                        ? null
                        : IconButton(
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
                      context.read<SignInCubit>().resetEmailInput();
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
                      context.read<SignInCubit>().emailChanged(value);
                    });
                  },
                ),
                TextFormField(
                  key: const Key('signIn_passwordInput_textField'),
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: state.passwordStatus == PasswordStatus.unknown
                          ? null
                          : IconButton(
                              // Icon to
                              icon: const Icon(Icons.clear), // clear text
                              onPressed: clearTextPassword,
                            ),
                      errorText: state.passwordStatus == PasswordStatus.invalid
                          ? 'Invalid password'
                          : null),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<SignInCubit>().resetPasswordInput();
                      return;
                    }
                    //NO debounce qui
                    context.read<SignInCubit>().passwordChanged(value);
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                  key: const Key('signIn_continue_elevatedButton'),
                  onPressed: state.formStatus == FormStatus.submissionInProgress
                      ? null //se ho già inProgress non faccio null
                      : () {
                          loggy.debug('form submitted');
                          context.read<SignInCubit>().signIn();
                        },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void clearTextEmail() {
    context.read<SignInCubit>().resetEmailInput();

    emailController.clear();
  }

  void clearTextPassword() {
    context.read<SignInCubit>().resetPasswordInput();

    passwordController.clear();
  }
}
