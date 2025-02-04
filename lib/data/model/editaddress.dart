class EditAddress {
  int addressId;
  int addressTypeId;
  String name;
  String mobile;
  bool defaultAddress;
  String address;
  String city;
  int stateId;
  String pincode;
  String area;
  String landmark;
  String latitude;
  String longitude;

  EditAddress({
    required this.addressId,
    required this.addressTypeId,
    required this.name,
    required this.mobile,
    required this.defaultAddress,
    required this.address,
    required this.city,
    required this.stateId,
    required this.pincode,
    required this.area,
    required this.landmark,
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create Address object from JSON
  factory EditAddress.fromJson(Map<String, dynamic> json) {
    return EditAddress(
      addressId: json['addressId'],
      addressTypeId: json['addressTypeId'],
      name: json['name'],
      mobile: json['mobile'],
      defaultAddress: json['defaultAddress'] == 1,  // Assuming 1 means true, 0 means false
      address: json['address'],
      city: json['city'],
      stateId: int.parse(json['stateId']),
      pincode: json['pincode'],
      area: json['area'],
      landmark: json['landmark'] ?? '',  // Default empty if null
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  // Method to convert Address object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'addressTypeId': addressTypeId,
      'name': name,
      'mobile': mobile,
      'defaultAddress': defaultAddress ? 1 : 0,  // Assuming 1 means true, 0 means false
      'address': address,
      'city': city,
      'stateId': stateId.toString(),
      'pincode': pincode,
      'area': area,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
