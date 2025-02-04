import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';

class SliderViewModel extends ChangeNotifier {
  List<String> _banners = []; // List of banner image URLs
  List<String> get banners => _banners;

  bool isLoading = false;

  int _currentPage = 0;

  int get currentPage => _currentPage;

  // Timer for auto-scrolling
  Timer? _timer;

  // Fetch banners from APIClass
  Future<void> fetchBanners() async {
    isLoading = true;
    notifyListeners();

    try {
      _banners =
          await authService.fetchBanners(); // Fetch banners using the APIClass
    } catch (e) {
      print('Error fetching banners: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Start auto-scrolling the banners
  void startAutoScroll(PageController pageController) {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Reset to first banner
      }
      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    });
  }

  // Stop the auto-scrolling
  void stopAutoScroll() {
    _timer?.cancel();
  }

  // Set current page manually
  void setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }
}
