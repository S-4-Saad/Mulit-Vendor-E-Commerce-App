import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/payment_model.dart';
import '../models/card_details_model.dart';

class PaystackService {
  static final PaystackService _instance = PaystackService._internal();
  factory PaystackService() => _instance;
  PaystackService._internal();

  late Paystack _paystack;
  late Dio _dio;
  PaystackConfig _config = PaystackConfig.defaultConfig;

  // Initialize the service with configuration
  Future<void> initialize(PaystackConfig config) async {
    try {
      _config = config;
      _paystack = Paystack();
      
      // Initialize Paystack with proper error handling
      await _paystack.initialize(config.publicKey, false); // Set to false for better compatibility
      
      _dio = Dio(BaseOptions(
        baseUrl: config.baseUrl ?? 'https://api.paystack.co',
        headers: {
          'Authorization': 'Bearer ${config.secretKey}',
          'Content-Type': 'application/json',
        },
      ));
      
      print('Paystack initialized successfully with public key: ${config.publicKey}');
    } catch (e) {
      print('Paystack initialization failed: $e');
      rethrow; // Re-throw to let the caller handle the error
    }
  }

  // Generate a unique reference for the transaction
  String generateReference() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return 'SPZ_${DateTime.now().millisecondsSinceEpoch}_${String.fromCharCodes(Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length))))}';
  }

  // Initialize payment with Paystack
  Future<PaymentResult> initializePayment(PaymentRequest request) async {
    try {
      // Generate reference if not provided
      final reference = request.reference ?? generateReference();
      
      // Prepare metadata including saved card info
      final metadata = Map<String, dynamic>.from(request.metadata ?? {});
      if (request.savedCard != null) {
        // Convert saved card to JSON string instead of object
        metadata['saved_card'] = jsonEncode(request.savedCard!.toJson());
        metadata['has_saved_card'] = true;
        metadata['card_type'] = request.savedCard!.cardType;
        metadata['card_last_four'] = request.savedCard!.cardNumber.length >= 4 
            ? request.savedCard!.cardNumber.substring(request.savedCard!.cardNumber.length - 4)
            : '';
      }
      
      final paymentRequest = PaymentRequest(
        email: request.email,
        amount: request.amount,
        currency: request.currency,
        reference: reference,
        metadata: metadata,
        callbackUrl: request.callbackUrl,
      );

      // Make API call to initialize payment
      print('Making API call to initialize payment...');
      print('Request Data: ${paymentRequest.toJson()}');
      
      final response = await _dio.post(
        '/transaction/initialize',
        data: paymentRequest.toJson(),
      );

      print('Initialization API Response Status: ${response.statusCode}');
      print('Initialization API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final authorizationUrl = data['data']['authorization_url'];
          final accessCode = data['data']['access_code'];
          
          print('✅ Payment initialization API success');
          print('Authorization URL: $authorizationUrl');
          print('Access Code: $accessCode');

          return PaymentResult.success(
            transactionReference: reference,
            message: 'Payment initialized successfully',
            metadata: {
              'authorization_url': authorizationUrl,
              'access_code': accessCode,
            },
          );
        } else {
          print('❌ Payment initialization API returned false: ${data['message']}');
          return PaymentResult.failure(
            errorCode: 'INITIALIZATION_FAILED',
            message: data['message'] ?? 'Failed to initialize payment',
          );
        }
      } else {
        print('❌ Payment initialization HTTP Error: ${response.statusCode} - ${response.statusMessage}');
        return PaymentResult.failure(
          errorCode: 'HTTP_ERROR',
          message: 'HTTP ${response.statusCode}: ${response.statusMessage}',
        );
      }
    } catch (e) {
      return PaymentResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Verify payment status
  Future<PaymentResult> verifyPayment(String reference) async {
    try {
      print('=== PAYMENT VERIFICATION ===');
      print('Verifying payment with reference: $reference');
      
      final response = await _dio.get('/transaction/verify/$reference');
      
      print('Verification Response Status: ${response.statusCode}');
      print('Verification Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final transactionData = data['data'];
          final status = transactionData['status'];
          
          print('Transaction Status: $status');
          print('Transaction Data: $transactionData');
          
          if (status == 'success') {
            print('✅ Payment verification successful!');
            return PaymentResult.success(
              transactionReference: reference,
              message: 'Payment verified successfully',
              metadata: transactionData,
            );
          } else {
            print('❌ Payment verification failed. Status: $status');
            return PaymentResult.failure(
              errorCode: 'PAYMENT_FAILED',
              message: 'Payment was not successful. Status: $status',
            );
          }
        } else {
          print('❌ Verification API returned false. Message: ${data['message']}');
          return PaymentResult.failure(
            errorCode: 'VERIFICATION_FAILED',
            message: data['message'] ?? 'Failed to verify payment',
          );
        }
      } else {
        print('❌ Verification HTTP Error: ${response.statusCode} - ${response.statusMessage}');
        return PaymentResult.failure(
          errorCode: 'HTTP_ERROR',
          message: 'HTTP ${response.statusCode}: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('❌ Verification Exception: $e');
      return PaymentResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Process payment using Paystack Flutter SDK
  Future<PaymentResult> processPayment({
    required String email,
    required double amount,
    required String currency,
    String? reference,
    Map<String, dynamic>? metadata,
    CardDetailsModel? savedCard,
    BuildContext? context,
  }) async {
    try {
      // Check if Paystack is initialized
      if (!isInitialized) {
        return PaymentResult.failure(
          errorCode: 'NOT_INITIALIZED',
          message: 'Paystack service is not initialized. Please try again.',
        );
      }

      // Validate context if provided
      if (context != null && !context.mounted) {
        return PaymentResult.failure(
          errorCode: 'INVALID_CONTEXT',
          message: 'Context is not mounted. Cannot proceed with payment.',
        );
      }

      // Generate reference if not provided
      final paymentReference = reference ?? generateReference();
      
      print('=== PAYMENT INITIALIZATION ===');
      print('Email: $email');
      print('Amount: $amount $currency');
      print('Reference: $paymentReference');
      print('Saved Card: ${savedCard != null ? "Yes (${savedCard.getMaskedCardNumber()})" : "No"}');
      print('Metadata: $metadata');
      
      // Initialize payment
      final initResult = await initializePayment(PaymentRequest(
        email: email,
        amount: amount,
        currency: currency,
        reference: paymentReference,
        metadata: metadata,
        savedCard: savedCard != null ? SavedCardInfo.fromCardDetailsModel(savedCard) : null,
      ));

      print('Initialization Result: $initResult');
      
      if (!initResult.success) {
        print('❌ Payment initialization failed');
        return initResult;
      }
      
      print('✅ Payment initialization successful');

      // Get access code from the initialization result
      final accessCode = initResult.metadata?['access_code'] as String?;
      if (accessCode == null) {
        return PaymentResult.failure(
          errorCode: 'MISSING_ACCESS_CODE',
          message: 'Access code not found in initialization response',
        );
      }

      // Check if context is still mounted before launching payment UI
      if (context != null && !context.mounted) {
        return PaymentResult.failure(
          errorCode: 'CONTEXT_DISPOSED',
          message: 'Context was disposed before launching payment UI.',
        );
      }

      // Try native SDK first, with fallback to web-based approach
      try {
        final result = await _paystack.launch(accessCode);
        return _handlePaymentResult(result, paymentReference);
      } catch (e) {
        print('Native SDK failed: $e');
        // Fallback to web-based payment using the stored authorization URL
        final authorizationUrl = initResult.metadata?['authorization_url'] as String?;
        if (authorizationUrl != null) {
          return await _processWebPayment(authorizationUrl, paymentReference);
        } else {
          return PaymentResult.failure(
            errorCode: 'NO_AUTHORIZATION_URL',
            message: 'Payment authorization URL not found. Please try again.',
          );
        }
      }
    } catch (e) {
      return PaymentResult.failure(
        errorCode: 'PAYMENT_ERROR',
        message: 'Payment processing error: ${e.toString()}',
      );
    }
  }

  // Get payment methods available
  List<String> getAvailablePaymentMethods() {
    return [
      'card',
    ];
  }

  // Check if service is initialized
  bool get isInitialized => _config.publicKey.isNotEmpty && _config.secretKey.isNotEmpty;

  // Handle payment result from Paystack SDK
  Future<PaymentResult> _handlePaymentResult(dynamic result, String paymentReference) async {
    print('=== PAYSTACK PAYMENT RESULT ===');
    print('Payment Reference: $paymentReference');
    print('Result Status: ${result.status}');
    print('Result Data: $result');
    print('===============================');
    
    if (result.status == 'success') {
      print('Payment successful, verifying...');
      // Verify the payment
      final verifyResult = await verifyPayment(paymentReference);
      print('Verification Result: $verifyResult');
      return verifyResult;
    } else if (result.status == 'cancelled') {
      print('Payment was cancelled by user');
      return PaymentResult.failure(
        errorCode: 'PAYMENT_CANCELLED',
        message: 'Payment was cancelled by user',
      );
    } else {
      print('Payment failed: ${result.message}');
      return PaymentResult.failure(
        errorCode: 'PAYMENT_FAILED',
        message: result.message,
      );
    }
  }

  // Process payment using web-based flow to avoid MISSING_VIEW issues
  Future<PaymentResult> _processWebPayment(String authorizationUrl, String paymentReference) async {
    try {
      // Launch the payment URL in external browser
      final uri = Uri.parse(authorizationUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        
        // Return a pending status - the actual verification will happen via webhook or manual verification
        return PaymentResult.success(
          transactionReference: paymentReference,
          message: 'Payment page opened. Please complete payment in your browser.',
          metadata: {
            'authorization_url': authorizationUrl,
            'status': 'pending',
          },
        );
      } else {
        return PaymentResult.failure(
          errorCode: 'CANNOT_LAUNCH_URL',
          message: 'Cannot open payment page. Please try again.',
        );
      }
    } catch (e) {
      return PaymentResult.failure(
        errorCode: 'WEB_PAYMENT_ERROR',
        message: 'Web payment processing error: ${e.toString()}',
      );
    }
  }
}
