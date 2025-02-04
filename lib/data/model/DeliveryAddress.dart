class DeliveryAddress {
  int id;
  String firstName;
  String lastName;
  String mobile;
  int defaultAddress;
  String address;
  String city;
  String area;
  String? landmark;  // Nullable field
  int pincode;
  int? stateId;  // Nullable field for stateId
  String stateName;
  String addressType;
  int addressTypeId;
  String createdOn;

  DeliveryAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.defaultAddress,
    required this.address,
    required this.city,
    required this.area,
    this.landmark,  // Nullable field
    required this.pincode,
    this.stateId,  // Nullable stateId
    required this.stateName,
    required this.addressType,
    required this.addressTypeId,
    required this.createdOn,
  });

  // Factory constructor to create a DeliveryAddress object from JSON
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'] ?? 0,  // Default to 0 if null
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      mobile: json['mobile'] ?? '',
      defaultAddress: json['defaultAddress'] ?? 0,  // Default to 0 if null
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      landmark: json['landmark'],  // Nullable field, can be null
      pincode: json['pincode'] ?? 0,  // Default to 0 if null
      stateId: json['stateId'],  // Nullable stateId
      stateName: json['stateName'] ?? '',
      addressType: json['addressType'] ?? '',
      addressTypeId: json['addressTypeId'] ?? 0,
      createdOn: json['createdOn'] ?? '',
    );
  }

  // Helper method to get the full name (first + last name)
  String get name => '$firstName $lastName';

  // Getter for landmark to provide a default message if null
  String get landmarkOrDefault => landmark ?? 'No landmark provided';
}
