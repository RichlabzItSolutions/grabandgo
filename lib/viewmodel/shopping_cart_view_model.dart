import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';
import 'package:hygi_health/data/model/removecartItemrequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/CartResponse.dart';
import '../data/model/minamountresponse.dart'; // Import the CartResponse model

class ShoppingCartViewModel extends ChangeNotifier {
  // Instance of ApiService
  List<CartItem> _items = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Dynamic values for cart
  double deliveryCharges = 0.0;
  double discount = 0.0;
  double gstRate = 0.0; // GST rate (can be dynamically fetched)
  double finalAmount = 0.0;
  double minAmount =0;

  // Get the list of cart items
  List<CartItem> get items => _items;

  // Calculate total number of items
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  // Calculate the subtotal (sum of the totalAmount of all items)
  double get subTotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalAmount);


  // Fetch cart items and dynamic values like GST, deliveryCharges, and discount
  Future<void> fetchCartItems() async {
    try {
      _isLoading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId'); // Get userId as String

      if (userIdString == null) {
        // Handle the case when userId is not found, show a message or redirect to login
        throw Exception('User not logged in');
      }

      int? userId =
          int.tryParse(userIdString); // Safely parse the userId as an integer
      if (userId == null) {
        // Handle parsing error (e.g., corrupted value in SharedPreferences)
        throw Exception('Invalid userId format in SharedPreferences');
      }

      // Fetch cart items from API
      final cartResponse = await authService.fetchCartItems(userId);

      if (cartResponse.success) {
        // If the API returns success, update _items with the data
        _items = cartResponse.data.cartItems;

        // Dynamically update delivery charges, discount, gstRate, and finalAmount based on the response
        deliveryCharges = cartResponse.data.totalDeliveryCharges;
        discount = cartResponse.data.discount;
        gstRate = cartResponse.data.gst; // Assuming the response includes gstRate
        finalAmount = cartResponse.data.finalAmount; // Assuming the response includes finalAmount
      } else {
        // Handle failure case (e.g., display a message)
        _items = [];
        deliveryCharges = 0.0;
        discount = 0.0;
        gstRate = 0.0; // Default GST rate
        finalAmount = 0.0; // Default final amount
      }
    } catch (e) {
      // Handle error during the fetch
      print('Error fetching cart data: $e');
      _items = [];
      deliveryCharges = 0.0;
      discount = 0.0;
      gstRate = 0.0; // Default GST rate
      finalAmount = 0.0; // Default final amount
    }

    _isLoading = false; // Set loading to false after data fetch
    notifyListeners(); // Notify listeners to update UI
  }

  // Increment item quantity
  Future<void> incrementQuantity(int index) async {
    try {
      _items[index].quantity++;
      //_items[index].totalAmount = _items[index].unitPrice * _items[index].quantity;

      // Call the API to update the cart on the server
      await _updateCartItem(index);

      // Fetch updated cart items
      await fetchCartItems();
      notifyListeners(); // Notify UI about the change
    } catch (e) {
      print('Error incrementing quantity: $e');
    }
  }

  // Decrement item quantity
  Future<void> decrementQuantity(int index) async {
    try {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        //_items[index].totalAmount = _items[index].unitPrice * _items[index].quantity;

        // Call the API to update the cart on the server
        await _updateCartItem(index);
        // Fetch updated cart items
        await fetchCartItems();
        notifyListeners(); // Notify UI about the change
      }
    } catch (e) {
      print('Error decrementing quantity: $e');
    }
  }

  // Remove item from cart
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners(); // Notify UI about the change
  }

  // New removeCartItem method to remove the item from the server
  Future<void> removeCartItem(int index) async {
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

      final cartItem = _items[index];
      final RemoveCartItemRequest removeCartItemRequest = RemoveCartItemRequest(
        userId: userId,
        productId: cartItem.productId.toString(),
        variantId: cartItem.variantId.toString(),
      );

      // Call API to remove the item from the cart
      final response = await authService.removeFromCart(removeCartItemRequest);
      // If the item is removed successfully from the server, remove it locally
      _items.removeAt(index);
      fetchCartItems();
      notifyListeners();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  // Get userId from SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Fetch userId as an integer
  }

  // Method to update the cart item on the server (Add to cart API)
  Future<void> _updateCartItem(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId');
      if (userIdString == null) {
        throw Exception('User not logged in');
      }

      int userId = int.tryParse(userIdString) ?? 0;
      if (userId == 0) {
        throw Exception('Invalid user ID');
      }

      final cartItem = _items[index];
      String qty = cartItem.quantity.toString();

      // Call the API to update the cart item (add/update)
      final response = await authService.addToCart(
        userId: userIdString, // Pass userId as string
        productId: cartItem.productId,
        variantId: cartItem.variantId,
        qty: qty,
      );

      // Optionally handle the response (e.g., show success message)
    } catch (e) {
      print('Error updating cart item: $e');
      // Optionally, handle any errors that occur during the API call
    }
  }
  Future<void> updateQuantity(int index, int newQuantity) async {
    final item = items[index];
    item.quantity = newQuantity;

    await _updateCartItem(index);

    // Fetch updated cart items
    await fetchCartItems();
    notifyListeners();
  }


  // Fetch min amount from API

  Future<void> fetchMinAmount() async {
    _isLoading = true;
    notifyListeners();

    try {
      final MinAmountResponse response = await authService.getMinAmount();

      // Log the response to check if minAmount is present
      print('API Response: ${response.data.minAmount}');

      // Check if minAmount exists and is not null
      if (response.data.minAmount != null) {
        minAmount = response.data.minAmount.minAmount ;
      } else {
        print('minAmount is null');
        minAmount = 0; // Set to a default value if not provided by the API
      }

    } catch (e) {
      print('Error fetching minAmount: $e');
      minAmount = 0; // Set to 0 in case of an error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }





}
