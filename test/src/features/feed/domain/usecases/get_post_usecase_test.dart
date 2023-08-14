import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/usecases/get_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_post_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PostRepository>()])
void main() {
  late MockPostRepository mockPostRepository;
  late GetPostUseCase getPostUseCase; //ogg del test

  setUp(() {
    mockPostRepository = MockPostRepository();
    getPostUseCase = GetPostUseCase(postRepository: mockPostRepository);
  });
  //const per i test
  const tPostId = '1';
  const tPost = Post.empty;
  final tGetPostParams = GetPostParams(postId: tPostId);
  test('should call getPost method on post Repository wuth the correct params',
      () async {
    //STUB
    when(mockPostRepository.getPost(postId: anyNamed('postId')))
        .thenAnswer((realInvocation) async => tPost);
    //CALL
    await getPostUseCase(tGetPostParams);

    //VERIFY
    verify(mockPostRepository.getPost(postId: tGetPostParams.postId)).called(1);
  });

  test(
      'should throw an exception when the getPost method on the PostRepository throws an exception',
      () async {
    when(mockPostRepository.getPost(postId: anyNamed('postId')))
        .thenThrow(Exception());

    expect(() async => await getPostUseCase(tGetPostParams),
        throwsA(isA<Exception>()));
  });
  test(
      'should return the correct Post when the getPost method on the PostRepository returns successfully',
      () async {
    when(mockPostRepository.getPost(postId: anyNamed('postId')))
        .thenAnswer((_) async => tPost);

    final result = await getPostUseCase.call(tGetPostParams);

    expect(result, equals(tPost));
  });
}
