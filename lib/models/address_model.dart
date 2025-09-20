class AddressModel {
  String? id;
  String? title;
  String? customerName;
  String? primaryPhoneNumber;
  String? secondaryPhoneNumber;
  String? address;
  bool? isDefault;

  AddressModel({
    this.id,
    this.title,
    this.customerName,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.address,
    this.isDefault = false,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    customerName = json['customer_name'];
    primaryPhoneNumber = json['primary_phone_number'];
    secondaryPhoneNumber = json['secondary_phone_number'];
    address = json['address'];
    isDefault = json['is_default'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['customer_name'] = customerName;
    data['primary_phone_number'] = primaryPhoneNumber;
    data['secondary_phone_number'] = secondaryPhoneNumber;
    data['address'] = address;
    data['is_default'] = isDefault;
    return data;
  }

  // Generate unique ID if not provided
  String generateId() {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
    return id!;
  }
}
