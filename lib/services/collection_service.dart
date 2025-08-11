import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/env.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
import '../services/storage_service.dart';

class CollectionService {
  Future<List<Map<String, dynamic>>> getCollections(
      String collectionType) async {
    try {
      final token = await StorageService.getToken();
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/collections?type=$collectionType'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load collections');
      }
    } catch (e) {
      throw Exception('Error fetching collections: $e');
    }
  }

  Future<Map<String, dynamic>> createCollection({
    required String name,
    required File imageFile,
    required String type,
  }) async {
    try {
      final token = await StorageService.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Env.baseUrl}/collections'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      final fileExtension = imageFile.path.split('.').last;
      final uuid = const Uuid().v4();
      final key = '$uuid.$fileExtension';
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', fileExtension),
        ),
      );

      request.fields['name'] = name;
      request.fields['type'] = type;
      request.fields['key'] = key;
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(responseData);

      if (response.statusCode == 201) {
        return jsonResponse;
      } else {
        throw Exception('Failed to create collection');
      }
    } catch (e) {
      throw Exception('Error creating collection: $e');
    }
  }
}
