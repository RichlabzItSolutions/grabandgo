import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/product_view.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/viewmodel/product_view_model.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';


import '../../common/Utils/app_colors.dart';

class ProductViewmodelScreen extends StatefulWidget {
  @override
  _ProductViewmodelScreenState createState() => _ProductViewmodelScreenState();
}

class _ProductViewmodelScreenState extends State<ProductViewmodelScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  final double _unitPrice = 0;
  late String productId;
  late String variantId;
  late TextEditingController quantityController;
  int quantity = 1;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    quantityController = TextEditingController(text: '1');
    // Fetch product details after dependencies are initialized
    _fetchProductDetails();
  }


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Ensure that you only access context-dependent operations after dependencies have been set up.
  //   final arguments =
  //   ModalRoute
  //       .of(context)
  //       ?.settings
  //       .arguments as Map<String, String>?;
  //   if (arguments != null) {
  //     // Ensure arguments are parsed as integers
  //     final productIdString = arguments['productId'];
  //     final variantIdString = arguments['variantId'];
  //     if (productIdString != null && variantIdString != null) {
  //       final productId = (productIdString);
  //       final variantId = (variantIdString);
  //       // Initialize the ProductViewModel and fetch product details
  //       final viewModel = Provider.of<ProductViewModel>(context, listen: false);
  //       viewModel.fetchProductDetails(productId, variantId);
  //     } else {
  //       // Handle missing arguments if necessary
  //       print("Missing productId or variantId");
  //     }
  //   }
  // }

  void _fetchProductDetails() {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (arguments != null) {
      final productIdString = arguments['productId'];
      final variantIdString = arguments['variantId'];
      if (productIdString != null && variantIdString != null) {
        productId = productIdString;
        variantId = variantIdString;
        // Initialize the ProductViewModel and fetch product details
        final viewModel = Provider.of<ProductViewModel>(context, listen: false);
        viewModel.fetchProductDetails(productId, variantId);
      } else {
        print("Missing productId or variantId");
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final product = viewModel.product;
      if (product == null) {
        return Scaffold(
          body: Center(child: Text("Product not found")),
        );
      }

      return BaseScreen(
        title: product.productTitle,
        showCartIcon: true,
        showShareIcon: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.grey,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color(0xFFF6F6F6),
                  child: Column(
                    children: [
                      // PageView.builder for images
                      Container(
                        margin: EdgeInsets.only(top: 80, right: 80, left: 80),
                        color: Color(0xFFF6F6F6),
                        height: 180,
                        child: Center(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: product.images.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: Image.network(
                                  product.images[index].url,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                                (index) =>
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "₹${product.sellingPrice}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "₹${product.mrp}",
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(product.description),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showProductDetailsBottomSheet(context, product);
                        },
                        icon: const Icon(
                            Icons.shopping_cart, size: 18, color: Colors.white),
                        label: product?.addedToCart == 0
                            ? const Text(
                          'Add to cart',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                            : Text(
                          'Added (${product?.qty})',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: product?.addedToCart == 0
                              ? AppColors.primaryColor
                              : AppColors
                              .textColor, // Change background based on addedToCart state
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showProductDetailsBottomSheet(BuildContext context, ProductView product) {
    int quantity = product.qty != null && product.qty! > 0 ? product.qty! : 1; // Default to 1 if qty is null or 0
    double unitPrice = product.sellingPrice;
    double totalPrice = quantity * unitPrice;
    TextEditingController quantityController = TextEditingController(text: quantity.toString());
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Image, Title, Price, and Quantity Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          product.images
                              .where((imageData) => imageData.isMainImage)
                              .map(
                                (imageData) => Image.network(
                              imageData.url,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/placeholder.png',
                                  width: 60,
                                  height: 60,
                                );
                              },
                            ),
                          )
                              .first,
                          const SizedBox(width: 10),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productTitle,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  '1 Piece(s)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '₹${product.mrp}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${product.sellingPrice}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      // Quantity Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity--;
                                      } else {
                                        quantity = 1; // Ensure minimum is 1
                                      }
                                      totalPrice = quantity * unitPrice;
                                      quantityController.text = quantity.toString();
                                      errorMessage = null;
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.remove, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: TextField(
                                    controller: quantityController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      errorText: errorMessage,
                                    ),
                                    onChanged: (value) {
                                      final int? newQuantity = int.tryParse(value);
                                      setState(() {
                                        if (newQuantity == null || newQuantity <= 0) {
                                          quantity = 1; // Default to 1
                                          errorMessage = 'Invalid quantity. Set to 1.';
                                        } else {
                                          quantity = newQuantity;
                                          errorMessage = null;
                                        }
                                        totalPrice = quantity * unitPrice;
                                      });
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                      totalPrice = quantity * unitPrice;
                                      quantityController.text = quantity.toString();
                                      errorMessage = null;
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      // Total and Add to Cart Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                '₹$totalPrice',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Consumer<ProductViewModel>(
                            builder: (context, viewModel, child) {
                              return ElevatedButton.icon(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () async {
                                  final success = await viewModel.addToCart(
                                      context, quantity);
                                  if (success) {
                                    Navigator.pop(context); // Close bottom sh
                                    // Navigator.pushNamed(
                                    //     context, AppRoutes.ShoppingCart);
                                  }
                                },
                                icon: viewModel.isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : const Icon(Icons.shopping_cart,
                                    size: 18, color: Colors.white),
                                label: viewModel.isLoading
                                    ? const Text('')
                                    : const Text(
                                  'Add to cart',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}
