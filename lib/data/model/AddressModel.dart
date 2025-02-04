class AddressModel {
  int? userId;            // User ID
  int? addressTypeId;     // Address type ID (1: Home, 2: Office, 3: Other)
  String? firstName;      // First name of the resident
  String? lastName;       // Last name of the resident
  String? mobile;         // Mobile number
  bool isDefault;         // Indicates if this is the default address (0 or 1)
  String? address;        // Street address
  String? city;           // City
  int? stateId;           // State ID
  String? pincode;        // Pincode or postal code
  String? area;           // Area or locality
  String? landmark;       // Landmark for the address
  String? latitude;       // Latitude (can be left empty if not available)
  String? longitude;      // Longitude (can be left empty if not available)
  String? apartmentNumber; // Apartment or house number
  String? apartmentName;   // Apartment name or building name
  String? stateName;       // State name (if available)
  String? addressType;     // Address type (if available)

  AddressModel({
    this.userId,
    this.addressTypeId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.isDefault = false,
    this.address,
    this.city,
    this.stateId,
    this.pincode,
    this.area,
    this.landmark,
    this.latitude,
    this.longitude,
    this.apartmentNumber,
    this.apartmentName,
    this.stateName,    // Added to constructor
    this.addressType,  // Added to constructor
  });

  // Method to convert JSON data to AddressModel
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final nameParts = json['name']?.split(' ') ?? [];
    return AddressModel(
      userId: json['userId'],
      addressTypeId: json['addressTypeId'],
      firstName: nameParts.isNotEmpty ? nameParts[0] : '', // First name from 'name'
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '', // Last name
      mobile: json['mobile'],
      isDefault: json['defaultAddress'] == 1,  // Assuming 0 or 1 for boolean
      address: json['address'],
      city: json['city'],
      stateId: json['stateId'],
      pincode: json['pincode'],
      area: json['area'],
      landmark: json['landmark'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      apartmentNumber: json['apartmentNumber'],  // Apartment number
      apartmentName: json['apartmentName'],      // Apartment name
      stateName: json['stateName'],              // State name (nullable)
      addressType: json['addressType'],          // Address type (nullable)
    );
  }

  // Method to convert AddressModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'addressTypeId': addressTypeId,
      'name': '$firstName $lastName',  // Combine firstName and lastName into name
      'mobile': mobile,
      'defaultAddress': isDefault ? 1 : 0,  // Convert boolean to 1 or 0
      'address': address,
      'city': city,
      'stateId': stateId,
      'pincode': pincode,
      'area': area,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'apartmentNumber': apartmentNumber,  // Include apartment number
      'apartmentName': apartmentName,      // Include apartment name
      'stateName': stateName,              // Include stateName
      'addressType': addressType,          // Include addressType
    };
  }
}
