import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/Utils/app_colors.dart';
import '../../../routs/Approuts.dart';
import '../../../viewmodel/profile_view_model.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      profileViewModel.fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.HOME); // Handles back navigation
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Circular shape
            ),
            child: Image.asset(
              'assets/backarrow.png', // Path to custom icon
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          // Check if data is loading
          if (profileViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Implement image picking functionality here
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Dynamically show profile name
                    Text(
                      profileViewModel.userProfile.name ?? 'Your Name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Options List
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Image.asset("assets/profile.png"),
                      title: const Text('Your Profile', style: TextStyle(color: Colors.black)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.PROFILE);
                      },
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Image.asset("assets/location.png"),
                      title: const Text('My Address Book', style: TextStyle(color: Colors.black)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.DeliveryAddress,
                          arguments: {'from': 2},
                        );
                      },
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Image.asset("assets/cart.png"),
                      title: const Text('My Orders', style: TextStyle(color: Colors.black)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.MYORDERS);
                      },
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Image.asset("assets/privacy.png"),
                      title: const Text('Help & Support', style: TextStyle(color: Colors.black)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.Help_Support);
                      },
                    ),
                    _buildDivider(),

                    ListTile(
                      leading: Image.asset("assets/privacy.png"),
                      title: const Text('Privacy Policy', style: TextStyle(color: Colors.black)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {

                      },
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: Image.asset("assets/privacy.png"),
                      title: const Text('Delivery Slab Info', style: TextStyle(color: Colors.black)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.SLOB);
                      },
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        _logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        thickness: 1,
        color: Colors.grey,
        height: 1, // Reduced height for minimal vertical space
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}
