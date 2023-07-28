import 'package:flutter_social_firebase/src/core/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';

import '../value_objects/email.dart';

class SignInUsecase extends UseCase<AuthUser, SignInParams> {
  @override
  Future<AuthUser> call(SignInParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class SignInParams extends Params {
  final Email email;
  final Password password;
  SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
