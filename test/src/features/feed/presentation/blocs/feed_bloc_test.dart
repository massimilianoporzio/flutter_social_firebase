import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_social_firebase/src/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'feed_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetPostsUseCase>()])
void main() {
  group('FeedBloc', () {
    const tPost = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
    );
    late MockGetPostsUseCase mockGetPostsUseCase;

    setUp(() {
      mockGetPostsUseCase = MockGetPostsUseCase();
    });

    FeedBloc buildBloc() {
      return FeedBloc(getPostsUseCase: mockGetPostsUseCase);
    }

    blocTest<FeedBloc, FeedState>(
      'emits [loaded] when posts are successfully fetched and the post list contains the posts',
      setUp: () {
        when(mockGetPostsUseCase(NoParams())).thenAnswer(
          (_) async => [tPost, tPost],
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(FeedGetPosts()),
      expect: () => [
        const FeedState(status: FeedStatus.loading),
        const FeedState(
          posts: [tPost, tPost],
          status: FeedStatus.loaded,
        ),
      ],
    );

    blocTest<FeedBloc, FeedState>(
      'emits [error] when fetching posts throws an exception',
      setUp: () {
        when(mockGetPostsUseCase(NoParams())).thenThrow(Exception());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(FeedGetPosts()),
      expect: () => [
        const FeedState(status: FeedStatus.loading),
        const FeedState(status: FeedStatus.error),
      ],
    );
  });
}
