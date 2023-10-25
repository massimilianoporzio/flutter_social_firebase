import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_firebase/src/features/feed/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const id = 'id_1';
  const caption = 'caption_1';
  const imageUrl = 'image_url_1';
  final createdAtTimestamp = Timestamp(1684329114, 0); //per cloud Firestore
  final createdAt = createdAtTimestamp.toDate();
  late PostModel postModel;
  //OGGETTO DEI TEST (di tutti i test quindi lo definisco prima)
  setUpAll(() {
    postModel = PostModel(
      id: id,
      caption: caption,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  });

  group('PostModel', () {
    test('properties are correctly assigned during creation', () {
      expect(postModel.id, equals(id));
      expect(postModel.caption, equals(caption));
      expect(postModel.imageUrl, equals(imageUrl));
      expect(postModel.createdAt, equals(createdAt));
    });
    test('creates PostModel from Fake data', () {
      const createdAtString = '2023-01-01T00:00:00.000Z';
      final createdAt = DateTime.parse(createdAtString);

      final mockMap = {
        'caption': caption,
        'imageUrl': imageUrl,
        'createdAt': createdAtString,
      };

      final postModel = PostModel.fromFakeDataSource(mockMap, id: id);

      expect(postModel.id, equals(id));
      expect(postModel.caption, equals(caption));
      expect(postModel.imageUrl, equals(imageUrl));
      expect(postModel.createdAt, equals(createdAt));
    });

    test('creates PostModel from Firebase data', () {
      final mockMap = {
        'caption': caption,
        'imageUrl': imageUrl,
        'createdAt': createdAtTimestamp,
      };

      final postModel = PostModel.fromCloudFirestore(mockMap, id: id);

      expect(postModel.id, equals(id));
      expect(postModel.caption, equals(caption));
      expect(postModel.imageUrl, equals(imageUrl));
      expect(postModel.createdAt, equals(createdAt));
    });

    test('converts to entity correctly', () {
      final post = postModel.toEntity();

      expect(post.id, equals(id));
      expect(post.caption, equals(caption));
      expect(post.imageUrl, equals(imageUrl));
      expect(post.createdAt, equals(createdAt));
    });

    test('get props returns a list with all properties', () {
      final props = postModel.props;
      expect(props, containsAll([id, caption, imageUrl, createdAt]));
    });
  });
}
