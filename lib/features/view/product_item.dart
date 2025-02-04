import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/Utils/app_colors.dart';
import '../../data/model/product_model.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/CartProvider.dart';
import '../../viewmodel/product_view_model.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isLoading;
  int quantity = 1;
  ProductItem({required this.product, this.isLoading = false});
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late TextEditingController quantityController;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    quantityController =
        TextEditingController(text: widget.quantity.toString());
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variant = widget.product.variants.isNotEmpty ? widget.product
        .variants[0] : null;
    final imageUrl = variant != null && variant.images.isNotEmpty
        ? variant.images[0].url
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productviewmodel,
          arguments: {
            'productId': widget.product.productId.toString(),
            'variantId': variant != null ? variant.variantId.toString() : '',
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      child: Align(
                        alignment: Alignment.center,
                        child: widget.isLoading
                            ? CircularProgressIndicator()
                            : imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                            widget.product.productTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          widget.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                            "1 Piece",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          widget.isLoading
                              ? CircularProgressIndicator()
                              : Row(
                            children: [
                              Text(
                                variant != null
                                    ? "₹ ${variant.sellingPrice}"
                                    : "₹ 0",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                variant != null
                                    ? "₹ ${variant.mrp}"
                                    : "₹ 0",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final viewModel = Provider.of<ProductViewModel>(
                          context,
                          listen: false,
                        );

                        if (variant != null) {
                          if (variant.addedToCart == 0) {
                            viewModel.fetchProductDetails(
                              widget.product.productId.toString(),
                              variant.variantId.toString(),
                            );
                            _showProductDetailsBottomSheet(
                              context,
                              variant,
                              imageUrl!,
                              widget.product,
                            );
                          } else {
                            _showProductDetailsBottomSheet(
                              context,
                              variant,
                              imageUrl!,
                              widget.product,
                            );
                          }
                        } else {
                          print(
                              "Variant or Image URL is null. Cannot proceed.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: variant?.addedToCart == 0
                            ? AppColors.backgroundColor
                            : AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      ),
                      child: variant?.addedToCart == 0
                          ? const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                          : Text(
                        "Added (${variant?.qty})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDetailsBottomSheet(
      BuildContext context,
      Variant variant,
      String imageUrl,
      Product product,
      ) {
    int initialQuantity = variant.qty ?? 1; // Default to 1 if qty is null
    TextEditingController quantityController =
    TextEditingController(text: initialQuantity.toString());
    String? errorMessage;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchCartData();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            double unitPrice = variant.sellingPrice;
            double totalPrice = initialQuantity * unitPrice;

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
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
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productTitle,
                                  style: const TextStyle(
                                    fontSize: 13,
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
                                      '₹${variant.mrp}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${variant.sellingPrice}',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (initialQuantity > 1) {
                                      setState(() {
                                        initialQuantity--;
                                        totalPrice =
                                            initialQuantity * unitPrice;
                                        quantityController.text =
                                            initialQuantity.toString();
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: SizedBox(
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
                                        final int? newQuantity =
                                        int.tryParse(value);
                                        setState(() {
                                          if (newQuantity == null ||
                                              newQuantity <= 0) {
                                            errorMessage =
                                            'Invalid quantity. Defaulted to 1.';
                                            initialQuantity = 1;
                                          } else {
                                            errorMessage = null;
                                            initialQuantity = newQuantity;
                                          }
                                          totalPrice =
                                              initialQuantity * unitPrice;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      initialQuantity++;
                                      totalPrice = initialQuantity * unitPrice;
                                      quantityController.text =
                                          initialQuantity.toString();
                                    });
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (initialQuantity == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Please select a valid quantity.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            final success = await Provider.of<ProductViewModel>(
                              context,
                              listen: false,
                            ).addToCart(context, initialQuantity);
                            if (success) {
                              cartProvider.fetchCartData();
                              Navigator.pop(context);
                              // Close bottom sheet

                              setState(() {
                                // Update quantity dynamically in the parent widget
                                variant.qty = initialQuantity;
                                variant?.addedToCart = 1;  // Product is added to cart
                              });
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add to cart',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          backgroundColor: AppColors.primaryColor,
                        ),
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