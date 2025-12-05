import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import '../services/local_storage_service.dart';

/// Provider for managing weather data and API interactions
class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  final LocalStorageService _storageService = LocalStorageService();

  Weather? _currentWeather;
  List<Weather> _favoriteWeathers = [];
  String _temperatureUnit = 'metric'; // 'metric' for Celsius, 'imperial' for Fahrenheit
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _searchHistory = [];

  // Getters
  Weather? get currentWeather => _currentWeather;
  List<Weather> get favoriteWeathers => _favoriteWeathers;
  String get temperatureUnit => _temperatureUnit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get searchHistory => _searchHistory;
  
  String get temperatureSymbol => _temperatureUnit == 'metric' ? '°C' : '°F';
  String get windSpeedUnit => _temperatureUnit == 'metric' ? 'm/s' : 'mph';

  /// Initialize provider by loading settings and favorites
  Future<void> initialize() async {
    _temperatureUnit = await _storageService.getTemperatureUnit();
    _favoriteWeathers = await _storageService.getFavorites();
    notifyListeners();
  }

  /// Search weather by city name
  Future<void> searchWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) {
      _errorMessage = 'Please enter a city name';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentWeather = await _apiService.getWeatherByCity(
        city: cityName.trim(),
        units: _temperatureUnit,
      );

      // Add to search history
      if (!_searchHistory.contains(cityName.trim())) {
        _searchHistory.insert(0, cityName.trim());
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add current weather to favorites
  Future<void> addToFavorites() async {
    if (_currentWeather == null) return;

    try {
      await _storageService.addFavorite(_currentWeather!);
      _favoriteWeathers = await _storageService.getFavorites();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add favorite: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Remove a city from favorites
  Future<void> removeFavorite(String cityName) async {
    try {
      await _storageService.removeFavorite(cityName);
      _favoriteWeathers = await _storageService.getFavorites();
      
      // Clear current weather if it was removed from favorites
      if (_currentWeather?.cityName == cityName) {
        _currentWeather = null;
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to remove favorite: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Check if current weather is in favorites
  Future<bool> isCurrentWeatherFavorite() async {
    if (_currentWeather == null) return false;
    return await _storageService.isFavorite(_currentWeather!.cityName);
  }

  /// Change temperature unit
  Future<void> setTemperatureUnit(String unit) async {
    if (unit == _temperatureUnit) return;

    _temperatureUnit = unit;
    await _storageService.setTemperatureUnit(unit);
    
    // Refresh current weather with new unit
    if (_currentWeather != null) {
      try {
        _currentWeather = await _apiService.getWeatherByCity(
          city: _currentWeather!.cityName,
          units: _temperatureUnit,
        );
      } catch (e) {
        _errorMessage = 'Failed to refresh weather: ${e.toString()}';
      }
    }

    notifyListeners();
  }

  /// Get weather for a favorite city
  Future<void> getWeatherForCity(String cityName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentWeather = await _apiService.getWeatherByCity(
        city: cityName,
        units: _temperatureUnit,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    _currentWeather = null;
    _errorMessage = null;
    _searchHistory = [];
    await _storageService.clearFavorites();
    _favoriteWeathers = [];
    notifyListeners();
  }
}
