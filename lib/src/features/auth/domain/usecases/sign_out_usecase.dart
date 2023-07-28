// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_social_firebase/src/core/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase extends UseCase<void, NoParams> {
  final AuthRepository authRepository;
  SignOutUsecase({
    required this.authRepository,
  });
  @override
  Future<void> call(NoParams params) async {
    try {
      await authRepository.signOut();
    } catch (error) {
      throw Exception(error);
    }
  }
}
