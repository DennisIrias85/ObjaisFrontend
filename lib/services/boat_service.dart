import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/env.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class BoatService {
  Future<void> createBoat({
    required String imageUrl,
    required String model,
    required String brand,
    required String horsePower,
    required String price,
    required String year,
    required String category,
    required String? collectionId,
    required bool isPublic,
    File? itemImage,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) throw Exception('No token found');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Env.baseUrl}/collections/boats'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Always send metadata
      request.fields['model'] = model;
      request.fields['brand'] = brand;
      request.fields['horsePower'] = horsePower;

      // Clean price
      final cleanedPrice = price.replaceAll(',', '');
      request.fields['price'] = cleanedPrice;
      request.fields['priceDisplay'] = price;

      request.fields['year'] = year;
      request.fields['category'] = category;
      request.fields['collectionId'] = collectionId ?? '';
      request.fields['isPublic'] = isPublic.toString();

      // Handle image
      File? finalImage = itemImage;

      if (finalImage == null && imageUrl.isNotEmpty) {
        finalImage = await _downloadImageFromUrl(imageUrl);
      }

      if (finalImage != null) {
        final fileExtension = finalImage.path.split('.').last;
        final uuid = const Uuid().v4();
        final key = '$uuid.$fileExtension';

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            finalImage.path,
            contentType: MediaType('image', fileExtension),
          ),
        );

        request.fields['key'] = key;
      } else if (imageUrl.isNotEmpty) {
        request.fields['imageUrl'] = imageUrl;
      }

      // Debug logging
      print('📤 Sending multipart request to: ${request.url}');
      print('🧾 Fields: ${request.fields}');
      print('🖼️ File: ${finalImage?.path}');
      print('🔐 Token: Bearer $token');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('✅ RESPONSE STATUS: ${response.statusCode}');
      print('✅ RESPONSE BODY: $responseBody');

      if (response.statusCode != 200) {
        throw Exception('Failed to create boat: $responseBody');
      }

      // 🔁 Also send to moderation endpoint
      final moderationPayload = {
        "imageUrl": imageUrl,
        "brand": brand,
        "model": model,
        "yearBuilt": year,
        "engine": horsePower,
        "length": "", // Optional
        "location": "", // Optional
        "price": cleanedPrice,
        "confidence": 1,
      };

      final moderationResponse = await http.post(
        Uri.parse('${Env.baseUrl}/api/moderation'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(moderationPayload),
      );

      print('📨 MODERATION STATUS: ${moderationResponse.statusCode}');
      print('📨 MODERATION BODY: ${moderationResponse.body}');
    } catch (e) {
      print('❌ ERROR CREATING BOAT: $e');
      throw Exception('Error creating boat: $e');
    }
  }

  Future<File?> _downloadImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/${const Uuid().v4()}.jpg');
        await file.writeAsBytes(bytes);
        return file;
      } else {
        print('❌ Failed to download image. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error downloading image: $e');
    }
    return null;
  }

  Future<void> likeBoat(String boatId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) throw Exception('No token found');
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/boats/$boatId/like'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to like boat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error liking boat: $e');
    }
  }

  Future<bool> hasLikedBoat(String boatId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return false;
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/boats/$boatId/has-liked'),
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
