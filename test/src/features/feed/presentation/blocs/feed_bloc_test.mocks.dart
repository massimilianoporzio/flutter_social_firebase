// Mocks generated by Mockito 5.4.2 from annotations
// in flutter_social_firebase/test/src/features/feed/presentation/blocs/feed_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart'
    as _i5;
import 'package:flutter_social_firebase/src/features/feed/domain/repositories/post_repository.dart'
    as _i2;
import 'package:flutter_social_firebase/src/features/feed/domain/usecases/get_posts_usecase.dart'
    as _i3;
import 'package:flutter_social_firebase/src/shared/domain/usecases/base_usecase.dart'
    as _i6;
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

class _FakePostRepository_0 extends _i1.SmartFake
    implements _i2.PostRepository {
  _FakePostRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetPostsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetPostsUseCase extends _i1.Mock implements _i3.GetPostsUseCase {
  @override
  _i2.PostRepository get postRepository => (super.noSuchMethod(
        Invocation.getter(#postRepository),
        returnValue: _FakePostRepository_0(
          this,
          Invocation.getter(#postRepository),
        ),
        returnValueForMissingStub: _FakePostRepository_0(
          this,
          Invocation.getter(#postRepository),
        ),
      ) as _i2.PostRepository);
  @override
  _i4.Future<List<_i5.Post>> call(_i6.NoParams? params) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<List<_i5.Post>>.value(<_i5.Post>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i5.Post>>.value(<_i5.Post>[]),
      ) as _i4.Future<List<_i5.Post>>);
}
