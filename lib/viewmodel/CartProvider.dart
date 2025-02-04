import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart'; // Assuming this is where authService is defined
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _cartItemCount = 0;

  int get cartItemCount => _cartItemCount;

  // Method to fetch cart data from API
  Future<void> fetchCartData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId');
      if (userIdString == null) {
        throw Exception('User not logged in');
      }

      int? userId = int.tryParse(userIdString);
      if (userId == null) {
        throw Exception('Invalid userId format');
      }

      final response = await authService.getCartData(userId);

      if (response['success'] == true) {
        // Access 'data' and 'totalItems'
        var data = response['data'];
        if (data != null) {
          _cartItemCount = data['totalItems'] ?? 0;
        } else {
          _cartItemCount = 0;
        }
      } else {
        print('Error: ${response['message']}');
        _cartItemCount = 0;
      }

      notifyListeners();
    } catch (e) {
      print('Error: $e');
      _cartItemCount = 0; // Default to 0 in case of error
      notifyListeners();
    }
  }

}
