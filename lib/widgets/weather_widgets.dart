import 'package:flutter/material.dart';
import '../models/weather.dart';

/// Widget to display weather icon from OpenWeatherMap
class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({
    Key? key,
    required this.iconCode,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // OpenWeatherMap icon URL
    final imageUrl = 'https://openweathermap.org/img/wn/$iconCode@4x.png';
    
    return Image.network(
      imageUrl,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.cloud,
          size: size,
          color: Colors.grey,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: size,
          height: size,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

/// Widget for displaying a weather detail row
class WeatherDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const WeatherDetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget to display weather summary
class WeatherCard extends StatelessWidget {
  final Weather weather;
  final String temperatureSymbol;
  final VoidCallback? onTap;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const WeatherCard({
    Key? key,
    required this.weather,
    required this.temperatureSymbol,
    this.onTap,
    this.showRemoveButton = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          weather.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showRemoveButton)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: onRemove,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}$temperatureSymbol',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WeatherIcon(iconCode: weather.icon, size: 60),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Feels like ${weather.feelsLike.toStringAsFixed(1)}$temperatureSymbol',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
