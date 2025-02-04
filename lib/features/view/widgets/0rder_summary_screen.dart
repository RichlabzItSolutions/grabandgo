import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/Utils/dotted_divider.dart';
import '../../../viewmodel/order_summary_viewModel.dart';
import '../BaseScreen.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late int userId;
  late int orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the arguments here inside didChangeDependencies to ensure it's accessed after context is available
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    userId = arguments?['userId'];
    orderId = arguments?['orderId'];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderSummaryViewModel(),
      child: BaseScreen(
        title: 'Order Summary',
        // Example cart item count
        showCartIcon: false,
        showShareIcon: false,
        child: Scaffold(
          body: Consumer<OrderSummaryViewModel>(
            builder: (context, viewModel, _) {
              // Trigger fetchOrderSummary only once when the screen is first built
              if (viewModel.orderSummary.orderId == 0) {
                viewModel.fetchOrderSummary(userId, orderId);
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${viewModel.orderSummary.orderId}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Order Date: ${viewModel.orderSummary.orderDate}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    // Increased spacing between sections
                    const Text(
                      'Your Items',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.orderSummary.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.orderSummary.cartItems[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  // Circle with blue fill and white border
                                  Container(
                                    width: 20,
                                    // Size of the circle
                                    height: 20,
                                    // Same as width to keep it round
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // Ensures the shape is circular
                                      color: Colors.white,
                                      // White background color inside the circle
                                      border: Border.all(
                                        color: Colors.blue, // Blue border color
                                        width: 2, // Width of the blue border
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 10,
                                        // Size of the blue dot
                                        height: 10,
                                        // Same as width to keep it round
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // Ensures the shape is circular
                                          color: Colors
                                              .blue, // Blue color for the dot inside
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Spacing between circle and name
                                  Expanded(
                                    child: Text(
                                      item.productTitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        // Bold text
                                        color: Colors.black, // Black text color
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹ ${item.totalAmount}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold, // Bold text
                                      color: Colors.black, // Black text color
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Added space between rows
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('${item.quantity} x ${item.unitPrice}'),
                                ],
                              ),
                              const SizedBox(height: 15),
                              // Added space between rows
                              DottedDivider(
                                dotSize: 1.0,
                                color: Colors.black,
                                spacing: 6.0,
                              ),
                              const SizedBox(height: 20),
                              // Added more space after divider
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Increased space before Bill Details
                    const Text(
                      'Bill Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Item Total'),
                        Text('₹ ${viewModel.orderSummary.finalAmount}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Added space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Charges'),
                        Text('₹ ${viewModel.orderSummary.shippingCharges}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DottedDivider(
                      dotSize: 1.0,
                      color: Colors.black,
                      spacing: 6.0,
                    ),
                    const SizedBox(height: 10),
                    // Added space after divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payment',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '₹ ${viewModel.orderSummary.payableAmount}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Added space after total payment row
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
