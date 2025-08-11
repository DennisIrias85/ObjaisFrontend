import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/profile_model.dart';
import 'package:my_project/config/env.dart';
import '../services/storage_service.dart';

class ProfileRepository {
  final String baseUrl =
      'YOUR_API_BASE_URL'; // Replace with your actual API base URL

  Future<ProfileModel> getProfile() async {
    try {
      final token = await StorageService.getToken();
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        return ProfileModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      final token = await StorageService.getToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Env.baseUrl}/users/profile/image'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      final response = await request.send();
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile image');
      }
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }

  Future<void> followProfile() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/profile/follow'));

      if (response.statusCode != 200) {
        throw Exception('Failed to follow profile');
      }
    } catch (e) {
      throw Exception('Failed to follow profile: $e');
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String address,
    required String gender,
    required String dateOfBirth,
    required String description,
  }) async {
    try {
      final token = await StorageService.getToken();
      final response = await http.put(
        Uri.parse('${Env.baseUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fullname': fullName,
          'email': email,
          'address': address,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'description': description,
        }),
      );
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
