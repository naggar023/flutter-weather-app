import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/weather.dart';

/// Service for managing local storage of favorite cities
class LocalStorageService {
  static const String _favoritesKey = 'favorite_cities';
  static const String _settingsKey = 'app_settings';

  /// Save a weather entry to favorites
  Future<void> addFavorite(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    // Avoid duplicates
    if (!favorites.any((w) => w.cityName.toLowerCase() == weather.cityName.toLowerCase())) {
      favorites.add(weather);
      final jsonList = favorites.map((w) => jsonEncode(w.toJson())).toList();
      await prefs.setStringList(_favoritesKey, jsonList);
    }
  }

  /// Remove a city from favorites by name
  Future<void> removeFavorite(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((w) => w.cityName.toLowerCase() == cityName.toLowerCase());
    final jsonList = favorites.map((w) => jsonEncode(w.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  /// Get all favorite cities
  Future<List<Weather>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey) ?? [];
    
    return jsonList.map((json) {
      final data = jsonDecode(json);
      return Weather.fromStoredJson(data);
    }).toList();
  }

  /// Check if a city is in favorites
  Future<bool> isFavorite(String cityName) async {
    final favorites = await getFavorites();
    return favorites.any((w) => w.cityName.toLowerCase() == cityName.toLowerCase());
  }

  /// Save temperature unit preference
  Future<void> setTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temp_unit', unit);
  }

  /// Get temperature unit preference (default: metric)
  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('temp_unit') ?? 'metric';
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}
