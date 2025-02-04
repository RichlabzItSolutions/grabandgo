import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/data/model/category_model.dart';

import '../../common/constants/constans.dart'; // Import the Category model

class ProductCard extends StatelessWidget {
  final Category category; // Pass the entire category object
  final bool isLoading; // A flag to indicate loading state
  final VoidCallback onTap;

  const ProductCard({
    required this.category, // Accept a Category object as a parameter
    required this.isLoading, // Indicate if the product is loading
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          // Set the background color to #F6F6F6
          borderRadius: BorderRadius.circular(12),
          // Rounded corners
          boxShadow: const [
            // BoxShadow(
            //   color: Colors.black12,
            //   blurRadius: 4,
            //   spreadRadius: 2,
            // ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CircularProgressIndicator() // Show loading indicator if true
                : category.appIcon.isNotEmpty
                    ? Image.network(
                        category
                            .appIcon, // Dynamically display the category icon
                        width: 67,
                        height: 67,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.category, // Default icon if loading fails
                            size: 67,
                            color: AppColors.primaryColor,
                          );
                        },
                      )
                    : const Icon(
                        Icons.category, // Default icon if no icon is provided
                        size: 67,
                        color: AppColors.primaryColor,
                      ),
            const SizedBox(height: 16), // Space between the icon and the title
            isLoading
                ? const SizedBox.shrink() // No title when loading
                : Text(
                    AppConstants.capitalizeFirstLetter(category.categoryTitle),
                    // Capitalize first letter of categoryTitle
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black, // Optional styling
                      fontWeight: FontWeight.w600, // Optional styling
                    ),
                  ),
          ],
        ),
      ),
    );
  }
// Function to capitalize the first letter of categoryTitle and keep the rest lowercase
}
