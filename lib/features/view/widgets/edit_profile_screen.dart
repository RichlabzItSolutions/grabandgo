import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/profile_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user profile only once when the screen is loaded
    _fetchUserProfile();
  }

  // Fetch user profile data
  Future<void> _fetchUserProfile() async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await viewModel
        .fetchUserProfile(); // Assuming you have a method to fetch the profile
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              'assets/backarrow.png',
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture with Edit Icon
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        // Use viewModel.userProfile!.imageUrl here if needed
                      ),
                      InkWell(
                        onTap: () async {
                          // await viewModel.pickProfileImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  _buildTextField(
                    label: 'Name',
                    initialValue: viewModel.userProfile?.name ?? '',
                    onChanged: (value) => viewModel.updateName(value),
                  ),
                  const SizedBox(height: 12),

                  // Phone Number
                  _buildTextField(
                    label: 'Phone Number',
                    initialValue: viewModel.userProfile?.mobile ?? '',
                    onChanged: null,
                    // Disable text input
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                    enabled: false, // Make the field non-editable
                  ),

                  const SizedBox(height: 12),

                  // Gender Dropdown
                  _buildDropdown(
                    label: 'Gender',
                    value: _genderToString(viewModel.userProfile?.gender ?? 1),
                    items: ['Male', 'Female'],
                    onChanged: (newValue) =>
                        viewModel.updateGender(_stringToGender(newValue)),
                  ),
                  const SizedBox(height: 24),

                  // Update Profile Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _handleProfileUpdate(context, viewModel);
                    },
                    icon: Icon(Icons.edit),
                    label: Text(
                      'Update Profile',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper Function to Handle Profile Update
  Future<void> _handleProfileUpdate(
      BuildContext context, ProfileViewModel viewModel) async {
    try {
      await viewModel.updateUserProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true, // Default to true if no 'enabled' is passed
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Ensure it's not grayed out
        ),
        disabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Ensure border remains visible
        ),
      ),
      keyboardType: keyboardType,
      onChanged: enabled ? onChanged : null,
      // Disable input if not enabled
      validator: validator,
      enabled: enabled, // Control whether the field is editable
    );
  }

  // Helper to Build Dropdown
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isNotEmpty ? value : items.first,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (newValue) => onChanged(newValue ?? ''),
    );
  }

  // Convert gender integer to string label
  String _genderToString(int gender) {
    switch (gender) {
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Male'; // Default to Male if no valid gender
    }
  }

  // Convert string label back to gender integer
  int _stringToGender(String gender) {
    switch (gender) {
      case 'Male':
        return 1;
      case 'Female':
        return 2;
      default:
        return 1; // Default to Male if no valid gender
    }
  }
}
