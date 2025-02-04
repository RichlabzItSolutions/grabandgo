import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/CartProvider.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final Widget child;
  final bool showShareIcon;
  final bool showCartIcon;

  const BaseScreen({
    Key? key,
    required this.title,
    required this.child,
    this.showCartIcon = true,
    this.showShareIcon = false,
  }) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cart data when screen is initialized
    Provider.of<CartProvider>(context, listen: false).fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            // Navigator.pushReplacementNamed(
            //     context, AppRoutes.HOME); // Handles back navigation
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Circular shape
            ),
            child: Image.asset(
              'assets/backarrow.png', // Path to custom icon
              height: 24, // Adjust size as needed
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black, // Title text color
          ),
        ),
        actions: [
          // Share icon with border color #1A73FC
          if (widget.showShareIcon)
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the icon
                  shape: BoxShape.circle, // Circular shape
                  border: Border.all(
                    color: Colors.white, // Border color set to #1A73FC
                    width: 2, // Border width
                  ),
                ),
                child: Icon(
                  Icons.share,
                  color: AppColors.primaryColor // Icon color to match the border
                ),
              ),
              onPressed: () {
                print("Share clicked");
              },
            ),
          // Cart icon with badge
          if (widget.showCartIcon)
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.black, // Cart icon color
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.ShoppingCart);
                      },
                    ),
                    if (cartProvider.cartItemCount > -1)
                      Positioned(
                        top: 1,  // Adjust top position to create space between icon and badge
                        right: 1,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red, // Badge background color
                          child: Text(
                            '${cartProvider.cartItemCount}', // Number of items in the cart
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white, // Text color for the number
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
      body: widget.child,
    );
  }
}
