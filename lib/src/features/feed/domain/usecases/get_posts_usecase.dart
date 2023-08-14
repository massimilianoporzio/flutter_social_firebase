import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';

class GetPostsUseCase extends UseCase<List<Post>, NoParams> {
  final PostRepository postRepository;
  GetPostsUseCase({
    required this.postRepository,
  });
  @override
  Future<List<Post>> call(NoParams params) async {
    try {
      return await postRepository.getPosts();
    } catch (e) {
      throw Exception(e);
    }
  }
}
