import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/globally.dart';
import '../data/model/request_user_data.dart';
import 'base_view_ model.dart';

class LoginViewModel extends BaseViewModel {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone = '';
  String _errorMessage =
      ''; // Non-nullable field initialized with a default value
  String? _successMessage;

  String get errorMessage => _errorMessage;

  String? get successMessage => _successMessage;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
  }

  Future<void> login() async {
    setLoading(true);
    if (_phone.isEmpty || _phone.length < 10) {
      setErrorMessage('Please enter a valid phone number.');
      setLoading(false);
      return;
    }
    try {
      final user = RequestUserData(mobile: _phone);
      final result = await authService.login(user);
      _successMessage = result;

      _errorMessage = ''; // Clear error on success
    } catch (e) {
      setErrorMessage('Login failed. Please try again.');
    }
    setLoading(false);
  }

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  // Check if OTPStus has already been verified
  Future<String?> isOtpStatusAlreadyVerified() async {
    final otpStatus = await getOtpStatus();
    return otpStatus;
  }

  // Check if OTP has already been verified
  Future<String?> isOtpAlreadyVerified() async {
    final otpStatus = await getOtp();
    return otpStatus;
  }

  // Method to get OTP status based on userId
  Future<String?> getOtpStatusByUserId() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch the saved userId and otpStatus from SharedPreferences
    String? savedUserId = prefs.getString('userId');
    String? otpStatus = prefs.getString('otpStatus');

    if (savedUserId != null) {
      // You can use savedUserId for further validation or logging if needed
      print("Fetched UserId: $savedUserId");
      print("Fetched OTP Status: $otpStatus");

      return otpStatus; // Return the OTP status associated with the userId
    } else {
      return null; // No userId found, meaning the user has not been authenticated yet
    }
  }

  @override
  void dispose() {
    // Any resource cleanup logic here
    super.dispose();
  }

  // Retrieve userId from SharedPreferences
  Future<String?> getOtpStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('otpStatus');
  }

  // Retrieve userId from SharedPreferences
  Future<String?> getOtp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('otp');
  }
}
