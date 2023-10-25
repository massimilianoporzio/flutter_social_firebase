// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, loaded, error }

class FeedState extends Equatable {
  final List<Post> posts;
  final FeedStatus status;
  const FeedState({
    this.posts = const <Post>[],
    this.status = FeedStatus.initial,
  });

  @override
  List<Object> get props => [posts, status];

  FeedState copyWith({
    List<Post>? posts,
    FeedStatus? status,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
    );
  }
}
