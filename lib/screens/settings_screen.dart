import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

/// Settings Screen - Configure app preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Temperature Unit Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temperature Unit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose your preferred temperature unit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Celsius option
                      RadioListTile<String>(
                        title: const Text('Celsius (°C)'),
                        subtitle: const Text('Metric system'),
                        value: 'metric',
                        groupValue: weatherProvider.temperatureUnit,
                        onChanged: (value) {
                          if (value != null) {
                            weatherProvider.setTemperatureUnit(value);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                      // Fahrenheit option
                      RadioListTile<String>(
                        title: const Text('Fahrenheit (°F)'),
                        subtitle: const Text('Imperial system'),
                        value: 'imperial',
                        groupValue: weatherProvider.temperatureUnit,
                        onChanged: (value) {
                          if (value != null) {
                            weatherProvider.setTemperatureUnit(value);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App Information Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'App Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('App Name', 'Flutter Weather App'),
                      const SizedBox(height: 12),
                      _buildInfoRow('Version', '1.0.0'),
                      const SizedBox(height: 12),
                      _buildInfoRow('API Provider', 'OpenWeatherMap'),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Current Unit',
                        weatherProvider.temperatureUnit == 'metric'
                            ? 'Celsius (°C)'
                            : 'Fahrenheit (°F)',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Features Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Features',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureRow(
                        'Search Weather',
                        'Search for any city worldwide',
                        Icons.search,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureRow(
                        'Detailed Weather',
                        'View comprehensive weather information',
                        Icons.cloud_circle,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureRow(
                        'Save Favorites',
                        'Save your favorite cities for quick access',
                        Icons.favorite,
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureRow(
                        'Real-time Data',
                        'Get current weather updates from API',
                        Icons.refresh,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // About Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This Flutter Weather App provides real-time weather information using the OpenWeatherMap API. '
                        'You can search for any city, view detailed weather conditions, and manage your favorite locations.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Clear Data Section (Optional)
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear All Data'),
                      content: const Text(
                        'This will remove all favorites and search history. '
                        'This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            weatherProvider.clearAll();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All data cleared'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear All Data'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
