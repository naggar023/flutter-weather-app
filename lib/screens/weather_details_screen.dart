import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_widgets.dart';

/// Weather Details Screen - Shows detailed weather information
class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({Key? key}) : super(key: key);

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await context.read<WeatherProvider>().isCurrentWeatherFavorite();
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _toggleFavorite(BuildContext context) async {
    final weatherProvider = context.read<WeatherProvider>();
    if (_isFavorite) {
      await weatherProvider.removeFavorite(weatherProvider.currentWeather!.cityName);
    } else {
      await weatherProvider.addToFavorites();
    }
    
    _isFavorite = await weatherProvider.isCurrentWeatherFavorite();
    if (mounted) {
      setState(() {});
    }
  }

  String _formatTime(int timestamp, int timezoneOffset) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffset));
    
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              return IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => _toggleFavorite(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final weather = weatherProvider.currentWeather;

          if (weather == null) {
            return const Center(
              child: Text('No weather data available'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Top section with temperature and weather icon
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade600,
                        Colors.blue.shade400,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeatherIcon(
                        iconCode: weather.icon,
                        size: 120,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}${weatherProvider.temperatureSymbol}',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Feels like ${weather.feelsLike.toStringAsFixed(1)}${weatherProvider.temperatureSymbol}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Details section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weather Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Grid of weather details
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildDetailCard(
                            label: 'Humidity',
                            value: '${weather.humidity.toStringAsFixed(0)}%',
                            icon: Icons.opacity,
                            iconColor: Colors.blue,
                          ),
                          _buildDetailCard(
                            label: 'Wind Speed',
                            value: '${weather.windSpeed.toStringAsFixed(1)} ${weatherProvider.windSpeedUnit}',
                            icon: Icons.air,
                            iconColor: Colors.lightBlue,
                          ),
                          _buildDetailCard(
                            label: 'Pressure',
                            value: '${weather.pressure.toStringAsFixed(0)} hPa',
                            icon: Icons.speed,
                            iconColor: Colors.orange,
                          ),
                          _buildDetailCard(
                            label: 'Visibility',
                            value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                            icon: Icons.visibility,
                            iconColor: Colors.purple,
                          ),
                          _buildDetailCard(
                            label: 'Cloudiness',
                            value: '${weather.cloudiness.toStringAsFixed(0)}%',
                            icon: Icons.cloud,
                            iconColor: Colors.grey,
                          ),
                          _buildDetailCard(
                            label: 'UV Index',
                            value: 'N/A',
                            icon: Icons.wb_sunny,
                            iconColor: Colors.yellow.shade700,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sun times
                      const Text(
                        'Sun Times',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildSunTimeCard(
                              label: 'Sunrise',
                              time: _formatTime(weather.sunrise, weather.timezone),
                              icon: Icons.wb_twilight,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSunTimeCard(
                              label: 'Sunset',
                              time: _formatTime(weather.sunset, weather.timezone),
                              icon: Icons.nights_stay,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Last updated
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.update, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              'Last updated: ${DateFormat('dd/MM/yyyy HH:mm').format(weather.dateTime)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTimeCard({
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
