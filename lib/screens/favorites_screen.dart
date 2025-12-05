import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_widgets.dart';
import 'weather_details_screen.dart';

/// Favorites Screen - Displays saved favorite cities
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  void _viewFavoriteWeather(BuildContext context, String cityName) async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.getWeatherForCity(cityName);
    
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const WeatherDetailsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.favoriteWeathers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Favorites Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add cities to your favorites to see them here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to home screen
                      DefaultTabController.of(context)?.animateTo(0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Add Cities'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: weatherProvider.favoriteWeathers.length,
            itemBuilder: (context, index) {
              final weather = weatherProvider.favoriteWeathers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: WeatherCard(
                  weather: weather,
                  temperatureSymbol: weatherProvider.temperatureSymbol,
                  showRemoveButton: true,
                  onTap: () => _viewFavoriteWeather(context, weather.cityName),
                  onRemove: () {
                    weatherProvider.removeFavorite(weather.cityName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${weather.cityName} removed from favorites'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
