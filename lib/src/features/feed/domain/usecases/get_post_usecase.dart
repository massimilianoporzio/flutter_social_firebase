import 'dart:async';

import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';

import '../entities/post.dart';

class GetPostUseCase extends UseCase<Post, GetPostParams> {
  final PostRepository postRepository;
  GetPostUseCase({
    required this.postRepository,
  });
  @override
  Future<Post> call(GetPostParams params) async {
    try {
      return await postRepository.getPost(postId: params.postId);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class GetPostParams extends Params {
  final String postId;
  GetPostParams({
    required this.postId,
  });
  @override
  List<Object?> get props => [postId];
}
