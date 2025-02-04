import 'package:flutter/material.dart';
import 'package:hygi_health/viewmodel/subcategory_view_model.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/features/view/product_item.dart'; // Assuming you have a ProductItem widget

class ProductListView extends StatelessWidget {
  final String searchTerm;

  ProductListView({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context);
    // Filter products based on searchTerm
    final filteredProducts = subcategoryViewModel.products.where((product) {
      return product.productTitle
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductItem(product: filteredProducts[index]);
      },
    );
  }
}
