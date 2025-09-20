class CardDetailsModel {
  String? id;
  String? cardNumber;
  String? cardHolderName;
  String? expiryMonth;
  String? expiryYear;
  String? cvv;
  String? cardType; // visa, mastercard, etc.
  bool? isDefault;

  CardDetailsModel({
    this.id,
    this.cardNumber,
    this.cardHolderName,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
    this.cardType,
    this.isDefault = false,
  });

  CardDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardNumber = json['card_number'];
    cardHolderName = json['card_holder_name'];
    expiryMonth = json['expiry_month'];
    expiryYear = json['expiry_year'];
    cvv = json['cvv'];
    cardType = json['card_type'];
    isDefault = json['is_default'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['card_number'] = cardNumber;
    data['card_holder_name'] = cardHolderName;
    data['expiry_month'] = expiryMonth;
    data['expiry_year'] = expiryYear;
    data['cvv'] = cvv;
    data['card_type'] = cardType;
    data['is_default'] = isDefault;
    return data;
  }

  // Generate unique ID if not provided
  String generateId() {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
    return id!;
  }

  // Get masked card number for display
  String getMaskedCardNumber() {
    if (cardNumber == null || cardNumber!.length < 4) return '****';
    return '**** **** **** ${cardNumber!.substring(cardNumber!.length - 4)}';
  }

  // Get formatted expiry date
  String getFormattedExpiry() {
    if (expiryMonth == null || expiryYear == null) return '';
    return '$expiryMonth/$expiryYear';
  }
}
