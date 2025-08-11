import 'collection.dart';

class Artwork {
  final String title;
  final String imageUrl;
  final double price;
  final int likesCount;

  Artwork({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.likesCount,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      title: json['title'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      likesCount: json['likesCount'],
    );
  }
}
