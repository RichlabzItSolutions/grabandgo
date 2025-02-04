import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/data/model/category_model.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/CartProvider.dart';
import 'ProductScreen.dart';

class ViewAllScreen extends StatefulWidget {
  final List<Category> categories;

  const ViewAllScreen({required this.categories, Key? key}) : super(key: key);

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;
    final cartProvider = Provider.of<CartProvider>(context);

    return BaseScreen(
      title: AppStrings.allCategories,
      showCartIcon: true,
      showShareIcon: false,
      child: Scaffold(

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: categories.isEmpty
              ? const Center(
            child: Text(
              "No categories available",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          )
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ProductCard(
                category: category,
                isLoading: false,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.SUBCATEGORY,
                    arguments: {
                      'categoryId': category.categoryId,
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
