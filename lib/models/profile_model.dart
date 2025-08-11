import './boat.dart';

class ProfileModel {
  final UserInfo user;
  final List<Collection> collections;
  final List<Artwork> artworks;
  final double totalValue;
  final int totalArtworks;
  final int totalCollections;

  ProfileModel({
    required this.user,
    required this.collections,
    required this.artworks,
    required this.totalValue,
    required this.totalArtworks,
    required this.totalCollections,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print(json['collections']);
    print("profilejson");
    return ProfileModel(
      user: UserInfo.fromJson(json['user']),
      collections: (json['collections'] as List)
          .map((collection) => Collection.fromJson(collection))
          .toList(),
      artworks: (json['artworks'] as List)
          .map((artwork) => Artwork.fromJson(artwork))
          .toList(),
      totalValue: json['totalValue']?.toDouble() ?? 0.0,
      totalArtworks: json['totalArtworks'] ?? 0,
      totalCollections: json['totalCollections'] ?? 0,
    );
  }
}

class UserInfo {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final int following;
  final String? phone;
  final String? address;
  final String? gender;
  final String? dateOfBirth;
  final String? description;

  UserInfo({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.following,
    this.phone,
    this.address,
    this.gender,
    this.dateOfBirth,
    this.description,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['profileImage'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      following: json['followingCount'] ?? 0,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['birthday'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Collection {
  final String id;
  final String name;
  final List<Artwork> artworks;
  final List<Boat> boats;
  final String imageUrl;
  final UserInfo? owner;
  final String type;
  Collection(
      {required this.id,
      required this.name,
      required this.artworks,
      required this.boats,
      required this.imageUrl,
      this.owner,
      required this.type});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
      artworks: (json['artworks'] as List)
          .map((artwork) => Artwork.fromJson(artwork))
          .toList(),
      boats:
          (json['boats'] as List).map((boat) => Boat.fromJson(boat)).toList(),
      owner: json['owner'] != null && json['owner'] is Map<String, dynamic>
          ? UserInfo.fromJson(json['owner'])
          : null,
      type: json['type'],
    );
  }
}

class Artwork {
  final String id;
  final String title;
  final double estimation;
  final String imageUrl;
  final String artistName;
  final String description;
  final String price;
  final String year;
  final String category;
  final String size;
  final String auctionHouseResult;
  final String turnoverEvolution;
  final String worldRanking;
  final UserInfo? owner;
  final String? likes;
  Artwork({
    required this.id,
    required this.title,
    required this.estimation,
    required this.imageUrl,
    required this.artistName,
    required this.description,
    required this.price,
    required this.year,
    required this.category,
    required this.size,
    required this.auctionHouseResult,
    required this.turnoverEvolution,
    required this.worldRanking,
    this.owner,
    this.likes,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['_id'] ?? '',
      title: json['itemName'] ?? '',
      estimation: json['price']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      artistName: json['creator'] ?? '',
      description: json['description'] ?? '',
      price: json['price'].toString() ?? '',
      year: json['year'].toString() ?? '',
      category: json['type'] ?? 'painting',
      size: json['size'].toString() ?? '',
      auctionHouseResult: json['auctionHouseResult'].toString() ?? '',
      turnoverEvolution: json['turnoverEvolution'].toString() ?? '',
      worldRanking: json['worldRanking'].toString() ?? '',
      owner: json['owner'] != null && json['owner'] is Map<String, dynamic>
          ? UserInfo.fromJson(json['owner'])
          : null,
      likes: json['likes'].length.toString() ?? '0',
    );
  }
}
