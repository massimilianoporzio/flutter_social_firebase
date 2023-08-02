import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_social_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_social_firebase/src/logs/bloc_logger.dart';

import '../../../domain/value_objects/email.dart';
import '../../../domain/value_objects/password.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> with BlocLoggy {
  //dipende da un caso d'uso
  final SignUpUsecase _signUpUsecase;
  SignUpCubit({required SignUpUsecase signupUseCase})
      : _signUpUsecase = signupUseCase,
        super(const SignUpState.initial());
  //metodi chiamti quando cambia l'input nella UI
  void emailChanged(String value) {
    try {
      Email email = Email((p0) => p0.value = value);
      emit(state.copyWith(
          email: email,
          emailStatus: EmailStatus
              .valid)); //VALID perché non sono andato in eccezione nel creare una Email
    } on ArgumentError {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    try {
      Password password = Password(
        (p0) => p0.value = value,
      );
      emit(state.copyWith(
          password: password, passwordStatus: PasswordStatus.valid));
    } on ArgumentError {
      emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
    }
  }

  Future<void> resetEmailInput() async {
    loggy.debug('reset email input');

    emit(
      state.copyWith(
        emailStatus: EmailStatus.unknown,
      ),
    );
  }

  Future<void> resetPasswordInput() async {
    loggy.debug('reset password input');

    emit(
      state.copyWith(
        passwordStatus: PasswordStatus.unknown,
      ),
    );
  }

  Future<void> signUp() async {
    if (!(state.emailStatus == EmailStatus.valid) ||
        !(state.passwordStatus == PasswordStatus.valid)) {
      emit(state.copyWith(formStatus: FormStatus.invalid));
      //rimetto a iniziali lo stato del form (NON di email e pwd che restano invalidi)
      emit(state.copyWith(formStatus: FormStatus.initial));
      return; //esco
    }
    //tutto validato da qui in poi
    //inizio il submit
    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    try {
      await _signUpUsecase(SignUpParams(
        email: state.email!,
        password: state.password!,
      ));
      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}
