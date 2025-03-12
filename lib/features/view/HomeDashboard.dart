import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/features/view/widgets/banner_section_Screen.dart';
import 'package:hygi_health/features/view/widgets/myaccount_screen.dart';
import 'package:hygi_health/features/view/widgets/orderscreen.dart';
import 'package:hygi_health/features/view/widgets/shopping_cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/Utils/app_colors.dart';
import '../../data/model/location_model.dart';
import '../../routs/Approuts.dart'; // Update the import for your routes
import '../../viewmodel/CartProvider.dart';
import '../../viewmodel/category_view_model.dart';
import '../../viewmodel/location_view_model.dart';
import 'ProductScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0; // Track selected bottom navigation tab
  bool isFetching = false; // Flag to track if request is in progress
  DateTime? _lastPressedTime;
  @override
  void initState() {
    super.initState();
    _fetchInitialData(); // Fetch cart and categories data at startup
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _fetchInitialData() async {
    if (isFetching) return; // Prevent multiple requests
    setState(() {
      isFetching = true;
    });

    try {
      final categoryViewModel =
      Provider.of<CategoryViewModel>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      await Future.wait([
        cartProvider.fetchCartData(),
        categoryViewModel.fetchCategories(),
      ]);
    } catch (e) {
      print('Error during fetch: $e');
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }

  Future<void> _handlePageRefresh() async {
    if (isFetching) return; // Prevent multiple requests
    setState(() {
      isFetching = true; // Indicate fetching is in progress
    });

    try {
      final categoryViewModel =
      Provider.of<CategoryViewModel>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await Future.wait([
        cartProvider.fetchCartData(),
        categoryViewModel.fetchCategories(),

      ]);
    } catch (e) {
      // Handle error here (e.g., show a snack bar or a message)
      print('Error during fetch: $e');
    } finally {
      setState(() {
        isFetching = false; // Indicate fetching is completed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBodyContent(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.homeTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset('assets/mycart.png', fit: BoxFit.contain),
            ),
            label: AppStrings.cartTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppStrings.myOrderTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset('assets/profile.png', fit: BoxFit.contain),
            ),
            label: AppStrings.accountTab,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(int index) {
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          // Navigate to the Home page when back button is pressed
          setState(() {
            _selectedIndex =
            0; // Replace _currentIndex with your actual index variable
          });
          return false; // Prevent default back navigation
        }
        else  if (index==0){

          DateTime now = DateTime.now();
          if (_lastPressedTime == null ||
              now.difference(_lastPressedTime!) > Duration(seconds: 2)) {
            // First press, store the current time
            _lastPressedTime = now;
            // Show alert to the user
            _showExitConfirmationDialog(context);
            return Future.value(false); // Prevent default back navigation
          } else {
            // Second press within 2 seconds, exit
            return Future.value(true); // Allow default back navigation
          }
        }
        return true; // Allow default back navigation when on the Home page
      },
      child: IndexedStack(
        index: index,
        children: [
          HomeContent(onRefresh: _handlePageRefresh),
          ShoppingCartScreen(),
          OrderTabsView(),
          MyAccountScreen(),
          Center(
            child: Text(
              "Other Page",
              style: TextStyle(
                fontSize: MediaQuery
                    .of(context)
                    .textScaleFactor * 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit"),
          content: Text("Are you sure you want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                SystemNavigator.pop(); // Close the app
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

}
class HomeContent extends StatefulWidget {
  final Future<void> Function() onRefresh; // Pass refresh function

  HomeContent({required this.onRefresh});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isFetching = false;

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    return RefreshIndicator(
      onRefresh: widget.onRefresh, // Use parent function for refresh
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            BannerSection(),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.allCategories,
                            style: TextStyle(
                              fontSize: 22 *
                                  MediaQuery.of(context)
                                      .textScaleFactor, // Adjust text size
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppStrings.byfromAnyCategory,
                            style: TextStyle(
                              fontSize:
                                  14 * MediaQuery.of(context).textScaleFactor,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.VIEWALL,
                            arguments: categoryViewModel.categories,
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              AppStrings.viewAll,
                              style: TextStyle(
                                fontSize:
                                    14 * MediaQuery.of(context).textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Image.asset(
                              'assets/right.png',
                              height: 16,
                              width: 16,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  categoryViewModel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categoryViewModel.categories.length < 4
                              ? categoryViewModel.categories.length
                              : 4,
                          itemBuilder: (context, index) {
                            final category =
                                categoryViewModel.categories[index];
                            return ProductCard(
                              category: category,
                              isLoading: categoryViewModel.isLoading,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.SUBCATEGORY,
                                  arguments: {
                                    'categoryId': category.categoryId
                                  },
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatefulWidget {
  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();



  }
  Future<void> initializeData() async {
    try {
      final categoryViewModel =
      Provider.of<CategoryViewModel>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await Future.wait([
        cartProvider.fetchCartData(),
        categoryViewModel.fetchCategories(),
      ]);
    } catch (e) {
      // Handle error here (e.g., show a snack bar or log the error)
      print('Error during fetch: $e');
    }
  }

  Future<void> _initializeLocation() async {
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    // Fetch locations if not already loaded
    if (locationViewModel.locations.isEmpty) {
      await locationViewModel.fetchLocations();
    }

    final prefs = await SharedPreferences.getInstance();
    final locationId = prefs.getInt('location');

    if (locationViewModel.locations.length == 1) {
      // If only one location exists, set it by default
      final singleLocation = locationViewModel.locations.first;
      setState(() {
        _selectedLocation = singleLocation;
      });

      // Save it in SharedPreferences
      prefs.setInt('location', singleLocation.id);
    } else if (locationId != null && locationId > 0) {
      // If a location is already set in SharedPreferences, use it
      final location = locationViewModel.locations.firstWhere(
            (loc) => loc.id == locationId,
        orElse: () => Location(
          id: 0,
          location: "Select Location",
          clientLocationId: "",
          status: 0,
          createdOn: "",
        ),
      );

      setState(() {
        _selectedLocation = location;
      });
    } else {
      // Show location selection popup if no location is set
      showLocationPopup(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final cartProvider = Provider.of<CartProvider>(context); // Get cartProvider here
    if (locationViewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (locationViewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Text('Error: ${locationViewModel.errorMessage}',
            style: TextStyle(color: Colors.red)),
      );
    }

    return Container(
      color: AppColors.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
        locationViewModel.locations.isNotEmpty
            ? DropdownButtonHideUnderline(
          child: DropdownButton<Location>(
            isDense: true, // Makes the dropdown compact
            value: _selectedLocation,
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            dropdownColor: Colors.white,
            alignment: AlignmentDirectional.centerEnd, // Align selected text near the icon
            onChanged: (Location? newValue) {
              setState(() {
                _selectedLocation = newValue;
              });
              if (newValue != null) {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setInt('location', newValue.id);
                });
              }
            },
            items: locationViewModel.locations
                .map<DropdownMenuItem<Location>>((Location location) {
              return DropdownMenuItem<Location>(
                value: location,
                child: Text(
                  location.location,
                  textAlign: TextAlign.left, // Align each dropdown item text to the left
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            hint: Text(
              'Select Location',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
            : Text('No locations available'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.GLOBAL_SEARCH);
                  },
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.searchproduct,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.ShoppingCart);
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black, // Cart icon color
                      size: 28, // Adjust size if needed
                    ),
                  ),
                  if (cartProvider.cartItemCount >=0) // Show badge only when items exist
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red, // Badge background color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${cartProvider.cartItemCount}', // Display cart item count
                            style: TextStyle(
                              fontSize: 12, // Font size for the badge text
                              color: Colors.white, // Text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            ],
          ),
        ],
      ),
    );

  }

  void showLocationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<LocationViewModel>(
              builder: (context, locationViewModel, child) {
                if (locationViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (locationViewModel.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${locationViewModel.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select your Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    locationViewModel.locations.isNotEmpty
                        ? DropdownButtonFormField<Location>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            hint: const Text("Select Location"),
                            value: _selectedLocation,
                            items: locationViewModel.locations
                                .map((Location location) {
                              return DropdownMenuItem<Location>(
                                value: location,
                                child: Text(location.location),
                              );
                            }).toList(),
                            onChanged: (Location? newValue) {
                              setState(() {
                                _selectedLocation = newValue;
                              });
                            },
                          )
                        : const Text('No locations available'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_selectedLocation != null) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('location', _selectedLocation!.id);

                          // Perform any action with the selected location
                          print(
                              'Selected Location: ${_selectedLocation!.location}');
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
