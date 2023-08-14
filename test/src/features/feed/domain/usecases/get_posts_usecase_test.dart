import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_post_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PostRepository>()])
void main() {
  late PostRepository mockPostRepository;
  late GetPostsUseCase getPostsUseCase;

  setUp(() {
    mockPostRepository = MockPostRepository();
    getPostsUseCase = GetPostsUseCase(postRepository: mockPostRepository);
  });
  const tPost = Post.empty; //già testata
  test('should call getPosts method on post Repository', () async {
    //STUB con lista di UN post Vuoto
    when(mockPostRepository.getPosts())
        .thenAnswer((realInvocation) async => Future.value([tPost]));
    await getPostsUseCase(NoParams());
    verify(mockPostRepository.getPosts()).called(1);
  });
  test('should throw an Exception when repo throws an Exception ', () async {
    when(mockPostRepository.getPosts()).thenThrow(Exception());
    expect(getPostsUseCase(NoParams()), throwsA(isA<Exception>()));
  });
  test(
      'should return the correct List of Post when repo returns a list of posts',
      () async {
    when(mockPostRepository.getPosts())
        .thenAnswer((realInvocation) async => Future.value([tPost]));

    final results = await getPostsUseCase(NoParams());
    expect(results, equals([tPost]));
  });
}
