import 'dart:convert';
import '../models/user_model.dart';

/// Test to verify UserModel can handle different user_details formats
class UserModelParsingTest {
  static void testUserDetailsParsing() {
    print('=== Testing UserModel user_details parsing ===');
    
    // Test 1: user_details as null
    print('\n1. Testing null user_details:');
    final json1 = {
      'id': 4,
      'name': 'Test User',
      'email': 'test@example.com',
      'phone_no': '1234567890',
      'user_details': null,
      'profile_picture': null,
    };
    final user1 = UserModel.fromJson({'success': true, 'user': json1});
    print('Result: ${user1.userData?.userDetails?.toJson()}');
    
    // Test 2: user_details as empty string
    print('\n2. Testing empty string user_details:');
    final json2 = {
      'id': 4,
      'name': 'Test User',
      'email': 'test@example.com',
      'phone_no': '1234567890',
      'user_details': '',
      'profile_picture': null,
    };
    final user2 = UserModel.fromJson({'success': true, 'user': json2});
    print('Result: ${user2.userData?.userDetails?.toJson()}');
    
    // Test 3: user_details as "null" string
    print('\n3. Testing "null" string user_details:');
    final json3 = {
      'id': 4,
      'name': 'Test User',
      'email': 'test@example.com',
      'phone_no': '1234567890',
      'user_details': 'null',
      'profile_picture': null,
    };
    final user3 = UserModel.fromJson({'success': true, 'user': json3});
    print('Result: ${user3.userData?.userDetails?.toJson()}');
    
    // Test 4: user_details as JSON string
    print('\n4. Testing JSON string user_details:');
    final userDetailsJson = {
      'delivery_addresses': [
        {
          'id': '123',
          'title': 'Home Address',
          'customer_name': 'Test User',
          'primary_phone_number': '1234567890',
          'secondary_phone_number': '',
          'address': '123 Test St',
          'is_default': true
        }
      ],
      'card_details': null
    };
    final json4 = {
      'id': 4,
      'name': 'Test User',
      'email': 'test@example.com',
      'phone_no': '1234567890',
      'user_details': jsonEncode(userDetailsJson),
      'profile_picture': null,
    };
    final user4 = UserModel.fromJson({'success': true, 'user': json4});
    print('Result: ${user4.userData?.userDetails?.toJson()}');
    
    // Test 5: user_details as Map (direct)
    print('\n5. Testing Map user_details:');
    final json5 = {
      'id': 4,
      'name': 'Test User',
      'email': 'test@example.com',
      'phone_no': '1234567890',
      'user_details': userDetailsJson,
      'profile_picture': null,
    };
    final user5 = UserModel.fromJson({'success': true, 'user': json5});
    print('Result: ${user5.userData?.userDetails?.toJson()}');
    
    print('\n=== All tests completed ===');
  }
}
