import 'package:flutter/cupertino.dart';
import 'package:hygi_health/common/globally.dart';

import '../data/model/order_summary_model.dart';

class OrderSummaryViewModel extends ChangeNotifier {
  // Initialize _orderSummary with a default empty object to avoid late initialization issues
  OrderSummary _orderSummary = OrderSummary(
    orderId: 0,
    addressId: 0,
    orderRefNumber: '',
    orderDate: '',
    totalAmount: '',
    gst: '',
    discount: '',
    finalAmount: 0.0,
    shippingCharges: '',
    payableAmount: 0.0,
    paymentStatus: 0,
    paymentMode: 0,
    ipAddress: '',
    orderStatus: 0,
    cartItems: [],
    addressDetails: AddressDetails(
      name: '',
      mobile: '',
      address: '',
      city: '',
      area: '',
      addressType: 'Home',
    ),
  ); // Default initialization with empty values or zeros

  OrderSummary get orderSummary => _orderSummary;

  Future<void> fetchOrderSummary(int userId, int orderId) async {
    try {
      final orderSummaryResponse = await authService.getOrderDetails(
        userId,
        orderId,
      );
      _loadOrderSummary(orderSummaryResponse);
    } catch (e) {
      print('Error fetching order details: $e');
      // Handle error properly here (e.g., show an error message)
    }
  }

  void _loadOrderSummary(OrderSummary orderSummary) {
    _orderSummary = orderSummary;
    notifyListeners();
  }
}
