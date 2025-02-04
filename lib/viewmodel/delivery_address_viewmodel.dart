import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/globally.dart';
import '../data/model/DeliveryAddress.dart';
import '../data/model/PaymentMethod.dart';
import '../data/model/confirm_order_response.dart';
import '../data/model/confirmorder.dart';
import '../routs/Approuts.dart';

class DeliveryViewModel extends ChangeNotifier {
  // List of delivery addresses
  List<DeliveryAddress> _deliveryAddresses = [];
  // Selected delivery address index
  int _selectedAddressIndex = 0;

  // Payment methods
  List<PaymentMethod> _paymentMethods = [
    PaymentMethod(type: "Cash", isSelected: true),
    // PaymentMethod(type: "Online Payment", isSelected: false),
  ];

  // Getters
  List<DeliveryAddress> get deliveryAddresses => _deliveryAddresses;
  int get selectedAddressIndex => _selectedAddressIndex;
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  // Load delivery addresses dynamically from API
  Future<void> loadDeliveryAddresses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId');
      int userId = int.tryParse(userIdString ?? '') ?? 0;

      if (userId != 0) {
        _deliveryAddresses = await authService.fetchAddressesByUserId(userId); // Fetch data from API by userId
        notifyListeners(); // Notify listeners when the data is fetched
      } else {
        print("User ID is not available.");
      }
    } catch (e) {
      print("Error loading delivery addresses: $e");
    }
  }

  // Select a payment method
  void selectPaymentMethod(int index) {
    for (int i = 0; i < _paymentMethods.length; i++) {
      _paymentMethods[i] = _paymentMethods[i].copyWith(isSelected: i == index);
    }
    notifyListeners();
  }

  // Select a delivery address
  void selectDeliveryAddress(int index) {
    _selectedAddressIndex = index;
    notifyListeners();
  }

  // Confirm order API call with selected addressId only
  Future<ConfirmOrderResponse> confirmOrder(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId');
      int? locationID = prefs.getInt('location'); // No need to parse here
      int userId = int.tryParse(userIdString ?? '') ?? 0;

      // Retrieve selected address
      final selectedAddress = _deliveryAddresses.isNotEmpty
          ? _deliveryAddresses[_selectedAddressIndex]
          : null;

      if (selectedAddress == null) {
        throw Exception("No delivery address selected.");
      }

      // Retrieve selected payment method
      final selectedPaymentMethod =
      _paymentMethods.firstWhere((method) => method.isSelected);

      // Map payment method to paymentMode (1 for Cash, 2 for Online Payment)
      final paymentMode = selectedPaymentMethod.type == "Cash" ? 1 : 2;

      // Create ConfirmOrder object with only addressId
      final order = ConfirmOrder(
        userId: userId,
        addressId: selectedAddress.id, // Only sending addressId now
        paymentMode: "1",
        locationId: locationID??0, // Sending locationId now

      );

      // Call the API
      final response = await authService.confirmOrder(order);

      // Check if the order was successfully confirmed
      if (response.success) {
        print("Order confirmed: ${response.data?.orderId}");
        // Navigate to SUCCESS page and pass the order details
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.SUCCESS, // Assuming this route is linked to OrderConfirmationPage
          arguments: {
            'orderId': response.data!.orderId,
            'orderRefNumber': response.data?.orderRefNumber ?? 'N/A',
            'totalAmount': response.data?.totalAmount ?? 0.0,
            'totalItems': response.data?.totalItems ?? 0,
          },
        );

      } else {
        print("Order confirmation failed: ${response.message}");
      }

      return response;
    } catch (e) {
      print("Error confirming order: $e");
      return ConfirmOrderResponse(
        success: false,
        message: "An error occurred: ${e.toString()}",
        data: null,
      );
    }
  }

}

extension PaymentMethodCopyWith on PaymentMethod {
  PaymentMethod copyWith({bool? isSelected}) {
    return PaymentMethod(
      type: this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
