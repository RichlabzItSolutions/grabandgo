import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/Utils/app_colors.dart';
import '../../../viewmodel/slide_view_model.dart';

class BannerSection extends StatefulWidget {
  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Fetch banners when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<SliderViewModel>(context, listen: false);
      viewModel.fetchBanners(); // Fetch the banners from the API
      viewModel.startAutoScroll(_pageController);
    });
  }

  @override
  void dispose() {
    // Stop auto-scrolling when the widget is disposed
    final viewModel = Provider.of<SliderViewModel>(context, listen: false);
    viewModel.stopAutoScroll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderViewModel>(
      builder: (context, viewModel, child) {
        // Show loading indicator while data is being fetched
        if (viewModel.isLoading) {
          return Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator()), // Display the spinner here
          );
        }

        return Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              // Banner Section with PageView
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 120, // Set a fixed height for the banner
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: viewModel.banners.length, // Dynamic item count
                    onPageChanged: (index) {
                      viewModel.setCurrentPage(index);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          viewModel.banners[index],
                          // Dynamically load image from the URL
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          // Height set to match the SizedBox height
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Page Indicator
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    viewModel.banners.length, // Dynamic number of banners
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: viewModel.currentPage == index
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
