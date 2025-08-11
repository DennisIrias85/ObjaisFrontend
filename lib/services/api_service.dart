import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/collection.dart';
import '../models/artwork.dart';
import '../models/boat.dart';
import '../config/env.dart';

class ApiService {
  Future<List<Collection>> getTopCollections() async {
    final response = await http
        .get(Uri.parse('${Env.baseUrl}/public/collections/top/artworks'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("@@@@");
      print(data);
      return data.map((json) => Collection.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load collections');
    }
  }

  Future<List<Artwork>> getTopArtworks() async {
    final response =
        await http.get(Uri.parse('${Env.baseUrl}/public/artworks/top/likes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Artwork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load artworks');
    }
  }

  Future<List<Boat>> getTopBoats() async {
    final response =
        await http.get(Uri.parse('${Env.baseUrl}/public/boats/top/likes'));

    print("boats");
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Boat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load boats');
    }
  }

  Future<void> sendToModeration(Map<String, dynamic> moderationPayload) async {
    final url = Uri.parse('${Env.baseUrl}/api/moderation');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(moderationPayload),
      );

      if (response.statusCode == 201) {
        print('✅ Sent to moderation successfully!');
      } else {
        print('❌ Failed to send to moderation. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending to moderation: $e');
    }
  }
}
