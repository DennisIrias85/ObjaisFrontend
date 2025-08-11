import 'dart:io';

class Boat {
  final String? id;
  final String? category;
  final String? brand;
  final String? model;
  final String? yearBuilt;
  final String? price;
  final String? engineDetails;
  final String? imageUrl;
  final File? boatImage;
  final String? link;
  final String? likesCount;
  final String? horsePower;
  final String? type;

  Boat({
    this.id,
    this.category,
    this.brand,
    this.model,
    this.yearBuilt,
    this.price,
    this.engineDetails,
    this.imageUrl,
    this.boatImage,
    this.link,
    this.likesCount,
    this.horsePower,
    this.type,
  });

  factory Boat.fromJson(Map<String, dynamic> json) {
    final titleParts =
        (json['title'] ?? '').split('|').map((e) => e.trim()).toList();

    return Boat(
      id: json['_id'],
      category: json['category'],
      brand:
          json['brand'] ?? (titleParts.isNotEmpty ? titleParts[0] : 'Unknown'),
      model:
          json['model'] ?? (titleParts.isNotEmpty ? titleParts[0] : 'Unknown'),
      yearBuilt: json['year']?.toString() ??
          (titleParts.length > 1 ? titleParts[1] : 'Unknown'),
      price: json['priceDisplay']?.toString() ??
          json['price']?.toString() ??
          'Unknown',
      engineDetails: json['engineDetails'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      link: json['link'] ?? json['url'],
      likesCount: json['likesCount']?.toString() ?? '0',
      horsePower: json['horsePower']?.toString() ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
    );
  }

  String get safeBrand => brand?.isNotEmpty == true ? brand! : 'Unknown';
  String get safeModel => model?.isNotEmpty == true ? model! : 'Unknown';
  String get safeYear => yearBuilt?.isNotEmpty == true ? yearBuilt! : 'Unknown';
  String get safePrice => price?.isNotEmpty == true ? price! : '\$null';
  String get safeHorsePower =>
      horsePower?.isNotEmpty == true ? horsePower! : 'Unknown';
  String get safeType => type?.isNotEmpty == true ? type! : 'Motorboat';
  String get safeEngine =>
      engineDetails?.isNotEmpty == true ? engineDetails! : 'Unknown';
  String get safeCategory => category?.isNotEmpty == true ? category! : 'Yacht';

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'brand': brand,
      'model': model,
      'yearBuilt': yearBuilt,
      'price': price,
      'engineDetails': engineDetails,
      'imageUrl': imageUrl,
      'horsePower': horsePower,
      'type': type,
    };
  }
}
