import 'package:http/http.dart' as http;
import 'package:my_project/services/storage_service.dart';
import 'dart:convert';

class AppHttpClient {
  static Future<http.Response> get(String url) async {
    final token = await StorageService.getToken();
    return await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> post(String url,
      {Map<String, dynamic>? body}) async {
    final token = await StorageService.getToken();
    return await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> put(String url,
      {Map<String, dynamic>? body}) async {
    final token = await StorageService.getToken();
    return await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> delete(String url) async {
    final token = await StorageService.getToken();
    return await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}
