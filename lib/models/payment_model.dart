import '../core/config/paystack_config.dart' as config;

class PaymentResult {
  final bool success;
  final String? transactionReference;
  final String? message;
  final String? errorCode;
  final Map<String, dynamic>? metadata;

  PaymentResult({
    required this.success,
    this.transactionReference,
    this.message,
    this.errorCode,
    this.metadata,
  });

  factory PaymentResult.success({
    required String transactionReference,
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentResult(
      success: true,
      transactionReference: transactionReference,
      message: message ?? 'Payment successful',
      metadata: metadata,
    );
  }

  factory PaymentResult.failure({
    required String errorCode,
    required String message,
  }) {
    return PaymentResult(
      success: false,
      errorCode: errorCode,
      message: message,
    );
  }

  @override
  String toString() {
    return 'PaymentResult(success: $success, transactionReference: $transactionReference, message: $message, errorCode: $errorCode)';
  }
}

class SavedCardInfo {
  final String cardNumber;
  final String cardHolderName;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String cardType;

  SavedCardInfo({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardType,
  });

  factory SavedCardInfo.fromCardDetailsModel(dynamic cardModel) {
    return SavedCardInfo(
      cardNumber: cardModel.cardNumber ?? '',
      cardHolderName: cardModel.cardHolderName ?? '',
      expiryMonth: cardModel.expiryMonth ?? '',
      expiryYear: cardModel.expiryYear ?? '',
      cvv: cardModel.cvv ?? '',
      cardType: cardModel.cardType ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'cvv': cvv,
      'card_type': cardType,
    };
  }
}

class PaymentRequest {
  final String email;
  final double amount;
  final String currency;
  final String? reference;
  final Map<String, dynamic>? metadata;
  final String? callbackUrl;
  final SavedCardInfo? savedCard;

  PaymentRequest({
    required this.email,
    required this.amount,
    this.currency = 'NGN',
    this.reference,
    this.metadata,
    this.callbackUrl,
    this.savedCard,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'amount': (amount * 100).toInt(), // Convert to kobo
      'currency': currency,
      'reference': reference,
      'metadata': metadata,
      'callback_url': callbackUrl,
      'saved_card': savedCard?.toJson(),
    };
  }

  @override
  String toString() {
    return 'PaymentRequest(email: $email, amount: $amount, currency: $currency, reference: $reference)';
  }
}

class PaystackConfig {
  final String publicKey;
  final String secretKey;
  final String? baseUrl;

  PaystackConfig({
    required this.publicKey,
    required this.secretKey,
    this.baseUrl,
  });

  // Default configuration using the centralized config
  static PaystackConfig get defaultConfig => PaystackConfig(
    publicKey: config.PaystackConfig.publicKey,
    secretKey: config.PaystackConfig.secretKey,
    baseUrl: config.PaystackConfig.baseUrl,
  );
}

