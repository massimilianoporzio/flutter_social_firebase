// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_social_firebase/src/core/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/password.dart';

import '../value_objects/email.dart';

class SignInUsecase extends UseCase<AuthUser, SignInParams> {
  final AuthRepository authRepository;
  SignInUsecase({
    required this.authRepository,
  });
  @override
  Future<AuthUser> call(SignInParams params) async {
    try {
      return await authRepository.signIn(
        email: params.email.value,
        password: params.password.value,
      );
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
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
