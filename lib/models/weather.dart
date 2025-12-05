/// Weather model class for storing weather data from OpenWeatherMap API
class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final int sunrise;
  final int sunset;
  final int timezone;
  final double pressure;
  final int visibility;
  final double cloudiness;
  final DateTime dateTime;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
    required this.pressure,
    required this.visibility,
    required this.cloudiness,
    required this.dateTime,
  });

  /// Parse JSON response from OpenWeatherMap API
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['main'] ?? 'Unknown',
      icon: json['weather'][0]['icon'] ?? '01d',
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      timezone: json['timezone'] ?? 0,
      pressure: (json['main']['pressure'] as num).toDouble(),
      visibility: json['visibility'] ?? 0,
      cloudiness: (json['clouds']['all'] as num).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
        isUtc: true,
      ),
    );
  }

  /// Convert to JSON for storing in local storage
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'description': description,
      'icon': icon,
      'sunrise': sunrise,
      'sunset': sunset,
      'timezone': timezone,
      'pressure': pressure,
      'visibility': visibility,
      'cloudiness': cloudiness,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  /// Create from JSON (for loading from local storage)
  factory Weather.fromStoredJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'] ?? 'Unknown',
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      description: json['description'] ?? 'Unknown',
      icon: json['icon'] ?? '01d',
      sunrise: json['sunrise'] ?? 0,
      sunset: json['sunset'] ?? 0,
      timezone: json['timezone'] ?? 0,
      pressure: (json['pressure'] as num).toDouble(),
      visibility: json['visibility'] ?? 0,
      cloudiness: (json['cloudiness'] as num).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
    );
  }
}
