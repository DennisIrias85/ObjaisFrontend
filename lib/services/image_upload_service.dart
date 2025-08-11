import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../config/env.dart';

class ImageUploadService {
  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      print('Uploading image...');

      // Create multipart request to S3
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Env.baseUrl}/s3/upload'),
      );

      // Get file extension
      final fileExtension = imageFile.path.split('.').last;
      final uuid = const Uuid().v4();
      final key = '$uuid.$fileExtension';

      // Add image file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', fileExtension),
        ),
      );

      // Add key to request
      request.fields['key'] = key;

      // Send request to S3
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> responseJson = json.decode(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success - return the parsed response data
        return {
          'message': 'File uploaded successfully',
          'url': responseJson['url'],
          'visualMatches': responseJson['visualMatches'],
        };
      } else {
        throw Exception(
          'Failed to upload image to S3: ${response.statusCode} - $responseData',
        );
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
