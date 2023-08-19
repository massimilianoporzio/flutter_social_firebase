// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_social_firebase/src/features/common/data/datasources/remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/feed/data/models/post_model.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final RemoteDataSource remoteDataSource;
  PostRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Post> getPost({required String postId}) async {
    final postModel = await remoteDataSource.getDocument(
      collectionPath: 'posts',
      documentId: postId,
      objectMapper: PostModel.fromCloudFirestore,
    );
    return postModel == null ? Post.empty : postModel.toEntity();
  }

  @override
  Future<List<Post>> getPosts() async {
    final postModels = await remoteDataSource.getCollection(
      collectionPath: 'posts',
      objectMapper: PostModel.fromCloudFirestore,
    );
    return postModels.map((postModel) => postModel.toEntity()).toList();
  }
}
