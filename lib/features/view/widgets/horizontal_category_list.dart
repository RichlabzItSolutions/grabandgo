import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/data/model/product_model.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/viewmodel/subcategory_view_model.dart';

class HorizontalCategoryList extends StatefulWidget {
  final Function(int) onCategorySelected;
  final int selectedPosition;

  HorizontalCategoryList({
    required this.onCategorySelected,
    required this.selectedPosition,
  });

  @override
  _HorizontalCategoryListState createState() => _HorizontalCategoryListState();
}

class _HorizontalCategoryListState extends State<HorizontalCategoryList> {
  int _selectedIndex = -1;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedPosition;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedIndex >= 0) {
        _fetchProductsForSelectedCategory();
        _scrollToSelectedItem();
      }
    });
  }

  Future<void> _fetchProductsForSelectedCategory() async {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context, listen: false);
    if (subcategoryViewModel.subcategories.isNotEmpty && _selectedIndex >= 0) {
      final selectedCategory = subcategoryViewModel.subcategories[_selectedIndex];
      ProductFilterRequest payload = ProductFilterRequest(
        categoryId: selectedCategory.categoryId.toString(),
        subCategoryId: selectedCategory.subcategoryId.toString(),
        productTitle: '',
        brand: [],
        priceFrom: '',
        priceTo: '',
        colour: [],
        priceSort: '',
      );

      subcategoryViewModel.fetchProducts(payload);
      widget.onCategorySelected(selectedCategory.categoryId);
    }
  }

  // Scroll to the selected item position
  void _scrollToSelectedItem() {
    if (_selectedIndex >= 0 && _selectedIndex < 88) {
      // Scroll to the position of the selected item (adjust for margin and padding)
      double offset = (_selectedIndex * 120.0);  // Assuming each item has a width of 120.0 (adjust as necessary)
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context);
    final categories = subcategoryViewModel.subcategories;
    final isLoading = subcategoryViewModel.isLoading;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return Center(child: Text('No categories available'));
    }

    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Colors.white,
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            controller: _scrollController, // Set the controller for scrolling
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });

                    widget.onCategorySelected(category.categoryId);

                    ProductFilterRequest payload = ProductFilterRequest(
                      categoryId: category.categoryId.toString(),
                      subCategoryId: category.subcategoryId.toString(),
                      productTitle: '',
                      brand: [],
                      priceFrom: '',
                      priceTo: '',
                      colour: [],
                      priceSort: '',
                    );

                    subcategoryViewModel.fetchProducts(payload);
                    _scrollToSelectedItem(); // Scroll to the selected item
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? AppColors.primaryColor : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      category.subcategoryTitle,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primaryColor : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
