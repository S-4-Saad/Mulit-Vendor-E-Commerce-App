import '../models/user_model.dart';
import '../models/address_model.dart';
import '../models/card_details_model.dart';
import '../repositories/user_repository.dart';

/// Example demonstrating the updated API integration
class UserDetailsApiExample {
  static Future<void> demonstrateApiUsage() async {
    final userRepo = UserRepository();
    
    // Example 1: Adding multiple addresses
    print('=== Adding Multiple Addresses ===');
    
    final homeAddress = AddressModel(
      title: 'Home Address', // Selected from dropdown
      customerName: 'John Doe',
      primaryPhoneNumber: '+1234567890',
      secondaryPhoneNumber: '+0987654321',
      address: '123 Main Street, City, State, ZIP',
      isDefault: true,
    );
    
    final officeAddress = AddressModel(
      title: 'Office Address', // Selected from dropdown
      customerName: 'John Doe',
      primaryPhoneNumber: '+1234567890',
      address: '456 Business Ave, City, State, ZIP',
      isDefault: false,
    );
    
    // Add first address (will be default)
    await userRepo.addAddressAndSync(homeAddress);
    print('Home address added');
    
    // Add second address
    await userRepo.addAddressAndSync(officeAddress);
    print('Office address added');
    
    // Example 2: Setting single card
    print('\n=== Setting Single Card ===');
    final card = CardDetailsModel(
      cardNumber: '4111111111111111',
      cardHolderName: 'John Doe',
      expiryMonth: '12',
      expiryYear: '2025',
      cvv: '123',
      cardType: 'visa',
      isDefault: true,
    );
    
    await userRepo.setCardAndSync(card);
    print('Card set successfully');
    
    // Example 3: Viewing current data
    print('\n=== Current User Data ===');
    final addresses = userRepo.deliveryAddresses;
    final cardDetails = userRepo.cardDetails;
    final defaultAddress = userRepo.defaultAddress;
    
    print('Total addresses: ${addresses?.length ?? 0}');
    print('Card available: ${cardDetails != null}');
    print('Default address: ${defaultAddress?.title}');
    print('Card: ${cardDetails?.getMaskedCardNumber()}');
    
    // Example 4: Complete sync with server
    print('\n=== Complete Server Sync ===');
    final syncSuccess = await userRepo.updateUserDetailsWithCompleteData();
    print('Complete sync result: $syncSuccess');
  }
}

/// JSON structure sent to edit-profile API:
/// Note: title field comes from dropdown selection (Home Address or Office Address)
/// {
///   "user_id": 4,
///   "user_details": {
///     "delivery_addresses": [
///       {
///         "id": "1234567890",
///         "title": "Home Address", // Selected from dropdown: ['Home Address', 'Office Address']
///         "customer_name": "John Doe",
///         "primary_phone_number": "+1234567890",
///         "secondary_phone_number": "+0987654321",
///         "address": "123 Main Street, City, State, ZIP",
///         "is_default": true
///       },
///       {
///         "id": "1234567892",
///         "title": "Office Address", // Selected from dropdown: ['Home Address', 'Office Address']
///         "customer_name": "John Doe",
///         "primary_phone_number": "+1234567890",
///         "secondary_phone_number": "",
///         "address": "456 Business Ave, City, State, ZIP",
///         "is_default": false
///       }
///     ],
///     "card_details": {
///       "id": "1234567891",
///       "card_number": "4111111111111111",
///       "card_holder_name": "John Doe",
///       "expiry_month": "12",
///       "expiry_year": "2025",
///       "cvv": "123",
///       "card_type": "visa",
///       "is_default": true
///     }
///   }
/// }
