// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';

class StreamAuthUserUsecase extends UseCase<Stream<AuthUser>, NoParams> {
  final AuthRepository authRepository;
  StreamAuthUserUsecase({
    required this.authRepository,
  });

  @override
  FutureOr<Stream<AuthUser>> call(NoParams params) {
    try {
      return authRepository.authUserStream;
    } catch (error) {
      throw Exception(error);
    }
  }
}
