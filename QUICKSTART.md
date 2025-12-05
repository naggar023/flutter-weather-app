# Quick Start Guide 🚀

Get the Flutter Weather App running in 5 minutes!

## 1️⃣ Clone/Download Project

```bash
cd flutter_weather_app
```

## 2️⃣ Get Your API Key (2 minutes)

1. Visit: https://openweathermap.org/api
2. Sign up (free account)
3. Go to "API Keys" tab
4. Copy your API key

## 3️⃣ Configure API Key (1 minute)

### Quick Method (for testing):

Open `lib/constants/api_config.dart` and replace:

```dart
static const String apiKey = 'YOUR_API_KEY_HERE';
```

with your actual key:

```dart
static const String apiKey = 'abc123xyz789...';
```

## 4️⃣ Install & Run (2 minutes)

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## 5️⃣ Test the Features

### Home Screen ✅
- Type a city name (e.g., "London", "Paris", "Tokyo")
- Tap "Search Weather"
- See current weather data

### Weather Details ✅
- Tap "View Details" button
- See all weather metrics
- Tap heart icon to add to favorites

### Favorites ✅
- Go to "Favorites" tab (bottom navigation)
- See your saved cities
- Tap to view details again
- Swipe or tap X to remove

### Settings ✅
- Go to "Settings" tab
- Change between °C (Celsius) and °F (Fahrenheit)
- Try searching again - temperature will update!

## 🎯 What You'll See

### Home Screen
- Search bar at top
- Display of current weather after search
- Temperature, "feels like", and weather description
- Recent search history

### Weather Details Screen
- Large temperature display (°C or °F based on settings)
- 6 detailed metrics:
  - Humidity (%)
  - Wind Speed (m/s or mph)
  - Pressure (hPa)
  - Visibility (km)
  - Cloudiness (%)
  - UV Index (placeholder)
- Sunrise/Sunset times
- Last updated timestamp
- Heart icon to add/remove favorite

### Favorites Screen
- List of all saved favorite cities
- Tap any card to view details
- Remove button on each card
- Empty state if no favorites yet

### Settings Screen
- Temperature unit selector
- App information
- Features list
- About section
- Clear all data button

## 🐛 Troubleshooting

### "Invalid API Key" Error
→ Check you copied the correct API key
→ Make sure OpenWeatherMap account is active

### "City Not Found"
→ Check city spelling
→ Try "London" or "Paris" as test cities

### "Request Timeout"
→ Check internet connection
→ Try again

## 📚 Full Guides

For detailed setup: See `SETUP.md`
For API configuration: See `API_KEY_SETUP.md`
For building APK: See `BUILD_AND_DEPLOY.md`
For full features: See `README.md`

## 🔧 Important Configuration Files

```
lib/
├── constants/api_config.dart          ← YOUR API KEY GOES HERE
├── main.dart                          ← App entry point
├── providers/weather_provider.dart    ← State management
└── screens/
    ├── home_screen.dart              ← Search screen
    ├── weather_details_screen.dart   ← Details view
    ├── favorites_screen.dart         ← Favorites list
    └── settings_screen.dart          ← Settings
```

## ✨ Next Steps

1. ✅ Test with a few cities (London, New York, Tokyo)
2. 📱 Add some to favorites
3. 🎨 Change temperature units
4. 📦 Build APK: `flutter build apk --release`
5. 🚀 Share with friends or deploy to Play Store

## 🔐 Before Going Public

**IMPORTANT**: Before uploading to GitHub or Google Play Store:

1. **Remove/Secure API Key**:
   - Move to environment variable (see `API_KEY_SETUP.md`)
   - DO NOT commit hardcoded API key!

2. **Add .env to .gitignore** (already done)

3. **Review Code**:
   - No warnings: `flutter analyze`
   - Format code: `dart format lib/`

## 📞 Need Help?

**Issues?**
→ Check `SETUP.md` for detailed setup instructions
→ Check `API_KEY_SETUP.md` for API key problems
→ Read `README.md` for full feature documentation

**Building?**
→ See `BUILD_AND_DEPLOY.md` for APK build instructions

## 🎉 You're Ready!

The app is fully functional with:
- ✅ Search any city
- ✅ View detailed weather
- ✅ Save favorites
- ✅ Change temperature units
- ✅ Beautiful UI with proper error handling

Enjoy! 🌤️

---

**Pro Tips:**
- Use `flutter run -v` for detailed debugging
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- `flutter devices` to see connected devices

Happy coding! 🚀
