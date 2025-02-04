// location_view_model.dart
import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';

import '../data/model/location_model.dart';


class LocationViewModel extends ChangeNotifier {

  List<Location> _locations = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Location> get locations => _locations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchLocations() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _locations = await authService.fetchLocations();


    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
