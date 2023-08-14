import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String caption;
  final String imageUrl;
  final DateTime? createdAt;
  const Post({
    required this.id,
    required this.caption,
    required this.imageUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, caption, imageUrl, createdAt];

  static const Post empty = Post(
    id: '',
    caption: '',
    imageUrl: '',
  );
}
