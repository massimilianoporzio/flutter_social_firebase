import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';

abstract class PostRepository {
  Future<Post> getPost({required String postId});
  Future<List<Post>> getPosts();
}
