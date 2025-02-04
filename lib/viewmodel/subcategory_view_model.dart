import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';

import '../data/model/product_model.dart';
import '../data/model/subcategory_model.dart';

class SubcategoryViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Subcategory> subcategories = [];
  List<Product> products = [];

  Future<void> fetchSubcategories(
      int categoryId, String searchSubCategory) async {
    isLoading = true;
    notifyListeners();

    try {
      // Call the API using authService to get the response
      final response = await authService.postCategorySubcategory(
          categoryId, searchSubCategory);

      // Ensure the response is valid and contains the expected 'success' key
      // Safely extract the 'subcategories' list
      subcategories = response;
    } catch (e) {
      // Log and handle the error scenario
      print('Error fetching subcategories: $e');
      subcategories = []; // Reset to an empty list on error
    }

    // Stop loading and notify listeners about the state change
    isLoading = false;
    notifyListeners();
  }

  // Fetch products based on the selected category
// Fetch products based on the selected category
  Future<void> fetchProducts(ProductFilterRequest payload) async {
    isLoading = true; // Set loading to true when fetching products
    notifyListeners();

    try {
      // Pass the payload object to the API service
      products = await authService.fetchProducts(payload);

      // Check if products list is empty and handle that case
      if (products.isEmpty) {
        print('No products found.');
        // Optionally, you can set a flag here to show a "No products found" message in the UI
      } else {
        print('Fetched ${products.length} products');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching products: $e');
      // Optionally, set an error flag here and notify the UI
    } finally {
      isLoading = false; // Set loading to false once products are fetched
      notifyListeners();
    }
  }
}
