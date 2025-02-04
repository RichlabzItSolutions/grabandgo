import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/viewmodel/base_view_ model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/globally.dart';
import '../data/model/request_user_data.dart';
import '../data/model/verify_otp_model.dart';

class VerifyOtpViewModel extends BaseViewModel {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;
  bool _isOtpVerified = false;
  String _otp = '';
  String _errorMessage = '';
  String? _successMessage;

  String get otp => _otp;

  String get errorMessage => _errorMessage;

  bool get canResend => _canResend;

  int get start => _start;

  bool get isOtpVerified => _isOtpVerified;

  List<TextEditingController> get controllers => _controllers;

  VerifyOtpViewModel() {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _start = 60;
    _isOtpVerified = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _canResend = true;
        timer.cancel();
      } else if (!_isOtpVerified) {
        _start--;
      }
      notifyListeners();
    });
  }

  void setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  // Handle OTP resend
  Future<void> handleResend(BuildContext context) async {
    try {
      // Fetch mobile number and userId from SharedPreferences before sending OTP
      String? mobile = await getMobile();
      if (mobile != null) {
        print("Resend OTP clicked for mobile: $mobile");
        // Call your OTP resend API or logic here using mobile and userId

        _startTimer();

        try {
          final user = RequestUserData(mobile: mobile);
          final result = await authService.login(user);
          _successMessage = result;
          _errorMessage = ''; // Clear error on success

          // Show success message in Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_successMessage ?? 'Login successful')),
          );
        } catch (e) {
          setErrorMessage('Login failed. Please try again.');

          // Show error message in Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage)),
          );
        }
      } else {
        print("No mobile or userId found in SharedPreferences.");
      }
    } catch (e) {
      print("Error while handling OTP resend: $e");
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    _otp = _controllers
        .map((controller) => controller.text)
        .join(); // Combine all OTP fields

    if (_otp.length == 4) {
      _isOtpVerified = false; // Initially mark as not verified
      _errorMessage = ''; // Clear error message
      notifyListeners();

      try {
        // Fetch the userId from SharedPreferences
        final String? mobile = await getMobile();

        if (mobile == null) {
          throw Exception("User ID is missing. Please try again.");
        }

        // Create the request object
        final user = VerifyOtpModelRequest(mobile: mobile, otp: _otp);

        // Call the API to verify OTP
        final result = await authService.verifyOtp(user);
        _isOtpVerified = true;
        _successMessage = result;
        _errorMessage = ''; // Clear any previous error
        _isOtpVerified = true; // Mark as verified
        notifyListeners();

        // Show success message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_successMessage ?? 'OTP verified successfully'),
            backgroundColor: AppColors.primaryColor,
          ),
        );

        // Optionally, navigate to the next screen
        // Navigator.pushNamed(context, AppRoutes.HOME);
      } catch (e) {
        // Handle errors and display the error message
        _errorMessage = e.toString();
        notifyListeners();
        _isOtpVerified = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $_errorMessage"),
            backgroundColor: Colors.red,
          ),
        );

        print("Error verifying OTP: $e");
      }
    } else {
      // Show error for invalid OTP length
      _errorMessage = 'Please enter a valid 4-digit OTP.';
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Retrieve mobile number from SharedPreferences
  Future<String?> getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobile');
  }
}
