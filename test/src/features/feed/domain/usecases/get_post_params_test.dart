import 'package:flutter_social_firebase/src/features/feed/domain/usecases/get_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String postId = 'postId';
  test('Should create a GetPostParams with right id value', () {
    expect(GetPostParams(postId: postId).postId, postId);
  });
  test('Should returns the correct props', () {
    final GetPostParams params = GetPostParams(postId: postId);
    expect(
        params.props,
        equals([
          postId,
        ]));
  });
  test('Two GetPostparams with the same postId are equals', () {
    final GetPostParams params1 = GetPostParams(postId: postId);
    final GetPostParams params2 = GetPostParams(postId: postId);
    expect(params1, equals(params2));
  });
  test('Two GetPostparams with different postId are NOT equals', () {
    final GetPostParams params1 = GetPostParams(postId: postId);
    final GetPostParams params2 = GetPostParams(postId: 'anotherPostId');
    expect(params1, equals(isNot(params2)));
  });
}
