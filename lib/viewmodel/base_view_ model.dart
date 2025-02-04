import 'package:flutter/material.dart';

class BaseViewModel with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isDisposed = false;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  bool get isDisposed => _isDisposed;

  void setLoading(bool isLoading) {
    if (!isDisposed) {
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  void setErrorMessage(String errorMessage) {
    if (!isDisposed) {
      _errorMessage = errorMessage;
      notifyListeners();
    }
  }

// Add custom methods as needed, e.g., for validation
// bool validate() {
//   // Implement validation logic
// }
}
