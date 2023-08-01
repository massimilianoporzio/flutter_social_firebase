import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';

import '../../../../services/service_locator.dart';

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

class __SignupViewState extends State<_SignupView> {
  Timer? debounce; //aspettare tot ms DOPO che user ha smesso di scrivere

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign Up'),
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
                        'There was an error with the sign up process. Please, try again.',
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
                  key: const Key('signup_emailInput_textField'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
