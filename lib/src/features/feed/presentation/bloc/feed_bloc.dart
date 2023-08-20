import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_firebase/src/features/feed/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart';

import '../../domain/entities/post.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsUseCase _getPostsUseCase;

  FeedBloc({required GetPostsUseCase getPostsUseCase})
      : _getPostsUseCase = getPostsUseCase,
        super(const FeedState()) {
    on<FeedGetPosts>(_onGetPosts);
  }

  FutureOr<void> _onGetPosts(
      FeedGetPosts event, Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading));
    try {
      List<Post> posts = await _getPostsUseCase(NoParams());
      emit(state.copyWith(
        status: FeedStatus.loaded,
        posts: posts,
      ));
    } catch (e) {
      emit(state.copyWith(status: FeedStatus.error));
    }
  }
}
