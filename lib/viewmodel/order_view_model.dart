import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Utils/app_colors.dart';
import '../data/model/order_model.dart'; // Replace with your actual Order model
import 'package:hygi_health/common/globally.dart'; // Assuming this is where authService is

class OrderViewModel extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  bool isLoading = false; // Track the loading state

  String _selectedTab = 'Active'; // Default Tab
  String get selectedTab => _selectedTab;

  // Map for status
  Map<String, String> orderStatusMap = {
    'Active': '1,2,3', // Active includes 1, 2, 3 statuses
    'Delivered': '4', // Delivered includes 4 status
    'Cancelled': '5', // Cancelled includes 5 status
  };

  // Constructor - Call fetchOrdersForTab() initially
  OrderViewModel() {
    fetchOrdersForTab(); // Fetch orders when the view model is initialized
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners(); // Notify listeners when tab is changed
    fetchOrdersForTab(); // Fetch orders based on the selected tab
  }

  // Filter orders based on the selected tab (e.g., 'Active', 'Delivered', 'Cancelled')
  List<Order> get filteredOrders {
    String status =
        orderStatusMap[_selectedTab] ?? '1'; // Default to '1' (Active) if null

    // If selected tab is Active, filter out 4 (Delivered) and 5 (Cancelled)
    if (_selectedTab == 'Active') {
      List<String> activeStatuses =
          status.split(','); // Split '1,2,3' into a list ['1', '2', '3']
      final filtered = _orders
          .where((order) =>
              activeStatuses.contains(order.orderStatus.toString()) &&
              order.orderStatus != 4 &&
              order.orderStatus != 5)
          .toList();
      return filtered;
    } else {
      final filtered = _orders
          .where((order) => order.orderStatus.toString() == status)
          .toList();
      return filtered;
    }
  }

  // Fetch orders from the API using the authService.fetchOrders method
  Future<void> fetchOrdersForTab() async {
    try {
      isLoading = true; // Set loading state to true
      notifyListeners(); // Notify listeners to trigger UI update (show loading indicator)

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString =
          prefs.getString('userId'); // Fetch userId as String

      if (userIdString != null) {
        // Convert userId to int
        int userId =
            int.tryParse(userIdString) ?? 0; // Default to 0 if parsing fails
        String status = orderStatusMap[_selectedTab] ??
            '1'; // Get the status for the selected tab

        List<Order> fetchedOrders = [];

        // Fetch orders based on the selected tab (Active, Delivered, Cancelled)
        if (_selectedTab == 'Active') {
          // Fetch orders for Active tab (statuses 1, 2, 3)
          fetchedOrders = await authService.fetchOrders(
              userId, "1"); // Pass the status as a comma-separated string
        } else {
          // For other tabs (Delivered, Cancelled), fetch orders based on their specific status
          fetchedOrders = await authService.fetchOrders(userId, status);
        }

        _orders = fetchedOrders;
      } else {
        _orders = [];
      }

      isLoading = false; // Set loading state to false after fetching
      notifyListeners(); // Notify listeners to trigger UI update (hide loading indicator)
    } catch (error) {
      print('Error fetching orders: $error');
      _orders = []; // Reset orders in case of error
      isLoading = false; // Set loading state to false on error
      notifyListeners(); // Ensure UI updates after error
      // You may want to show a user-friendly error message here
    }
  }

  Future<void> cancelOrder(
      BuildContext context, int orderId, String reason) async {
    try {
      isLoading = true;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString =
          prefs.getString('userId'); // Fetch userId as String

      if (userIdString != null) {
        // Convert userId to int
        int userId = int.tryParse(userIdString) ?? 0; // Default

        // Call the cancel API or service to cancel the order
        bool success = await authService.cancelOrder(userId, orderId, reason);

        if (success) {
          // After successfully canceling the order, update the order status
          _orders = _orders.map((order) {
            if (order.id == orderId) {
              order.orderStatus = 5;
            }
            return order;
          }).toList();
          // Optionally, you could remove the order from the list (if not needing to retain it in the canceled state)
          _orders.removeWhere((order) => order.id == orderId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Order Deleted successfully!'),
                backgroundColor: AppColors.primaryColor),
          );
          notifyListeners(); // Notify listeners after the update
        } else {
          // Handle the case where canceling failed (e.g., show an error message)
          print('Failed to cancel the order');
        }
      }
    } catch (error) {
      print('Error canceling order: $error');
    } finally {
      isLoading = false;
      notifyListeners(); // Make sure to hide the loading indicator
    }
  }
}
