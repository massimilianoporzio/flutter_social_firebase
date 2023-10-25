import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_social_firebase/src/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tPost = Post(
    id: 'id',
    caption: 'caption',
    imageUrl: 'imageUrl',
  );

  group('FeedState', () {
    test('has a default status of initial and an empty list of posts', () {
      // Act
      const state = FeedState();

      // Assert
      expect(state.status, FeedStatus.initial);
      expect(state.posts, isEmpty);
    });

    test('copyWith method should update the status and posts', () {
      // Arrange
      const state = FeedState();
      const updatedStatus = FeedStatus.loaded;
      final updatedPosts = [tPost, tPost];

      // Act
      final updatedState = state.copyWith(
        posts: updatedPosts,
        status: updatedStatus,
      );

      // Assert
      expect(updatedState.status, updatedStatus);
      expect(updatedState.posts, updatedPosts);
    });

    test('props should contain the posts and status', () {
      // Arrange
      const state = FeedState();
      const updatedStatus = FeedStatus.loaded;
      final updatedPosts = [tPost, tPost];

      // Act
      final updatedState = state.copyWith(
        posts: updatedPosts,
        status: updatedStatus,
      );

      // Assert
      expect(updatedState.props, [updatedPosts, updatedStatus]);
    });
  });
}
