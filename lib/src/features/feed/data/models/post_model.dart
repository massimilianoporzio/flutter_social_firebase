import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

class PostModel extends Equatable {
  final String id;
  final String caption;
  final String imageUrl;
  final DateTime? createdAt;
  const PostModel({
    required this.id,
    required this.caption,
    required this.imageUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, caption, imageUrl, createdAt];

  //DA UN FAKE DATASOURCE (da un file)
  factory PostModel.fromFakeDataSource(
    Map<String, dynamic>? data, {
    String? id,
  }) {
    return PostModel(
      id: id ?? '',
      caption: data?['caption'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      createdAt: data?['createdAt'] != null
          ? DateTime.parse(data?['createdAt']) //stringa da file
          : null,
    );
  }

  factory PostModel.fromCloudFirestore(
    Map<String, dynamic>? data, {
    String? id,
  }) {
    return PostModel(
      id: id ?? '',
      caption: data?['caption'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      createdAt:
          data?['createdAt'].toDate(), //da timestamp (firestore) a DateTime
    );
  }

  Post toEntity() {
    return Post(
      id: id,
      caption: caption,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }
}
