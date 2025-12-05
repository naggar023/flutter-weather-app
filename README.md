# Flutter Weather App 🌤️

A beautiful and functional multi-page Flutter mobile application that retrieves and displays real-time current weather data using the **OpenWeatherMap Current Weather API**.

## Features ✨

- **Search Weather**: Search for any city worldwide and get current weather information
- **Detailed Weather Info**: View comprehensive weather details including:
  - Current temperature and "feels like" temperature
  - Weather description and conditions
  - Humidity and wind speed
  - Pressure and visibility
  - Cloudiness percentage
  - Sunrise and sunset times
  - Weather icons from OpenWeatherMap
  - Local time based on timezone

- **Favorite Cities**: Save your favorite cities for quick access
- **Temperature Units**: Switch between Celsius (°C) and Fahrenheit (°F)
- **Search History**: Recent search history for quick access
- **Real-time Updates**: Always get the latest weather data from the API
- **Clean UI**: Modern, responsive interface with smooth navigation
- **Error Handling**: Graceful error handling for network issues and API errors

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point and main navigation
├── constants/
│   └── api_config.dart      # API configuration and endpoints
├── models/
│   └── weather.dart         # Weather data model
├── services/
│   ├── weather_api_service.dart      # API interaction service
│   └── local_storage_service.dart    # Local storage for favorites
├── providers/
│   └── weather_provider.dart         # State management (Provider)
├── screens/
│   ├── home_screen.dart             # Home/Search screen
│   ├── weather_details_screen.dart  # Weather details screen
│   ├── favorites_screen.dart        # Favorites management screen
│   └── settings_screen.dart         # Settings and preferences
└── widgets/
    └── weather_widgets.dart         # Reusable weather widgets
```

## Setup Instructions 🚀

### Prerequisites
- Flutter SDK (3.9.2 or later)
- Dart SDK
- Android Studio, Xcode, or VS Code with Flutter extension
- OpenWeatherMap API key (free tier available)

### 1. Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key from your account dashboard
4. Keep your API key safe

### 2. Clone/Setup Project

```bash
# Clone the repository
git clone <repository-url>
cd flutter_weather_app

# Get Flutter dependencies
flutter pub get
```

### 3. Configure API Key

**IMPORTANT**: Do NOT commit your API key to version control!

#### Option A: Using the API Config file (Development)

1. Open `lib/constants/api_config.dart`
2. Replace `'YOUR_API_KEY_HERE'` with your actual OpenWeatherMap API key:

```dart
class ApiConfig {
  static const String apiKey = 'your_actual_api_key_here'; // Replace this
  // ... rest of the code
}
```

#### Option B: Using Environment Variables (Recommended for Production)

1. Create a `.env` file in the project root:
```
OPENWEATHER_API_KEY=your_actual_api_key_here
```

2. Add `.env` to `.gitignore` to prevent committing sensitive data
3. Use a package like `flutter_dotenv` to load the environment variable

### 4. Run the App

```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in debug mode
flutter run --debug

# Run in release mode (for building APK)
flutter run --release
```

## Building APK (Android) 📱

### Generate Release APK

```bash
# Build release APK
flutter build apk --release

# Build with verbose output
flutter build apk --release --verbose

# Output location: build/app/outputs/flutter-apk/app-release.apk
```

### Generate App Bundle (for Google Play Store)

```bash
flutter build appbundle --release
```

### Sign APK (Optional)

Follow the [Flutter documentation](https://flutter.dev/docs/deployment/android#signing-the-app) for signing your APK for production release.

## iOS Build (macOS/iOS) 🍎

```bash
# Build iOS app
flutter build ios --release

# Open in Xcode for further configuration
open ios/Runner.xcworkspace
```

## Dependencies 📦

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.0
  
  # Networking
  http: ^1.1.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  
  # Date/Time formatting
  intl: ^0.19.0
  
  # UI Icons
  cupertino_icons: ^1.0.8
```

## API Usage 🌐

### Current Weather Endpoint

The app uses the OpenWeatherMap Current Weather API:

**By City Name:**
```
GET https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units={units}
```

**By Coordinates:**
```
GET https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API_KEY}&units={units}
```

### Parameters

- `q`: City name (e.g., "London", "New York")
- `lat`: Latitude coordinate
- `lon`: Longitude coordinate
- `appid`: Your OpenWeatherMap API key
- `units`: Temperature units
  - `metric`: Celsius (°C) - Default
  - `imperial`: Fahrenheit (°F)

### Response Example

