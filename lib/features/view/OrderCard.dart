import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/order_model.dart';
import '../../../viewmodel/order_view_model.dart';
import '../../routs/Approuts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final String activeTab;

  OrderCard({required this.order, required this.activeTab});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showCancelButton = widget.order.orderStatus == 1 || widget.order.orderStatus == 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card with white background and professional appearance
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners for the card
          ),
          elevation: 6, // Subtle shadow for depth
          color: Colors.white, // White background for the card
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Padding for spacing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderDetailsRow(context),
                const SizedBox(height: 16),
                _buildOrderInfo(),
                const SizedBox(height: 16),
                _buildOrderStatusRow(), // Added row for order status and action buttons
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        // Full-width Cancel button with blue border and background

      ],
    );
  }

  Widget _buildOrderDetailsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display Order ID on the left
        Text(
          'Order ID: ${widget.order.id} ',
          style: TextStyle(
            fontSize: 20, // Larger font size for the order ID
            fontWeight: FontWeight.bold, // Bold for emphasis
            color: Colors.black, // Darker color for the order ID
          ),
        ),
        // Display Qty on the right
        Text(
          'Qty: ${widget.order.totalItems}',
          style: TextStyle(
            fontSize: 14, // Standard text size for quantity
            fontWeight: FontWeight.bold, // Medium weight for quantity
            color: Colors.black, // Dark grey for quantity
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatus(int status) {
    final statusData = _getStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: statusData['color'].withOpacity(0.1), // Light background color
        borderRadius: BorderRadius.circular(12), // Rounded corners for status
      ),
      child: Text(
        statusData['text'],
        style: TextStyle(
          color: statusData['color'],
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(int status) {
    switch (status) {
      case 1:
        return {'text': 'New Order', 'color': Colors.lightBlue}; // New Order is gray
      case 2:
        return {'text': 'Confirmed', 'color': Colors.blue};
      case 3:
        return {'text': 'In Transit', 'color': Colors.purple};
      case 4:
        return {'text': 'Delivered', 'color': Colors.green};
      default:
        return {'text': 'Cancelled', 'color': Colors.red};
    }
  }

  Widget _buildOrderInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order Date: ${widget.order.orderDate}',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        Expanded(
          child: Text(
            'Total Amount: ₹${widget.order.payableAmount}',
            style: const TextStyle(fontSize: 14, color: Colors.black),
            overflow: TextOverflow.ellipsis, // Ensures text does not overflow
            textAlign: TextAlign.end, // Align total payment text to the right
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Order status displayed on the left
        _buildOrderStatus(widget.order.orderStatus),
        // Align the buttons to the right
        Row(
          children: [
            // Conditionally show the Cancel Button
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userIdString = prefs.getString('userId');
                int userId = int.tryParse(userIdString ?? '') ?? 0;
                final orderId = widget.order.id;

                Navigator.pushNamed(
                  context,
                  AppRoutes.ORDER_DETAILS,
                  // Route for the Order Details screen
                  arguments: {
                    'userId': userId,
                    'orderId': orderId,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                backgroundColor: Colors.blue, // Background color
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Order',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (widget.order.orderStatus == 1 || widget.order.orderStatus == 2)
              ElevatedButton(
                onPressed: () => _showCancelConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  backgroundColor: Colors.red, // Red background for cancel button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel ',
                  style: TextStyle(color: Colors.white ,fontSize:14,fontWeight: FontWeight.bold),
                ),
              ),
            // Track Order Button

          ],
        ),
      ],
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to cancel this order?'),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for canceling',
                  hintText: 'Please provide a reason...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                final orderViewModel =
                Provider.of<OrderViewModel>(context, listen: false);
                String reason = _reasonController.text;
                orderViewModel.cancelOrder(context, widget.order.id, reason);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
