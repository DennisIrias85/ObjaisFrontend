import 'package:flutter/foundation.dart';

class ArtData {
  final String imageUrl;
  final String artName;
  final String artistName;
  final String description;
  final String price;
  final String year;
  final String category;
  final String birthCountry;
  final String size;
  final String yearBirth;
  final String auctionHouseResult;
  final String turnoverEvolution;
  final String worldRanking;
  final int likes;

  ArtData({
    required this.imageUrl,
    required this.artName,
    required this.artistName,
    required this.description,
    required this.price,
    required this.year,
    required this.category,
    required this.birthCountry,
    required this.size,
    required this.yearBirth,
    required this.auctionHouseResult,
    required this.turnoverEvolution,
    required this.worldRanking,
    this.likes = 0,
  });

  factory ArtData.fromJson(Map<String, dynamic> json) {
    return ArtData(
      imageUrl: json['image'] as String? ?? '',
      artName: json['title'] as String? ?? '',
      artistName: json['artist'] as String? ?? 'Unknown Artist',
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      year: json['yearCreation'] as String? ?? '0',
      category: json['category'] as String? ?? '',
      birthCountry: json['birthCountry'] as String? ?? '',
      size: json['size'] as String? ?? '',
      yearBirth: json['yearBirth'] as String? ?? '',
      auctionHouseResult: json['auctionHouseResult'] as String? ?? '',
      turnoverEvolution: json['turnoverEvolution'] as String? ?? '',
      worldRanking: json['worldRanking'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'artName': artName,
      'artistName': artistName,
      'description': description,
      'price': price,
      'year': year,
      'category': category,
      'birthCountry': birthCountry,
      'size': size,
      'yearBirth': yearBirth,
      'auctionHouseResult': auctionHouseResult,
      'turnoverEvolution': turnoverEvolution,
      'worldRanking': worldRanking,
      'likes': likes,
    };
  }

  // Static method to create mock data for art valuation
}
