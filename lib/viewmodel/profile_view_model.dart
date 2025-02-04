import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';
import 'package:hygi_health/data/model/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/user_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isLoading = false;
  UserProfile _userProfile = UserProfile(name: '', mobile: '', gender: 1);

  // Getters
  bool get isLoading => _isLoading;
  UserProfile get userProfile => _userProfile;

  // Fetch User Profile
  Future<void> fetchUserProfile() async {
    _setLoading(true);
    try {
      final response = await authService.fetchUserProfile();
      if (response['success']) {
        final userJson = response['data']['user'];
        _userProfile = UserProfile.fromJson(userJson);
      } else {
        throw Exception(response['message']);
      }
    } catch (error) {
      throw Exception("Failed to fetch profile: $error");
    } finally {
      _setLoading(false);
    }
  }

  // Update User Profile (API Call)
  Future<void> updateUserProfile() async {
    if (userProfile == null) {
      throw Exception("User profile is null.");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the user ID from SharedPreferences and convert to an integer
    final String? userIdString = prefs.getString('userId');
    final int? userId = userIdString != null ? int.tryParse(userIdString) : null;

    // Check if userId is null after conversion
    if (userId == null) {
      throw Exception('User ID is not available or invalid in SharedPreferences');
    }
    _setLoading(true);

    // Create an UpdateProfile instance with the current data
    UpdateProfile updateProfile = UpdateProfile(
      userId: userId,
      name: userProfile!.name ?? '',  // Provide a default value if name is null
      gender: (userProfile!.gender ?? 1) == 0 ? 1 : (userProfile!.gender ?? 1),  // Ensure gender is not null and set default to 1 if null
    );


    try {
      // Call the updateUserProfile service with the correct data (from the UpdateProfile instance)
      final response = await authService.updateUserProfile(updateProfile.toJson());

      if (!response['success']) {
        throw Exception(response['message']);
      }
    } catch (error) {
      throw Exception("Failed to update profile: $error");
    } finally {
      _setLoading(false);
    }
  }



  // Helper to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Update methods for individual fields
  void updateName(String name) {
    _userProfile.name = name;
    notifyListeners();
  }

  void updateMobile(String mobile) {
    _userProfile.mobile = mobile;
    notifyListeners();
  }

  // Update gender (integer value)
  void updateGender(int newGender) {
    userProfile.gender = newGender;
    notifyListeners();
  }

  // // Method to update profile picture
  // Future<void> pickProfileImage() async {
  //   try {
  //     final image = await Globally.pickImage(); // Add your image picking logic
  //     if (image != null) {
  //       _userProfile.imageUrl = image.path; // Assuming UserProfile has an imageUrl property
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     throw Exception("Failed to pick image: $error");
  //   }
  // }
}
