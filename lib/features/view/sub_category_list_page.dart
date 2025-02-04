import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/constants/constans.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/CartProvider.dart';
import '../../viewmodel/subcategory_view_model.dart';


class SubcategoryListPage extends StatefulWidget {
  final int categoryId;
  final String searchSubCategory; // Optional parameter to filter subcategories

  SubcategoryListPage(
      {required this.categoryId, required this.searchSubCategory});

  @override
  _SubcategoryListPageState createState() => _SubcategoryListPageState();
}

class _SubcategoryListPageState extends State<SubcategoryListPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchSubCategory);

    // Fetch subcategories when the page is initialized
    context
        .read<SubcategoryViewModel>()
        .fetchSubcategories(widget.categoryId, widget.searchSubCategory);
  }

  void _onSearchChanged(String query) {
    // Trigger the search and fetch the filtered results
    context
        .read<SubcategoryViewModel>()
        .fetchSubcategories(widget.categoryId, query);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context); // Access cart provider

    return Consumer<SubcategoryViewModel>(
      builder: (context, viewModel, child) {
        final subcategoryCount =
        viewModel.isLoading ? null : viewModel.subcategories.length;
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  'assets/backarrow.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sub Category', // Main title
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (!viewModel.isLoading)
                  Text(
                    '$subcategoryCount items', // Subtitle with count
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 2.0,
            iconTheme: IconThemeData(color: Colors.black),
              actions: [
                // Cart icon in the AppBar's actions
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.black, // Cart icon color
                      ),
                      onPressed: () {
                        // Navigate to the cart screen
                        Navigator.pushNamed(
                            context, AppRoutes.ShoppingCart);
                      },
                    ),
                    if (cartProvider.cartItemCount > -1)
                      Positioned(
                        top: 1,  // Adjust top position to create space between icon and badge
                        right: 1,  // Adjust right position to create space between icon and badge
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 20,
                          height: 20,
                          child: Center(
                            child: Text(
                              '${cartProvider.cartItemCount}', // Cart item count
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],

          ),
          body: Column(
            children: [
              // Search field below the AppBar with reduced height
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(8.0),
                  elevation: 4.0,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search Subcategories...',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0),
                      ),
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
              ),
              // Subcategory list
              Expanded(
                child: viewModel.isLoading
                    ? Center(
                    child: CircularProgressIndicator())
                    : viewModel.subcategories.isEmpty
                    ? Center(child: Text('No Subcategories Found'))
                    : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: viewModel.subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory =
                    viewModel.subcategories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.CategoryViewAll,
                          arguments: {
                            'categoryId': subcategory.categoryId,
                            'position': index,
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppConstants.capitalizeFirstLetter(subcategory.subcategoryTitle),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppColors.subcategory,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
