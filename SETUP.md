# Setup Guide - Flutter Weather App

## Quick Start Guide

This document provides step-by-step instructions to set up and run the Flutter Weather App.

## Prerequisites

### Required Software
- **Flutter SDK**: Version 3.9.2 or later
  - Download from: https://flutter.dev/docs/get-started/install
- **Dart SDK**: Comes bundled with Flutter
- **Android Studio** or **Xcode** (depending on target platform)
- **Git**: For version control

### Recommended Tools
- **VS Code** with Flutter and Dart extensions
- **Android Emulator** or physical Android device
- **iOS Simulator** (macOS) or physical iOS device

## Step 1: Obtain OpenWeatherMap API Key

### Create a Free Account

1. Visit [OpenWeatherMap Website](https://openweathermap.org/api)
2. Click "Sign Up" button
3. Create an account with email and password
4. Verify your email address

### Generate API Key

1. Log in to your OpenWeatherMap account
2. Go to **API Keys** section
3. Your default API key will be shown
4. Copy this key - you'll need it in the next steps

**Note**: Free tier allows up to 60 API calls/minute and 1,000,000 calls/month.

## Step 2: Clone and Setup Project

### Option A: From Git Repository

```bash
# Clone the repository
git clone https://github.com/your-username/flutter_weather_app.git

# Navigate to project directory
cd flutter_weather_app

# Get Flutter dependencies
flutter pub get
```

### Option B: Manual Setup

If you already have the project files:

```bash
# Navigate to project directory
cd flutter_weather_app

# Get Flutter dependencies
flutter pub get

# Verify setup
flutter doctor
```

## Step 3: Configure API Key

### **IMPORTANT**: Protecting Your API Key

Never commit your API key to version control! Here are two safe methods:

### Method 1: Direct Configuration (Development Only)

⚠️ **Only for local development - DO NOT use for production!**

1. Open `lib/constants/api_config.dart`
2. Find this line:
   ```dart
   static const String apiKey = 'YOUR_API_KEY_HERE';
   ```
3. Replace `'YOUR_API_KEY_HERE'` with your actual API key:
   ```dart
   static const String apiKey = 'abc123def456ghi789jkl';
   ```
4. Save the file

### Method 2: Environment Variables (Recommended)

This method keeps your API key secure and out of version control.

#### For Windows (PowerShell):

1. Create a `.env` file in your project root:
   ```
   OPENWEATHER_API_KEY=your_api_key_here
   ```

2. Add `.env` to `.gitignore` (already done):
   ```
   .env
   .env.local
   ```

3. Install the `flutter_dotenv` package:
   ```bash
   flutter pub add flutter_dotenv
   ```

4. Update `lib/constants/api_config.dart`:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   class ApiConfig {
     static final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? 'YOUR_API_KEY_HERE';
     // ... rest of code
   }
   ```

5. Update `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - .env
   ```

## Step 4: Verify Setup

### Check Flutter Installation

```bash
# Verify Flutter and Dart
flutter doctor

# Expected output should show:
# - Flutter (Channel stable, version x.x.x)
# - Dart SDK (version x.x.x)
# - Android toolchain
# - Xcode (if on macOS)
# - VS Code / Android Studio
```

### Get Project Dependencies

```bash
# Get all dependencies
flutter pub get

# Verify no errors
flutter analyze
```

## Step 5: Run the App

### On Physical Android Device

1. Connect your Android phone via USB
2. Enable USB Debugging (Settings > Developer Options)
3. Run:
   ```bash
   flutter run
   ```

### On Android Emulator

```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators launch <emulator_name>

# Run app
flutter run
```

### On iOS (macOS only)

```bash
# Get iOS dependencies
flutter pub get
cd ios
pod install
cd ..

# Run on simulator
flutter run

# Or on physical device (requires setup)
```

### On Web (Preview)

```bash
flutter run -d chrome
```

## Step 6: First Run

### What to Expect

1. App launches with Welcome screen
2. Search bar visible at the top
3. "Recent Searches" section empty on first run
4. Bottom navigation with Home, Favorites, Settings tabs

### Test the App

1. **Search for a City**:
   - Type "London" in search bar
   - Tap "Search Weather"
   - Should display London's current weather

2. **View Details**:
   - Tap "View Details" button
   - Should show detailed weather information
   - Verify all metrics display correctly

3. **Add to Favorites**:
   - Tap heart icon to add to favorites
   - Go to "Favorites" tab
   - Should see London in favorites list

4. **Change Temperature Unit**:
   - Go to "Settings" tab
   - Select "Fahrenheit (°F)"
   - Go back to search and verify temperature units changed

## Building for Production

### Android APK Release

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Google Play)

```bash
# Build app bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS Release

```bash
# Build iOS release
flutter build ios --release

# Follow Xcode setup for App Store distribution
```

## Troubleshooting

### Common Issues

#### Issue: "Invalid API Key" Error
**Solution**:
- Verify API key in `api_config.dart`
- Check OpenWeatherMap account is active
- Ensure free tier access is enabled
- Re-generate key if necessary

#### Issue: "City Not Found"
**Solution**:
- Check city name spelling
- Try major cities first (London, Paris, Tokyo)
- Some cities may need country code (London, UK)

#### Issue: Network Timeout
**Solution**:
- Check internet connection
- Verify OpenWeatherMap API is accessible
- Check API rate limits haven't been exceeded
- Try again in a few moments

#### Issue: Flutter Commands Not Found
**Solution**:
```bash
# Add Flutter to PATH (Windows PowerShell):
$env:Path += ";C:\src\flutter\bin"

# Or add permanently:
# Edit Environment Variables > PATH > Add Flutter bin directory
```

#### Issue: Dependency/Pub Get Errors
**Solution**:
```bash
# Clean and reinstall
flutter clean
flutter pub get
flutter pub upgrade
```

#### Issue: Android Build Errors
**Solution**:
```bash
# Check Android setup
flutter doctor -v

# Accept licenses
flutter doctor --android-licenses

# Clean build
flutter clean
flutter build apk --release
```

## Project Structure Reference

```
flutter_weather_app/
├── lib/
│   ├── constants/
│   │   └── api_config.dart          # ← ADD YOUR API KEY HERE
│   ├── models/
│   │   └── weather.dart
│   ├── services/
│   │   ├── weather_api_service.dart
│   │   └── local_storage_service.dart
│   ├── providers/
│   │   └── weather_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── weather_details_screen.dart
│   │   ├── favorites_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   └── weather_widgets.dart
│   └── main.dart                    # ← App entry point
├── .env                             # ← Optional: Environment variables
├── .gitignore
├── pubspec.yaml                     # ← Dependencies
└── README.md
```

## Dependencies Explained

| Package | Purpose | Version |
|---------|---------|---------|
| `provider` | State management | ^6.0.0 |
| `http` | HTTP requests to API | ^1.1.0 |
| `shared_preferences` | Local data storage | ^2.2.0 |
| `intl` | Date/time formatting | ^0.19.0 |
| `cupertino_icons` | iOS-style icons | ^1.0.8 |

## Environment Setup (Advanced)

### Use flutter_dotenv for Production

1. **Add package**:
   ```bash
   flutter pub add flutter_dotenv
   ```

2. **Create `.env` file** in project root:
   ```
   OPENWEATHER_API_KEY=your_actual_key_here
   ```

3. **Update `api_config.dart`**:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   class ApiConfig {
     static final String apiKey = 
       dotenv.env['OPENWEATHER_API_KEY'] ?? 'YOUR_API_KEY_HERE';
     // ... rest of configuration
   }
   ```

4. **Update `main.dart`**:
   ```dart
   void main() async {
     await dotenv.load();
     runApp(const MyApp());
   }
   ```

## Development Tips

### Hot Reload & Hot Restart

```bash
# Hot reload (fast - only reloads code)
# In terminal: Press 'r'

# Hot restart (slower - full restart)
# In terminal: Press 'R'

# Full rebuild
# In terminal: Press 'q' to quit, then flutter run again
```

### Enable Debug Logging

```bash
# Run with verbose output
flutter run -v

# See verbose logs during build
flutter build apk -v
```

### Testing API Connectivity

Test API directly before running app:

```bash
# In terminal
curl "https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY&units=metric"
```

Should return JSON weather data.

## Next Steps

1. ✅ Complete the setup guide above
2. 📱 Run the app and verify it works
3. 🎨 Customize the theme if desired
4. 🚀 Build APK/IPA for distribution
5. 📤 Deploy to Google Play Store / App Store

## Getting Help

### Resources
- **Flutter Docs**: https://flutter.dev/docs
- **OpenWeatherMap API**: https://openweathermap.org/api
- **Provider Package**: https://pub.dev/packages/provider
- **Stack Overflow**: Tag with `flutter`

### Common Commands

```bash
# View connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Check project structure
tree lib/

# Update dependencies
flutter pub upgrade

# Check for issues
flutter analyze

# Format code
dart format lib/
```

## Support

If you encounter issues not covered here:

1. Check the **README.md** for more info
2. Review **API documentation**
3. Check Flutter community forums
4. Open an issue in the repository

---

**Happy coding! 🚀**
