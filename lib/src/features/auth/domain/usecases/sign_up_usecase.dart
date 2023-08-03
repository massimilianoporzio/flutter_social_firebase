// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/value_objects/email.dart';

import '../value_objects/password.dart';

class SignUpUsecase extends UseCase<AuthUser, SignUpParams> {
  final AuthRepository authRepository;
  SignUpUsecase({
    required this.authRepository,
  });
  @override
  Future<AuthUser> call(SignUpParams params) async {
    try {
      return await authRepository.signUp(
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

class SignUpParams extends Params {
  final Email email;
  final Password password;
  SignUpParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
