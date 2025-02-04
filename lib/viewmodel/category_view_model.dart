import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';
import 'package:hygi_health/data/model/category_model.dart';
import 'package:hygi_health/data/model/product_model.dart';

class CategoryViewModel extends ChangeNotifier {
  List<Category> categories = [];
  List<Product> products = [];
  bool isLoading = false; // Track the loading state
  // Fetch categories from the API
  Future<void> fetchCategories() async {
    try {
      categories =
          await authService.fetchCategories(); // Fetch categories from the API
      products = []; // Clear previous products
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Fetch products based on the selected category
  Future<void> fetchProducts(ProductFilterRequest payload) async {
    isLoading = true; // Set loading to true when fetching products
    notifyListeners();

    try {
      // Pass the payload object to the API service
      products = await authService.fetchProducts(payload);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading = false; // Set loading to false once products are fetched
      notifyListeners();
    }
  }

  CategoryViewModel() {
    fetchCategories(); // Fetch categories when the ViewModel is created
  }
}
