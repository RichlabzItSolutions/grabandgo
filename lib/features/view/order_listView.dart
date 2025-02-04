import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/order_view_model.dart';
import 'OrderCard.dart'; // Import the OrderCard widget

class OrderListView extends StatelessWidget {
  final OrderViewModel orderViewModel;
  final String orderStatus;

  OrderListView({required this.orderViewModel, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to the changes in OrderViewModel
    return Consumer<OrderViewModel>(
      builder: (context, orderViewModel, child) {
        final filteredOrders = orderViewModel.filteredOrders;
        //final isLoading = orderViewModel.orders.isEmpty;
        // Debugging print statements
        print(
            "Filtered Orders Length: ${filteredOrders.length}"); // Check how many filtered orders there are
        print(
            "Order Status: $orderStatus"); // Check what order status is being passed

        // Return a loading indicator while data is being fetched
        // if (isLoading) {
        //   return Center(
        //     child: CircularProgressIndicator(),  // Loading indicator
        //   );
        // }

        // Check if no orders are found and display a message
        if (filteredOrders.isEmpty) {
          return Center(
            child: Text("No orders found for this status"),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await orderViewModel
                .fetchOrdersForTab(); // Trigger the refresh action
          },
          child: ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index]; // Get the order
              final orderStatus = order.orderStatus == 1
                  ? 'Active'
                  : order.orderStatus == 4
                      ? 'Delivered'
                      : 'Cancelled'; // Set the status string based on the order's orderStatus
              return OrderCard(
                order: order,
                activeTab: orderStatus, // Pass the status to the OrderCard
              );
            },
          ),
        );
      },
    );
  }
}
