import 'package:flutter_social_firebase/src/features/feed/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should create a Post with correct value', () {
    // Sample data to create the Post object
    const id = '1';
    const caption = 'Sample caption';
    const imageUrl = 'imageUrl';
    final createdAt = DateTime.now();

    // Create a Post object
    final post = Post(
      id: id,
      caption: caption,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );

    // Validate if the object is created with the expected values
    expect(post.id, id);
    expect(post.caption, caption);
    expect(post.imageUrl, imageUrl);
    expect(post.createdAt, createdAt);
  });
  test('empty post has correct default values', () {
    expect(Post.empty.id, equals(''));
    expect(Post.empty.caption, equals(''));
    expect(Post.empty.imageUrl, equals(''));
    expect(Post.empty.createdAt, isNull);
  });

  test('Two posts whit same values are equal', () {
    final now = DateTime.now();
    final post1 = Post(
        id: 'id', caption: 'caption', imageUrl: 'imageUrl', createdAt: now);
    final post2 = Post(
        id: 'id', caption: 'caption', imageUrl: 'imageUrl', createdAt: now);
    expect(post1, equals(post2));
  });

  test('props returns correct properties', () {
    final createdAt = DateTime.now();
    final post = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: createdAt,
    );

    expect(
      post.props,
      equals(
        ['id', 'caption', 'imageUrl', createdAt],
      ),
    );
  });
  test('createdAt can be null', () {
    const post = Post(id: 'id', caption: 'caption', imageUrl: 'imageUrl');
    expect(post.createdAt, isNull);
  });
  test('two Post instances with different  id values are not equal', () {
    final createdAt = DateTime.now();
    final post = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: createdAt,
    );
    final post2 = Post(
      id: 'id2',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: createdAt,
    );
    expect(post, isNot(equals(post2)));
  });
  test('two Post instances with different caption values are not equal', () {
    final createdAt = DateTime.now();
    final post = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: createdAt,
    );
    final post2 = Post(
      id: 'id',
      caption: 'another caption',
      imageUrl: 'imageUrl',
      createdAt: createdAt,
    );
    expect(post, isNot(equals(post2)));
  });
  test('two Post instances with different imageUrl values are not equal', () {
    final createdAt = DateTime.now();
    final post = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: createdAt,
    );
    final post2 = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl2',
      createdAt: createdAt,
    );
    expect(post, isNot(equals(post2)));
  });
  test('two Post instances with different createdAt values are not equal', () {
    final post = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: DateTime.now(),
    );
    final post2 = Post(
      id: 'id',
      caption: 'caption',
      imageUrl: 'imageUrl',
      createdAt: DateTime.now().add(const Duration(microseconds: 1)),
    );
    expect(post, isNot(equals(post2)));
  });
}
