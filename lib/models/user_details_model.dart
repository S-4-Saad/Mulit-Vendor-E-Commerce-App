import 'address_model.dart';
import 'card_details_model.dart';

class UserDetailsModel {
  List<AddressModel>? deliveryAddresses;
  CardDetailsModel? cardDetails; // Single card instead of list
  Map<String, dynamic>? customData; // For any additional dynamic data

  UserDetailsModel({
    this.deliveryAddresses,
    this.cardDetails,
    this.customData,
  });

  UserDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      deliveryAddresses = [];
      cardDetails = null;
      customData = {};
      return;
    }

    // Parse delivery addresses
    if (json['delivery_addresses'] != null) {
      deliveryAddresses = <AddressModel>[];
      json['delivery_addresses'].forEach((v) {
        deliveryAddresses!.add(AddressModel.fromJson(v));
      });
    } else {
      deliveryAddresses = [];
    }

    // Parse single card details
    if (json['card_details'] != null) {
      cardDetails = CardDetailsModel.fromJson(json['card_details']);
    } else {
      cardDetails = null;
    }

    // Parse custom data (excluding the main keys)
    customData = Map<String, dynamic>.from(json);
    customData!.remove('delivery_addresses');
    customData!.remove('card_details');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    // Add delivery addresses
    if (deliveryAddresses != null) {
      data['delivery_addresses'] = deliveryAddresses!.map((v) => v.toJson()).toList();
    } else {
      data['delivery_addresses'] = [];
    }

    // Add single card details
    if (cardDetails != null) {
      data['card_details'] = cardDetails!.toJson();
    } else {
      data['card_details'] = null;
    }

    // Add custom data
    if (customData != null) {
      data.addAll(customData!);
    }

    return data;
  }

  // Address management methods
  void addAddress(AddressModel address) {
    deliveryAddresses ??= [];
    address.generateId(); // Ensure address has an ID
    
    // If this is the first address, make it default
    if (deliveryAddresses!.isEmpty) {
      address.isDefault = true;
    }
    
    deliveryAddresses!.add(address);
  }

  void updateAddress(AddressModel updatedAddress) {
    if (deliveryAddresses == null) return;
    
    final index = deliveryAddresses!.indexWhere((addr) => addr.id == updatedAddress.id);
    if (index != -1) {
      deliveryAddresses![index] = updatedAddress;
    }
  }

  void removeAddress(String addressId) {
    deliveryAddresses?.removeWhere((addr) => addr.id == addressId);
  }

  void setDefaultAddress(String addressId) {
    if (deliveryAddresses == null) return;
    
    // Set all addresses to non-default first
    for (var address in deliveryAddresses!) {
      address.isDefault = false;
    }
    
    // Set the specified address as default
    final index = deliveryAddresses!.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      deliveryAddresses![index].isDefault = true;
    }
  }

  AddressModel? getDefaultAddress() {
    if (deliveryAddresses == null) return null;
    try {
      return deliveryAddresses!.firstWhere((addr) => addr.isDefault == true);
    } catch (e) {
      return deliveryAddresses!.isNotEmpty ? deliveryAddresses!.first : null;
    }
  }

  // Card management methods (single card)
  void setCard(CardDetailsModel card) {
    card.generateId(); // Ensure card has an ID
    card.isDefault = true; // Since there's only one card, it's always default
    cardDetails = card;
  }

  void updateCard(CardDetailsModel updatedCard) {
    updatedCard.generateId(); // Ensure card has an ID
    updatedCard.isDefault = true; // Since there's only one card, it's always default
    cardDetails = updatedCard;
  }

  void removeCard() {
    cardDetails = null;
  }

  CardDetailsModel? getCard() {
    return cardDetails;
  }

  // Custom data methods
  void setCustomData(String key, dynamic value) {
    customData ??= {};
    customData![key] = value;
  }

  dynamic getCustomData(String key) {
    return customData?[key];
  }

  void removeCustomData(String key) {
    customData?.remove(key);
  }

  // Method to ensure data persistence - merge with existing data
  void mergeWithExisting(UserDetailsModel? existingData) {
    if (existingData == null) return;
    
    // Merge delivery addresses - keep existing ones and add new ones
    final existingAddresses = existingData.deliveryAddresses ?? [];
    final newAddresses = deliveryAddresses ?? [];
    
    // Create a map of existing addresses by ID to avoid duplicates
    final existingAddressMap = <String, AddressModel>{};
    for (var address in existingAddresses) {
      if (address.id != null) {
        existingAddressMap[address.id!] = address;
      }
    }
    
    // Add new addresses that don't already exist
    for (var newAddress in newAddresses) {
      if (newAddress.id != null && !existingAddressMap.containsKey(newAddress.id!)) {
        existingAddresses.add(newAddress);
      }
    }
    
    deliveryAddresses = existingAddresses;
    
    // For single card - keep existing card if no new card is provided
    if (cardDetails == null && existingData.cardDetails != null) {
      cardDetails = existingData.cardDetails;
    }
    
    // Merge custom data
    final existingCustomData = existingData.customData ?? {};
    final newCustomData = customData ?? {};
    
    // Merge custom data, with new data taking precedence
    customData = {...existingCustomData, ...newCustomData};
  }
}
