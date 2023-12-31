// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_social_firebase/src/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository authRepository;
  SignOutUseCase({
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
