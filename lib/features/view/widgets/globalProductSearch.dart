import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';
import 'package:hygi_health/data/model/product_model.dart';
import 'package:provider/provider.dart';
import '../../../common/Utils/app_strings.dart';
import '../../../routs/Approuts.dart';
import '../../../viewmodel/category_view_model.dart';
import '../BaseScreen.dart';
import '../ProductScreen.dart';
import '../product_item.dart';

class GlobalProductList extends StatefulWidget {
  @override
  _GlobalProductListPageState createState() => _GlobalProductListPageState();
}
class _GlobalProductListPageState extends State<GlobalProductList> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  bool isSearchActive = false;
  Timer? _debounce;
  static const int _minSearchLength = 3;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchData(""); // Fetch all products initially
    _searchController.addListener(() {
      onSearchChanged();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.length >= _minSearchLength ||
          _searchController.text.isEmpty) {
        filterProducts(_searchController.text);
      }
    });
  }

  void fetchData(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      ProductFilterRequest payload = ProductFilterRequest(
        categoryId: '',
        subCategoryId: '',
        productTitle: query,
        brand: [],
        priceFrom: '',
        priceTo: '',
        colour: [],
        priceSort: '',
      );

      final fetchedProducts = await authService.fetchProducts(payload);
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearchActive = false;
      });
      fetchData(""); // Fetch all products if query is empty
    } else {
      setState(() {
        isSearchActive = true;
      });
      fetchData(query); // Fetch products based on query
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    return BaseScreen(
      title: 'Products',
      showCartIcon: true,
      showShareIcon: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: (value) {
                  if (value.length >= 3) {
                    filterProducts(value);
                  } else if (value.isEmpty) {
                    filterProducts(""); // Show all products when search is cleared
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search products (min 3 characters)...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : isSearchActive || _searchController.text.isNotEmpty
                ? (filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_products.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No products found.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try searching with a different keyword.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  product: filteredProducts[index],
                  isLoading: false,
                );
              },
            ))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppStrings.allCategories,
                    style: TextStyle(
                      fontSize: 22 * MediaQuery.of(context).textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppStrings.byfromAnyCategory,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),
                categoryViewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categoryViewModel.categories.length < 4
                      ? categoryViewModel.categories.length
                      : 4,
                  itemBuilder: (context, index) {
                    final category = categoryViewModel.categories[index];
                    return ProductCard(
                      category: category,
                      isLoading: categoryViewModel.isLoading,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.SUBCATEGORY,
                          arguments: {
                            'categoryId': category.categoryId
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