```json
{
  "coord": {"lon": 10.99, "lat": 44.34},
  "weather": [{"id": 500, "main": "Rain", "description": "light rain"}],
  "main": {
    "temp": 9.19,
    "feels_like": 6.26,
    "temp_min": 8.15,
    "temp_max": 10.21,
    "pressure": 1015,
    "humidity": 72
  },
  "wind": {"speed": 3.22},
  "clouds": {"all": 65},
  "visibility": 10000,
  "dt": 1628755814,
  "sys": {"sunrise": 1628740268, "sunset": 1628791697},
  "timezone": 7200,
  "name": "Parma",
  "cod": 200
}
```

## App Screens 📱

### 1. Home / Search Screen
- Search bar for city input
- Recent search history
- Display current weather for searched city
- Navigate to weather details
- Error handling for invalid cities

### 2. Weather Details Screen
- Large temperature display with weather icon
- "Feels like" temperature
- Grid of weather metrics:
  - Humidity
  - Wind speed
  - Pressure
  - Visibility
  - Cloudiness
- Sunrise and sunset times
- Add/remove from favorites button
- Last updated timestamp

### 3. Favorites Screen
- List of all saved favorite cities
- Quick access to favorite weather
- Remove favorites with confirmation
- Empty state message with navigation to search

### 4. Settings Screen
- Temperature unit selector (°C / °F)
- App information
- Available features list
- Clear all data option
- About section

## State Management 🔄

The app uses **Provider** package for state management with a single `WeatherProvider` that handles:

- Current weather data
- Favorite cities list
- Temperature unit preference
- Search history
- Loading and error states
- Local storage integration

```dart
// Example usage:
final weatherProvider = context.read<WeatherProvider>();
await weatherProvider.searchWeatherByCity('London');
final weather = weatherProvider.currentWeather;
final isFavorite = await weatherProvider.isCurrentWeatherFavorite();
```

## Local Storage 💾

The app uses **shared_preferences** to store:

- Favorite cities (weather data)
- Temperature unit preference
- User settings

All data is persisted locally and survives app restarts.

## Error Handling 🛡️

The app handles various error scenarios:

- **Network Errors**: Timeout and connection failures with user-friendly messages
- **Invalid City**: 404 error when city is not found
- **Invalid API Key**: 401 error with guidance
- **API Errors**: Generic error handling with status codes
- **Empty Search**: Validation before API calls

## Features Implemented ✅

### Core Features
- [x] Multi-page application with bottom tab navigation
- [x] Search weather by city name
- [x] Display current weather with detailed information
- [x] Save favorite cities
- [x] View favorite cities list
- [x] Remove favorites
- [x] Temperature unit switching (°C / °F)
- [x] Settings screen with preferences
- [x] Search history

### Technical Features
- [x] REST API integration (OpenWeatherMap)
- [x] Provider state management
- [x] Local storage (shared_preferences)
- [x] Proper error handling
- [x] Loading indicators
- [x] Responsive UI design
- [x] Clean code structure
- [x] Reusable widgets
- [x] Weather icons from API

### Additional Features
- [x] Real-time weather data
- [x] Local time display based on timezone
- [x] Sunrise/Sunset times
- [x] Weather description and conditions
- [x] Humidity, wind speed, pressure, visibility display
- [x] Last updated timestamp

## Troubleshooting 🔧

### "Invalid API Key" Error
- Verify your API key is correct in `api_config.dart`
- Check that your OpenWeatherMap account is active
- Ensure free tier API access is enabled

### "City Not Found" Error
- Check spelling of city name
- Some cities may require country code (e.g., "London, UK")
- Try another city to verify the app is working

### Network Timeout
- Check internet connection
- Verify API endpoint is accessible
- Try again - API may be temporarily unavailable

### APK Build Issues
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --release

# If still issues, check Android SDK version
flutter doctor
```

## Future Enhancements 🚀

- [ ] GPS location-based weather
- [ ] Weather forecast (5-day, hourly)
- [ ] Multiple weather provider APIs
- [ ] Weather alerts and notifications
- [ ] Dark theme support
- [ ] Weather charts and graphs
- [ ] Share weather information
- [ ] Weather comparison between cities
- [ ] Air quality index (AQI)
- [ ] UV index data

## Testing 🧪

```bash
# Run tests (if any test files are added)
flutter test

# Run tests with coverage
flutter test --coverage

# Build and test APK
flutter build apk --release
# Test on device
flutter install
```

## Contributing 🤝

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources 📚

- [Flutter Documentation](https://flutter.dev/docs)
- [OpenWeatherMap API Docs](https://openweathermap.org/api)
- [Provider Package](https://pub.dev/packages/provider)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [HTTP Package](https://pub.dev/packages/http)

## Contact & Support 📧

For questions, issues, or suggestions, please open an issue in the repository or contact the development team.

---

**Made with ❤️ using Flutter**

Happy coding! 🚀
