# Speezu App Setup Guide

## Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

## Setup Steps

### 1. Clone the Repository
```bash
git clone <repository-url>
cd speezu
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Create Environment File
Create a `.env` file in the project root with your Paystack API keys:

```env
# Paystack API Keys
# Get your keys from: https://dashboard.paystack.com/#/settings/developers

# Test Keys (for development)
PAYSTACK_TEST_PUBLIC_KEY=pk_test_your_test_public_key_here
PAYSTACK_TEST_SECRET_KEY=sk_test_your_test_secret_key_here

# Live Keys (for production)
PAYSTACK_LIVE_PUBLIC_KEY=pk_live_your_live_public_key_here
PAYSTACK_LIVE_SECRET_KEY=sk_live_your_live_secret_key_here

# Environment (set to 'production' for live keys, 'development' for test keys)
PAYSTACK_ENVIRONMENT=development
```

### 4. Get Paystack API Keys
1. Go to [Paystack Dashboard](https://dashboard.paystack.com/#/settings/developers)
2. Sign up/Login to your account
3. Navigate to Settings > Developers
4. Copy your Test Public Key and Test Secret Key
5. Replace the placeholder values in `.env` file

### 5. Run the App
```bash
# For development
flutter run

# For specific device
flutter run -d <device-id>

# For web
flutter run -d chrome
```

## Important Notes

### Security
- **Never commit the `.env` file** - it's already in `.gitignore`
- **Never share your API keys** - keep them private
- **Use test keys for development** - only use live keys in production

### Environment Variables
- The app will work with placeholder keys but payment functionality will fail
- You must add real Paystack keys to test payments
- Switch `PAYSTACK_ENVIRONMENT=production` when ready for live payments

### Troubleshooting

#### If you get "API keys not configured" error:
1. Check that `.env` file exists in project root
2. Verify the key names match exactly (case-sensitive)
3. Ensure no extra spaces or quotes around the values

#### If payments don't work:
1. Verify your Paystack keys are correct
2. Check that you're using test keys for development
3. Ensure your Paystack account is active

#### If the app crashes on startup:
1. Run `flutter clean && flutter pub get`
2. Check that all dependencies are installed
3. Verify Flutter version compatibility

## Project Structure
```
speezu/
├── .env                 # Environment variables (create this)
├── .gitignore          # Git ignore rules
├── pubspec.yaml        # Dependencies
├── lib/
│   ├── main.dart       # App entry point
│   ├── core/
│   │   └── config/
│   │       └── paystack_config.dart  # Paystack configuration
│   └── ...
└── README.md
```

## Support
If you encounter any issues:
1. Check this setup guide
2. Verify all prerequisites are installed
3. Check Flutter/Dart version compatibility
4. Contact the development team

---
**Happy Coding! 🚀**
