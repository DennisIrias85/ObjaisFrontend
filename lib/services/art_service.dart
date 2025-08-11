import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/env.dart';
import '../models/art_data.dart';
import '../services/storage_service.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';

class ArtService {
  Future<List<ArtData>> analyzeArtImage(File imageFile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return static data with working image URLs
    return [];
  }

  Future<void> createArtwork({
    required String imageUrl,
    required String artName,
    required String artistName,
    required String description,
    required String price,
    required String year,
    required String category,
    required String? collectionId,
    required bool isPublic,
    File? itemImage,
    required String birthCountry,
    required String size,
    required String yearBirth,
    required String auctionHouseResult,
    required String turnoverEvolution,
    required String worldRanking,
    required String subtype,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      String finalImageUrl = imageUrl;
      String artworkId = '';
      print(imageUrl);
      print(itemImage);
      print(collectionId);
      if (itemImage != null || imageUrl != null) {
        final imageUploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse('${Env.baseUrl}/collections/artworks'),
        );
        if (itemImage != null) {
          final fileExtension = itemImage.path.split('.').last;
          final uuid = const Uuid().v4();
          final key = '$uuid.$fileExtension';
          print(key);

          imageUploadRequest.files.add(
            await http.MultipartFile.fromPath(
              'image',
              itemImage.path,
              contentType: MediaType('image', fileExtension),
            ),
          );
          imageUploadRequest.fields['key'] = key;
        } else {
          imageUploadRequest.fields['imageUrl'] = imageUrl;
        }
        imageUploadRequest.headers['Authorization'] = 'Bearer $token';
        imageUploadRequest.fields['name'] = artName;
        imageUploadRequest.fields['artistName'] = artistName;
        imageUploadRequest.fields['description'] = description;
        imageUploadRequest.fields['price'] = price;
        imageUploadRequest.fields['year'] = year;
        imageUploadRequest.fields['type'] = category;
        imageUploadRequest.fields['collectionId'] = collectionId ?? '';
        imageUploadRequest.fields['isPublic'] = isPublic.toString();
        imageUploadRequest.fields['birthCountry'] = birthCountry;
        imageUploadRequest.fields['size'] = size;
        imageUploadRequest.fields['yearBirth'] = yearBirth;
        imageUploadRequest.fields['auctionHouseResult'] = auctionHouseResult;
        imageUploadRequest.fields['turnoverEvolution'] = turnoverEvolution;
        imageUploadRequest.fields['worldRanking'] = worldRanking;
        imageUploadRequest.fields['subtype'] = subtype;

        final imageUploadResponse = await imageUploadRequest.send();
        final imageResponseStr =
            await imageUploadResponse.stream.bytesToString();

        if (imageUploadResponse.statusCode == 200) {
          final imageData = json.decode(imageResponseStr);
          print(imageData);
        } else {
          throw Exception(
              'Failed to upload image: ${imageUploadResponse.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error creating artwork: $e');
    }
  }

  Future<void> likeArtwork(String artworkId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }
      print(artworkId);
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/artworks/$artworkId/like'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to like artwork: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error liking artwork: $e');
    }
  }

  Future<bool> hasLikedArtwork(String artworkId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return false;
      }
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/artworks/$artworkId/has-liked'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['hasLiked'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
