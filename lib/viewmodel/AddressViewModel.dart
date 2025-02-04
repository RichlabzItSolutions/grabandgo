import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/DeliveryAddress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Utils/app_colors.dart';
import '../common/globally.dart';
import '../data/model/AddressModel.dart';
import '../routs/Approuts.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressModel _address = AddressModel();
  bool _isInitialized = false;
  List<Map<String, dynamic>> availableStates = [];
  String selectedState = "";
  int selectedStateId = 0;

  //Getter for _isInitialized
  bool get isInitialized => _isInitialized;
  bool isDefault = false;

  AddressModel get address => _address;

  List<Map<String, dynamic>> _addressTypes = [];

  List<Map<String, dynamic>> get addressTypes => _addressTypes;

  String _selectedAddressType = '';

  String get selectedAddressType => _selectedAddressType;

  // Fetch Address Types from API
  Future<void> loadAddressTypes() async {
    try {
      _addressTypes = await authService.fetchAddressTypes();
      notifyListeners();
    } catch (error) {
      print("Error fetching address types: $error");
    }
  }

  // Initialize with existing or default empty address
  void initializeWithAddress(DeliveryAddress? address) {
    if (_isInitialized) return; // Don't initialize again if already initialized
    if (address != null) {
      _address.firstName = address.firstName;
      _address.lastName = address.lastName;
      _address.mobile = address.mobile;
      _address.address = address.address;
      _address.city = address.city;
      _address.area = address.area;
      _address.landmark = address.landmark ?? '';
      _address.pincode = address.pincode.toString();
      _address.stateName = address.stateName;
      _address.addressType = address.addressType; // Set the address type
      _address.isDefault = address.defaultAddress == 1;
      selectedStateId = address.stateId ?? 0;
      selectedState = address.stateName;
      _selectedAddressType =
          address.addressType; // Set the selected address type dynamically
    } else {
      _address.firstName = '';
      _address.lastName = '';
      _address.mobile = '';
      _address.address = '';
      _address.city = '';
      _address.area = '';
      _address.landmark = '';
      _address.pincode = '';
      _address.stateName = '';
      _address.addressType = '';
      _address.isDefault = false;
      selectedStateId = 0;
      selectedState = '';
      _selectedAddressType =
          ''; // Clear the selected address type if no address
    }
    _isInitialized = true; // Mark as initialized
    notifyListeners();
  }

  // Fetch states from the API
  Future<void> loadStates() async {
    try {
      final response =
          await authService.fetchStates(); // API call to fetch states
      print(
          "API Response: ${response.data}"); // Debug print to verify API response
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data') &&
              data['data'] is Map<String, dynamic>) {
            final nestedData = data['data'];
            if (nestedData.containsKey('States') &&
                nestedData['States'] is List) {
              availableStates = List<Map<String, dynamic>>.from(
                nestedData['States'].map((x) => {
                      'stateId': x['id'],
                      'stateName': x['stateName'],
                    }),
              );
              notifyListeners(); // Notify listeners after updating availableStates
              print(
                  "States loaded: $availableStates"); // Debug print to verify states
            } else {
              print(
                  "States key not found or is not a valid List. Nested keys: ${nestedData.keys}");
            }
          } else {
            print(
                "Data key not found or is not a valid Map. Available keys: ${data.keys}");
          }
        } else {
          print(
              "Invalid API response. Expected a Map<String, dynamic>, but got: ${data.runtimeType}");
        }
      }
    } catch (e) {
      print("Error loading states: $e");
    }
  }

  // Update selected state and stateId
  void updateSelectedState(String stateName, int stateId) {
    selectedState = stateName;
    selectedStateId = stateId;
    _address.stateId = stateId; // Bind the selected state to the address model
    notifyListeners();
  }

  // Update dynamic fields
  void updatePincode(String value) {
    _address.pincode = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateAddressType(String type, int typeID) {
    _address.addressType = type;
    _selectedAddressType = type;
    _address.addressTypeId =
        typeID; // Set the address type to the selected type
    notifyListeners(); // Notify listeners to update UI
  }

  void toggleDefaultAddress(bool value) {
    _address.isDefault = value;
    notifyListeners();
  }

  void updateApartmentNumber(String value) {
    _address.address = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateStreetDetails(String value) {
    _address.apartmentName = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateLandmark(String value) {
    _address.landmark = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateFirstName(String value) {
    _address.firstName = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateLastName(String value) {
    _address.lastName = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateMobileNumber(String value) {
    _address.mobile = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateCity(String value) {
    _address.city = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  void updateArea(String value) {
    _address.area = value.isNotEmpty ? value : '';
    notifyListeners();
  }

  // Save address to the server
  Future<void> saveAddress(BuildContext context) async {
    final fullAddress =
        '${_address.address ?? ''} ${_address.apartmentName ?? ''}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');
    int userId = int.tryParse(userIdString ?? '') ?? 0;

    final addressTypeId = _address.addressTypeId ?? 0;
    final city = _address.city ?? '';
    final area = _address.area ?? '';
    final landmark = _address.landmark ?? '';

    final success = await authService.saveAddress(
      userId: userId,
      addressTypeId: addressTypeId,
      name: "${_address.firstName ?? ''} ${_address.lastName ?? ''}",
      mobile: _address.mobile ?? "",
      defaultAddress: _address.isDefault,
      address: fullAddress,
      city: city,
      stateId: selectedStateId,
      pincode: _address.pincode ?? '',
      area: area,
      landmark: landmark,
      latitude: "",
      longitude: "",
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Address saved successfully!'),
            backgroundColor: AppColors.primaryColor),
      );
      Navigator.pushNamed(context, AppRoutes.DeliveryAddress);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Failed to save address'),
            backgroundColor: Colors.green),
      );
    }
  }

  // edit address to the server
  Future<void> editAddress(
      BuildContext context, DeliveryAddress deliveryAddress) async {
    final fullAddress =
        '${_address.address ?? ''} ${_address.apartmentName ?? ''}';
    final city = _address.city ?? '';
    final area = _address.area ?? '';
    final landmark = _address.landmark ?? '';
    final success = await authService.editAddress(
      addressId: deliveryAddress.id,
      addressTypeId: deliveryAddress.addressTypeId,
      name: "${_address.firstName ?? ''} ${_address.lastName ?? ''}",
      mobile: _address.mobile ?? "",
      defaultAddress: _address.isDefault,
      address: fullAddress,
      city: city,
      stateId: selectedStateId,
      pincode: _address.pincode ?? '',
      area: area,
      landmark: landmark,
      latitude: "",
      longitude: "",
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Address Updated successfully!'),
            backgroundColor: AppColors.primaryColor),
      );
      Navigator.pushNamed(context, AppRoutes.DeliveryAddress);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Failed to update'),
            backgroundColor: Colors.green),
      );
    }
  }
}
