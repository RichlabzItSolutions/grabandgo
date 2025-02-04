import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/routs/Approuts.dart';
import 'package:provider/provider.dart';
import '../../../common/Utils/dotted_divider.dart';
import 'package:hygi_health/viewmodel/shopping_cart_view_model.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cart items when the screen is initialized
    final viewModel =
    Provider.of<ShoppingCartViewModel>(context, listen: false);
    viewModel.fetchCartItems();
    viewModel.fetchMinAmount();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ShoppingCartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
                context, AppRoutes.HOME); // Handles back navigation
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Circular shape
            ),
            child: Image.asset(
              'assets/backarrow.png', // Path to custom icon
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/no_products.png', // Optional: Use a "No Products" image
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Cart is Empty.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.HOME);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Start  Shopping',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
          ],
        ),
      )
          : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.items.length,
                itemBuilder: (context, index) {
                  final item = viewModel.items[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Image with error handling
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.mainImageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "₹${item.mrp}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "₹${item.unitPrice}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Quantity controls and remove button
                          Column(
                            children: [
                              // Quantity input with TextField
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
                                        // Decrement quantity but prevent going below 1
                                        if (item.quantity > 1) {
                                          viewModel.decrementQuantity(index);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.remove,
                                            color: Colors.white, size: 15),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: SizedBox(
                                        width: 30,
                                        height: 40,
                                        child: Center( // Ensures vertical alignment
                                          child: TextField(
                                            controller: TextEditingController(text: '${item.quantity}'),
                                            textAlign: TextAlign.center, // Center-align text horizontally
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero, // No padding for perfect centering
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                            onChanged: (value) {
                                              // Validate input to allow only valid positive integers
                                              int? newQuantity = int.tryParse(value);
                                              if (newQuantity != null && newQuantity > 0) {
                                                viewModel.updateQuantity(index, newQuantity);
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Increment quantity
                                        viewModel.incrementQuantity(index);
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.add,
                                            color: Colors.white, size: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => _showRemoveConfirmationDialog(
                                    context, index, viewModel),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            DottedDivider(
              dotSize: 1.0,
              color: Colors.black,
              spacing: 6.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSummaryRow('No. of items:', viewModel.totalItems.toString()),
                  _buildSummaryRow('Sub Total:', '₹${viewModel.subTotal}'),
                  _buildSummaryRow('Delivery Charges:', '₹${viewModel.deliveryCharges}'),
                  DottedDivider(
                    dotSize: 1.0,
                    color: Colors.black,
                    spacing: 6.0,
                  ),
                  _buildSummaryRow('Total Payment:', '₹${viewModel.finalAmount}',
                      isBold: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: viewModel.finalAmount < (viewModel.minAmount is num ? viewModel.minAmount : 0)
                        ? null // Disable the button if total is less than min amount
                        : () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.DeliveryAddress,
                        arguments: {'from': 1}, // Passing arguments as a map
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.subTotal < (viewModel.minAmount is num ? viewModel.minAmount : 0)
                          ? Colors.grey // Disabled button color
                          : AppColors.primaryColor, // Enabled button color
                      minimumSize: const Size(double.infinity, 50),
                    ),

                  child: Text(
                    // Check if the final amount is less than the minimum amount and display appropriate text
                    viewModel.subTotal < (viewModel.minAmount is num ? viewModel.minAmount : 0)
                        ? 'Minimum order amount is ₹${(viewModel.minAmount is num ? viewModel.minAmount : 0)}'
                        : 'Place Order',

                    style: TextStyle(
                      fontSize: 18,
                      // Check if the final amount is less than the minimum amount and set appropriate color
                      color: viewModel.subTotal < (viewModel.minAmount is num ? viewModel.minAmount : 0)
                          ? Colors.black // Warning color (when minAmount is not met)
                          : Colors.white, // Normal color (when minAmount is met)
                    ),
                  ),
    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],


      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {Color textColor = Colors.black, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmationDialog(
      BuildContext context, int index, ShoppingCartViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Remove Item',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to remove this item from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                viewModel.removeCartItem(index);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }



}
