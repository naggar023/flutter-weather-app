# API Key Configuration Guide

## ⚠️ IMPORTANT SECURITY NOTE

**NEVER commit your API keys to version control!**

API keys should:
- Be kept secret and private
- Not be shared with others
- Not be hardcoded in production builds
- Be rotated regularly if compromised

## Getting Your OpenWeatherMap API Key

### Step 1: Create an Account

1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Click **Sign Up**
3. Fill in your details (email, password)
4. Verify your email address
5. Log in to your account

### Step 2: Find Your API Key

1. After login, go to **API Keys** tab in your account
2. You'll see a default API key generated automatically
3. Copy this key (it looks like: `abc123def456ghi789jkl0123456789`)

### Step 3: Configure in Flutter App

Choose **ONE** of these methods:

## Method 1: Direct Configuration (Development Only)

⚠️ **RISK**: API key visible in source code. Never use for production or public repositories!

### Setup:

1. Open `lib/constants/api_config.dart`
2. Replace the placeholder:

```dart
// BEFORE:
static const String apiKey = 'YOUR_API_KEY_HERE';

// AFTER:
static const String apiKey = 'your_actual_api_key_here';
```

3. Save and run: `flutter run`

**DO NOT COMMIT THIS FILE** if using method!

---

## Method 2: Environment Variables (Recommended)

✅ **SAFE**: API key stays out of version control.

### For Windows/macOS/Linux:

#### Step 1: Create .env File

Create a file named `.env` in your project root:

```
OPENWEATHER_API_KEY=your_actual_api_key_here
```

**Example `.env` file:**
```
OPENWEATHER_API_KEY=2c6f6c8c7d9e0f1a2b3c4d5e6f7a8b9c
```

#### Step 2: Update .gitignore

Make sure `.env` is in `.gitignore`:

```
# Environment files - DO NOT COMMIT API KEYS
.env
.env.local
.env.*.local
```

✅ Already added in this project!

#### Step 3: Install flutter_dotenv

```bash
flutter pub add flutter_dotenv
```

#### Step 4: Update api_config.dart

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String apiKey = 
    dotenv.env['OPENWEATHER_API_KEY'] ?? 'YOUR_API_KEY_HERE';
  
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  // ... rest of code
}
```

#### Step 5: Update main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}
```

#### Step 6: Update pubspec.yaml

```yaml
flutter:
  assets:
    - .env
```

---

## Method 3: Build-Time Configuration (Advanced)

For production builds, use build arguments or secrets management tools.

---

## Verifying Your API Key Works

### Test with curl (Windows PowerShell):

```powershell
# Replace YOUR_API_KEY with your actual key
$apiKey = "your_actual_api_key_here"
$url = "https://api.openweathermap.org/data/2.5/weather?q=London&appid=$apiKey&units=metric"

Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content | ConvertFrom-Json
```

### Expected Response:

```json
{
  "coord": {"lon": -0.1257, "lat": 51.5085},
  "weather": [{"id": 801, "main": "Clouds", "description": "few clouds"}],
  "main": {
    "temp": 15.5,
    "feels_like": 15.2,
    "temp_min": 14.1,
    "temp_max": 16.8,
    "pressure": 1013,
    "humidity": 72
  },
  "wind": {"speed": 3.5},
  "clouds": {"all": 20},
  "dt": 1638705600,
  "sys": {"sunrise": 1638700800, "sunset": 1638731400},
  "timezone": 0,
  "name": "London",
  "cod": 200
}
```

If you see `"cod":"401"`, your API key is invalid!

---

## Common Issues & Solutions

### Issue: "Invalid API Key" Error

**Possible causes:**
- API key copied incorrectly (extra spaces?)
- API key in wrong place in code
- OpenWeatherMap account not activated
- Using free tier but reached API limits

**Solution:**
1. Copy API key again from OpenWeatherMap dashboard
2. Make sure there are no extra spaces
3. Verify OpenWeatherMap account is active
4. Check API usage in OpenWeatherMap dashboard

### Issue: "City Not Found"

This is **not** an API key issue! Your key is working.
- Check city spelling
- Try another city to verify
- Some cities may need country code (e.g., "London, UK")

### Issue: Rate Limit Exceeded

Free tier has limits: 60 calls/minute, 1,000,000 calls/month

**Solution:**
- Upgrade to a paid plan
- Wait and retry
- Check usage in OpenWeatherMap dashboard

---

## API Key Best Practices

✅ **DO:**
- Keep keys out of version control
- Use environment variables
- Rotate keys regularly
- Use one key per environment (dev, staging, production)
- Monitor API usage

❌ **DON'T:**
- Hardcode keys in source files
- Commit keys to GitHub/GitLab
- Share keys via email or chat
- Use same key for multiple apps
- Leave keys in client-side code exposed

---

## .gitignore Template

Add these lines to ensure secrets aren't committed:

```gitignore
# Environment and secrets
.env
.env.local
.env.*.local
.env.*.secret

# IDE secrets
.vscode/settings.json

# API configuration (if hardcoded)
lib/constants/api_config.dart
```

---

## For Production Deployment

### Android APK
- Use environment variables or build-time secrets
- Don't hardcode API keys

### Google Play Store
- Use Firebase Remote Config for API key management
- Or use API key with IP/package restrictions

### iOS App Store
- Same security practices as Android
- Store secrets securely

---

## Need Help?

1. **OpenWeatherMap Support**: https://openweathermap.org/contact
2. **Flutter Documentation**: https://flutter.dev/docs
3. **Environment Variables Guide**: https://12factor.net/config

---

**Remember: Keep your API keys safe! 🔐**
