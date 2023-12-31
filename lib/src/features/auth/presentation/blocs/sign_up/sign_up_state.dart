// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final Email? email;
  final Password? password;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final FormStatus formStatus;

  const SignUpState({
    this.email,
    this.password,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.formStatus = FormStatus.initial,
  });

  @override
  List<Object?> get props {
    return [
      email,
      password,
      emailStatus,
      passwordStatus,
      formStatus,
    ];
  }

  const SignUpState.initial() : this();

  SignUpState copyWith({
    Email? email,
    Password? password,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    FormStatus? formStatus,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
