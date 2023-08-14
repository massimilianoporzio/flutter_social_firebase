// Mocks generated by Mockito 5.4.2 from annotations
// in flutter_social_firebase/test/src/features/feed/domain/usecases/get_post_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart'
    as _i2;
import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakePost_0 extends _i1.SmartFake implements _i2.Post {
  _FakePost_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PostRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPostRepository extends _i1.Mock implements _i3.PostRepository {
  @override
  _i4.Future<_i2.Post> getPost({required String? postId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPost,
          [],
          {#postId: postId},
        ),
        returnValue: _i4.Future<_i2.Post>.value(_FakePost_0(
          this,
          Invocation.method(
            #getPost,
            [],
            {#postId: postId},
          ),
        )),
        returnValueForMissingStub: _i4.Future<_i2.Post>.value(_FakePost_0(
          this,
          Invocation.method(
            #getPost,
            [],
            {#postId: postId},
          ),
        )),
      ) as _i4.Future<_i2.Post>);
  @override
  _i4.Future<List<_i2.Post>> getPosts() => (super.noSuchMethod(
        Invocation.method(
          #getPosts,
          [],
        ),
        returnValue: _i4.Future<List<_i2.Post>>.value(<_i2.Post>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i2.Post>>.value(<_i2.Post>[]),
      ) as _i4.Future<List<_i2.Post>>);
}
