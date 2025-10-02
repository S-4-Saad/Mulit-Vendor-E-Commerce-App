
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaystackConfig {
  // Paystack API Keys - Loaded from environment variables
  // Create a .env file in the project root with your actual keys
  // See .env.example for the required format
  
  // Test Keys (for development)
  static String get testPublicKey => dotenv.env['PAYSTACK_TEST_PUBLIC_KEY'] ?? 'pk_test_your_test_public_key_here';
  static String get testSecretKey => dotenv.env['PAYSTACK_TEST_SECRET_KEY'] ?? 'sk_test_your_test_secret_key_here';
  
  // Live Keys (for production)
  static String get livePublicKey => dotenv.env['PAYSTACK_LIVE_PUBLIC_KEY'] ?? 'pk_live_your_live_public_key_here';
  static String get liveSecretKey => dotenv.env['PAYSTACK_LIVE_SECRET_KEY'] ?? 'sk_live_your_live_secret_key_here';
  
  // Environment configuration - Loaded from environment variable
  static bool get isProduction => dotenv.env['PAYSTACK_ENVIRONMENT'] == 'production';
  
  // Get current configuration based on environment
  static String get publicKey => isProduction ? livePublicKey : testPublicKey;
  static String get secretKey => isProduction ? liveSecretKey : testSecretKey;
  
  // Paystack API Base URL
  static const String baseUrl = 'https://api.paystack.co';
  
  // Currency configuration
  static const String defaultCurrency = 'NGN';
  
  // Payment callback URL (optional)
  static const String? callbackUrl = null; // Set your callback URL if needed
  
  // Transaction timeout (in seconds)
  static const int transactionTimeout = 300; // 5 minutes
  
  // Retry configuration
  static const int maxRetries = 3;
  static const int retryDelaySeconds = 2;
  
  // Validation
  static bool get isConfigured {
    if (isProduction) {
      return livePublicKey.isNotEmpty && 
             liveSecretKey.isNotEmpty && 
             !livePublicKey.contains('your_live') &&
             !liveSecretKey.contains('your_live');
    } else {
      return testPublicKey.isNotEmpty && 
             testSecretKey.isNotEmpty && 
             !testPublicKey.contains('your_test') &&
             !testSecretKey.contains('your_test');
    }
  }
  
  // Get configuration status message
  static String get configurationStatus {
    if (!isConfigured) {
      return isProduction 
          ? 'Live Paystack keys not configured. Please create a .env file with PAYSTACK_LIVE_PUBLIC_KEY and PAYSTACK_LIVE_SECRET_KEY'
          : 'Test Paystack keys not configured. Please create a .env file with PAYSTACK_TEST_PUBLIC_KEY and PAYSTACK_TEST_SECRET_KEY';
    }
    return isProduction ? 'Live Paystack configuration ready' : 'Test Paystack configuration ready';
  }
}
