import 'package:flutter_social_firebase/src/features/common/data/datasources/remote_datasource.dart';
import 'package:flutter_social_firebase/src/features/feed/data/models/post_model.dart';
import 'package:flutter_social_firebase/src/features/feed/data/repositories/post_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'post_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RemoteDataSource>(),
])
void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late PostRepositoryImpl postRepository; //ogg del test

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    postRepository = PostRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });


  const tPostId = '1';
  const tPostModel = PostModel(
    id: 'id',
    caption: 'caption',
    imageUrl: 'imageUrl',
  );
}
