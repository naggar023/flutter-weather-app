# Building & Deployment Guide

## Android APK Build

### Prerequisites

```bash
# Verify Android SDK is installed
flutter doctor -v

# If issues, accept Android SDK licenses
flutter doctor --android-licenses
```

### Build Release APK

```bash
# Navigate to project directory
cd flutter_weather_app

# Get latest dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build Output Info

```
Size: ~50-80 MB (depending on dependencies)
Filename: app-release.apk
Minimum API Level: 16 (Android 4.1)
Target API Level: 33 (Android 13)
```

### Test APK on Device

```bash
# Connect Android device via USB
# Enable USB Debugging (Settings > Developer Options)

# Install APK
flutter install

# Or manual install:
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Android App Bundle (For Google Play Store)

### Build App Bundle

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Upload to Google Play Store

1. Sign up for [Google Play Developer Account](https://play.google.com/console)
2. Create new app
3. Fill in app details (name, description, screenshots)
4. Set up pricing and distribution
5. Upload `app-release.aab` in "Internal Testing" track
6. Add test users and gather feedback
7. Move to "Production" when ready

### Signing APK (Required for Play Store)

```bash
# Create keystore
keytool -genkey -v -keystore ~/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -alias my-key-alias

# Build signed APK
flutter build apk --release --obfuscate --split-debug-info=./symbols
```

---

## iOS Build

### Prerequisites (macOS only)

```bash
# Install iOS dependencies
flutter pub get

# Install pods
cd ios
pod install
cd ..

# Open in Xcode
open ios/Runner.xcworkspace
```

### Build for iOS Simulator

```bash
flutter run -d "iPhone 14"
```

### Build for Physical iOS Device

1. Open Xcode
2. Connect device
3. Select device in Xcode
4. Build and run

### Build iOS Release

```bash
flutter build ios --release

# or package as IPA:
flutter build ios --release && cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath Runner.xcarchive archive && xcodebuild -exportArchive -archivePath Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath build/ios/ipa && cd ..
```

### Upload to App Store

1. Sign up for [Apple Developer Account](https://developer.apple.com/)
2. Create App ID
3. Create Certificate and Provisioning Profile in Apple Developer Portal
4. In Xcode:
   - Select team account
   - Set bundle identifier
   - Set version and build number
5. Build archive: Product > Archive
6. Validate and upload via Xcode or Transporter

---

## Web Build (Preview)

```bash
# Build for web
flutter build web

# Serve locally
flutter run -d chrome

# Output: build/web/
# Host on Firebase Hosting, Netlify, or other platform
```

---

## Linux/Windows Desktop (Optional)

### Linux

```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

### Windows

```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

---

## Build Configuration

### Adjust App Version

Edit `pubspec.yaml`:

```yaml
version: 1.0.0+1  # Format: version+buildNumber
```

- `1.0.0` = semantic version
- `1` = build number (increment for each release)

### Adjust App Display Name

Edit `android/app/build.gradle` (Android):

```gradle
android {
  defaultConfig {
    applicationId "com.example.weather_app"
    minSdkVersion 16
    targetSdkVersion 33
  }
}
```

Edit `ios/Runner/Info.plist` (iOS):

```xml
<key>CFBundleDisplayName</key>
<string>Weather App</string>
```

---

## Release Checklist

Before release to app stores:

- [ ] API key secured (not hardcoded)
- [ ] All screens tested on target devices
- [ ] Error handling verified
- [ ] Loading states working correctly
- [ ] Favorites persistence tested
- [ ] Settings saved properly
- [ ] No console errors or warnings
- [ ] App icon designed and added
- [ ] Splash screen configured
- [ ] Permissions set correctly
- [ ] Privacy policy prepared
- [ ] Screenshots and descriptions written
- [ ] In-app content appropriate
- [ ] No external links broken
- [ ] Performance optimized
- [ ] Crash reporting enabled (optional)

---

## Obfuscation & Code Protection

### Enable Obfuscation

```bash
flutter build apk --release --obfuscate --split-debug-info=./symbols
```

This makes code harder to reverse-engineer.

---

## App Icons & Splash Screens

### Add App Icon

#### Android:

1. Prepare icon image (512x512 PNG)
2. Place in `android/app/src/main/res/mipmap-*/` folders:
   - `mipmap-ldpi/` (36x36)
   - `mipmap-mdpi/` (48x48)
   - `mipmap-hdpi/` (72x72)
   - `mipmap-xhdpi/` (96x96)
   - `mipmap-xxhdpi/` (144x144)
   - `mipmap-xxxhdpi/` (192x192)

3. Update `android/app/src/main/AndroidManifest.xml`:

```xml
<application
  android:icon="@mipmap/ic_launcher"
  android:label="@string/app_name">
```

#### iOS:

1. Open `ios/Runner.xcodeproj` in Xcode
2. Select Assets
3. Drag icon image to App Icon set
4. Ensure all sizes are filled

### Add Splash Screen

Use [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) package:

```bash
flutter pub add flutter_native_splash
```

Configure in `pubspec.yaml`:

```yaml
flutter_native_splash:
  color: "#42a5f5"
  image: assets/logo.png
```

Generate:

```bash
flutter pub run flutter_native_splash:create
```

---

## Performance Optimization

### Reduce APK Size

```bash
# Build with split APKs for different architectures
flutter build apk --release --split-per-abi

# Analyze APK size
flutter build apk --release --analyze-size
```

### Enable Minification

Edit `android/app/build.gradle`:

```gradle
buildTypes {
  release {
    minifyEnabled true
    shrinkResources true
    proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
  }
}
```

### Lazy Load Images

The app loads weather icons from OpenWeatherMap on-demand, which is good for performance.

---

## Testing Before Release

### Manual Testing Checklist

```
Search Functionality:
  [ ] Search by valid city name
  [ ] Search with invalid city (error handling)
  [ ] Search with empty input
  [ ] Search history displays and works

Weather Display:
  [ ] All metrics display correctly
  [ ] Numbers format properly
  [ ] Icons load from API
  [ ] Times display in local timezone

Favorites:
  [ ] Add to favorites works
  [ ] Remove from favorites works
  [ ] Favorites persist after app restart
  [ ] View favorite weather from list

Settings:
  [ ] Switch between °C and °F
  [ ] Temperature updates across app
  [ ] Settings persist after app restart
  [ ] Clear data works

Navigation:
  [ ] Bottom nav tabs work
  [ ] Back button works
  [ ] No crashes on transitions

Network:
  [ ] Works with WiFi
  [ ] Works with mobile data
  [ ] Handles offline gracefully
  [ ] Times out appropriately
```

---

## Firebase Crashlytics (Optional)

Add crash reporting:

```bash
flutter pub add firebase_core firebase_crashlytics
```

Initialize in `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  runApp(const MyApp());
}
```

---

## Analytics (Optional)

Add Google Analytics:

```bash
flutter pub add google_analytics_flutter
```

Track events:

```dart
analytics.logEvent(
  name: 'search_city',
  parameters: {'city': 'London'},
);
```

---

## Continuous Integration/Deployment

### GitHub Actions Example

Create `.github/workflows/build.yml`:

```yaml
name: Build & Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v2
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## Troubleshooting Build Issues

### Issue: Gradle Build Fails

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade

# Check gradlew permissions (Linux/macOS)
chmod +x android/gradlew
```

### Issue: Pod Install Fails (iOS)

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Issue: Version Code Must Increase

Edit `android/app/build.gradle`:

```gradle
versionCode += 1  // Increment for each release
```

### Issue: App Not Signing

```bash
# Recreate keystore and sign
keytool -genkey -v -keystore my-key.jks -keyalg RSA -keysize 2048 -validity 10950

flutter build apk --release
```

---

## Distribution Channels

### Google Play Store
- Most popular Android distribution
- Requires signing APK
- Review process: 2-4 hours typically

### Apple App Store
- Required for iOS distribution
- Requires Apple Developer Account ($99/year)
- Review process: 24-48 hours typically

### Direct Download
- Host APK on website
- Users can sideload
- No review process
- Less secure

### F-Droid
- Open source app store
- Requires open source license
- No review process
- Good for privacy-focused users

---

## Post-Release

### Monitor App Performance

1. Check crash reports daily
2. Monitor user feedback
3. Track analytics
4. Plan next release updates

### Update Regularly

```bash
# Increment version
version: 1.0.1+2  # was 1.0.0+1

# Rebuild and release
flutter build apk --release
```

---

**Happy deploying! 🚀**
