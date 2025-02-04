import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart'; // Ensure this contains the authService
import 'package:hygi_health/data/model/product_model.dart';
import 'package:hygi_health/data/model/product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import ApiService

class ProductViewModel extends ChangeNotifier {
  ProductView?
      product; // Nullable type to ensure that product is initialized after fetch
  bool isLoading = false; // Track loading state
  String? errorMessage; // Track any error message

  // Constructor
  ProductViewModel();

  // Method to fetch product details based on productId and variantId
  Future<void> fetchProductDetails(String productId, String variantId) async {
    try {
      isLoading = true; // Start loading when the API call begins
      errorMessage = null; // Reset previous error message
      // Fetch the product details using authService
      final fetchedProduct =
          await authService.fetchProduct(productId, variantId);

      if (fetchedProduct != null) {
        product =
            fetchedProduct; // Assign fetched product to the product variable
        notifyListeners(); // Notify listeners that loading has started
      } else {
        errorMessage =
            'Product not found'; // Handle case when product is not found
      }
    } catch (e) {
      // Handle errors (e.g., network issues)
      errorMessage = 'Error fetching product: $e';
    } finally {
      isLoading =
          false; // Stop loading after the data is fetched or an error occurs
      notifyListeners(); // Notify listeners that the state has changed
    }
  }

  // Add to cart logic
  Future<bool> addToCart(BuildContext context, int quantity) async {
    if (product == null) return false;

    isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User not logged in. Please log in first.')),
      );
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await authService.addToCart(
        productId: product!.productId,
        variantId: product!.variantId,
        qty: '$quantity',
        userId: userId,
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Added to cart successfully.')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add to cart: ${response['message']}')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
