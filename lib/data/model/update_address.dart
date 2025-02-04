class AddressResponse {
  final bool success;
  final String message;
  final List<UpdateAddress> addresses;

  AddressResponse({
    required this.success,
    required this.message,
    required this.addresses,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      addresses: (json['data']?['addresses'] as List? ?? [])
          .map((address) => UpdateAddress.fromJson(address))
          .toList(),
    );
  }
}

class UpdateAddress {
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final int defaultAddress;
  final String address;
  final String city;
  final String area;
  final String landmark;
  final int pincode;
  final String stateName;
  final String latitude;
  final String longitude;
  final String addressType;
  final String createdOn;

  UpdateAddress({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.defaultAddress,
    required this.address,
    required this.city,
    required this.area,
    required this.landmark,
    required this.pincode,
    required this.stateName,
    required this.latitude,
    required this.longitude,
    required this.addressType,
    required this.createdOn,
  });

  factory UpdateAddress.fromJson(Map<String, dynamic> json) {
    return UpdateAddress(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      mobile: json['mobile'] ?? '',
      defaultAddress: json['defaultAddress'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      landmark: json['landmark'] ?? '',
      pincode: json['pincode'] ?? 0,
      stateName: json['stateName'] ?? '',
      latitude: json['latitude']?.toString() ?? '', // Convert to string if not null
      longitude: json['longitude']?.toString() ?? '', // Convert to string if not null
      addressType: json['addressType'] ?? '',
      createdOn: json['createdOn'] ?? '',
    );
  }
}
