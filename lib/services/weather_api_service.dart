import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';
import '../constants/api_config.dart';

/// Service class for interacting with OpenWeatherMap API
class WeatherApiService {
  /// Fetch weather data for a given city
  ///
  /// Throws an exception if:
  /// - Network request fails
  /// - City is not found (404)
  /// - API key is invalid (401)
  /// - Other API errors occur
  Future<Weather> getWeatherByCity({
    required String city,
    required String units, // 'metric' or 'imperial'
  }) async {
    try {
      final url = ApiConfig.getWeatherUrl(city: city, units: units);
      
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout. Check your internet connection.'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Weather.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the spelling and try again.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your API configuration.');
      } else {
        throw Exception('Failed to fetch weather data. Status code: ${response.statusCode}');
      }
    } on Exception catch (e) {
      rethrow;
    }
  }

  /// Fetch weather data by coordinates (latitude, longitude)
  Future<Weather> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
    required String units,
  }) async {
    try {
      final url = ApiConfig.getWeatherByCoordinatesUrl(
        latitude: latitude,
        longitude: longitude,
        units: units,
      );
      
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout. Check your internet connection.'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Weather.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your API configuration.');
      } else {
        throw Exception('Failed to fetch weather data. Status code: ${response.statusCode}');
      }
    } on Exception catch (e) {
      rethrow;
    }
  }
}
