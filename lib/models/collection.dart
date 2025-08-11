class Collection {
  final String id;
  final String name;
  final String imageUrl;
  final String ownerId;
  final String? type;
  final int artworkCount;
  final int boatCount;

  Collection({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ownerId,
    this.type,
    required this.artworkCount,
    required this.boatCount,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      ownerId: json['owner'] != null ? json['owner']['_id'] : '',
      type: json['type'],
      artworkCount: json['artworks']?.length ?? 0,
      boatCount: json['boats']?.length ?? 0,
    );
  }

  // REMOVED: The 'get boats => null;' line was unused and has been removed for clarity.

  @override
  String toString() {
    return 'Collection(id: $id, name: $name, ownerId: $ownerId, artworkCount: $artworkCount, boatCount: $boatCount)';
  }
}

class User {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
    );
  }
}
