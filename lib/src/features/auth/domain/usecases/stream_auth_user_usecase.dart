// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_social_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';

class StreamAuthUserUseCase {
  final AuthRepository authRepository;

  StreamAuthUserUseCase({required this.authRepository});

  Stream<AuthUser> call() {
    try {
      return authRepository.authUserStream;
    } catch (error) {
      throw Exception(error);
    }
  }
}
