import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/boat.dart';

class BoatStorageService {
  static const String _boatKey = 'saved_boat';

  static Future<void> saveBoat(Boat boat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_boatKey, jsonEncode(boat.toJson()));
  }

  static Future<Boat?> getBoat() async {
    final prefs = await SharedPreferences.getInstance();
    final boatJson = prefs.getString(_boatKey);

    if (boatJson == null) {
      return null;
    }

    return Boat.fromJson(jsonDecode(boatJson));
  }

  static Future<void> deleteBoat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_boatKey);
  }
}
