import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/globally.dart';
import '../data/model/HelpCenter.dart';

class HelpCenterViewModel with ChangeNotifier {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isLoading = false; // Loading state

  // Function for submitting the form
  Future<void> submitForm(BuildContext context) async {
    final String subject = subjectController.text;
    final String message = messageController.text;

    // Get userId from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');
    if (userIdString == null) {
      // Handle the case when user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    int userId = int.tryParse(userIdString) ?? 0;
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid user ID.')),
      );
      return;
    }

    // Validate inputs
    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject or Message cannot be empty.')),
      );
      return;
    }

    isLoading = true;
    notifyListeners(); // Notify UI to show loading indicator

    try {
      // Replace this with your actual API call logic
      final Map<String, dynamic> requestBody = {
        "userId": userId,
        "subject": subject,
        "message": message,
      };

      print("Submitting: $requestBody");
      var response = await authService.submitHelpRequest(requestBody);
      if (response) {
        // Success: Do something like showing a Snackbar or updating UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request submitted successfully!')),
        );
      } else {
        // Failure: Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request.')),
        );
      }
    } catch (e) {
      // Handle errors during the API call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting request: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  HelpCenter? _helpCenter;


  HelpCenter? get helpCenter => _helpCenter;

  // Method to fetch Help Center details
  Future<void> fetchHelpCenterDetails() async {
    isLoading = true;
    notifyListeners(); // Notify listeners to show loading

    _helpCenter = await authService.fetchHelpCenter();
    isLoading = false;
    notifyListeners(); // Notify listeners to hide loading
  }
  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
