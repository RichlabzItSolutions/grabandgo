import 'package:flutter/cupertino.dart';
import 'package:hygi_health/features/view/widgets/0rder_summary_screen.dart';
import 'package:hygi_health/features/view/widgets/globalProductSearch.dart';
import 'package:hygi_health/features/view/widgets/help_center_screen.dart';
import '../data/model/category_model.dart';
import '../features/view/HomeDashboard.dart';
import '../features/view/LoginScreen.dart';
import '../features/view/VerifyOtpScreen.dart';
import '../features/view/add_address_screen.dart';
import '../features/view/category_view.dart';
import '../features/view/product_viewmodel_screen.dart';
import '../features/view/sub_category_list_page.dart';
import '../features/view/viewAllScreen.dart';
import '../features/view/widgets/edit_profile_screen.dart';
import '../features/view/widgets/order_confirmation_page.dart';
import '../features/view/widgets/delivery_address_screen.dart';
import '../features/view/widgets/myaccount_screen.dart';
import '../features/view/widgets/orderscreen.dart';
import '../features/view/widgets/shopping_cart_screen.dart';
import '../features/view/widgets/slob_screen..dart';
import '../splashscreen.dart';

class AppRoutes {
  static const String SPLASH = '/';
  static const String LOGIN = '/login';
  static const String VERIFY = '/verify';
  static const String HOME = '/home';
  static const String VIEWALL = '/viewall';
  static const String CategoryViewAll = '/CategoryViewAll';
  static const String productviewmodel = '/ProductViewModel';
  static const String CHECKOUT = '/CheckoutScreen';
  static const String ShoppingCart = '/ShoppingCartScreen';
  static const String MyAccount = "/MyAccountScreen";
  static const String DeliveryAddress = '/DeliveryAddressScreen';
  static const String NOTIFICATION = '/NotificationsScreen';
  static const String COUPON = '/CouponScreen';
  static const String ADDADDRESS = "/AddAddressScreen";
  static const String SUBCATEGORY = '/SubcategoryListPage';
  static const String MYORDERS = '/OrderTabsView';
  static const String SUCCESS = '/OrderConfirmationPage';
  static const String ORDER_DETAILS = '/OrderSummaryScreen';
  static const String GLOBAL_SEARCH = '/GlobalProductList';
  static const String  PROFILE = '/EditProfileScreen';
  static const String Help_Support = '/HelpCenterScreen';
  static const String SLOB = '/SlobScreen';

  // Add more routes as needed

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.SPLASH: (context) => SplashScreen(),
      AppRoutes.LOGIN: (context) => LoginScreen(),
      AppRoutes.VERIFY: (context) => VerifyOtpScreen(),
      AppRoutes.HOME: (context) => HomePage(),
      AppRoutes.VIEWALL: (context) {
        final categories =
            ModalRoute.of(context)!.settings.arguments as List<Category>? ?? [];
        return ViewAllScreen(
            categories: categories); // Pass categories to ViewAllScreen
      },
      AppRoutes.CategoryViewAll: (context) {
        // Extract the arguments passed during navigation
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

// Retrieve categoryId and position from the arguments
        final categoryId = args['categoryId']!;
        final position = args['position']!;

// Pass the categoryId and position to CategoryView
        return CategoryView(categoryId: categoryId, position: position);
      },

      AppRoutes.productviewmodel: (context) => ProductViewmodelScreen(),

      AppRoutes.ShoppingCart: (context) => ShoppingCartScreen(),
      AppRoutes.MyAccount: (context) => MyAccountScreen(),
      AppRoutes.DeliveryAddress: (context) => DeliveryAddressScreen(),

      AppRoutes.ADDADDRESS: (context) => AddAddressScreen(),
      AppRoutes.SUBCATEGORY: (context) {
// Extract arguments from the route settings
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, int>;

// Retrieve categoryId and subcategoryId from the arguments
        final categoryId = args['categoryId']!;
        final searchsubCategory =
            args['searchSubCategory'] ?? ''; // Default to empty string if null

// Pass the arguments to the SubcategoryListPage
        return SubcategoryListPage(
            categoryId: categoryId,
            searchSubCategory: searchsubCategory.toString());
      },
      AppRoutes.MYORDERS: (context) => OrderTabsView(),
      AppRoutes.SUCCESS: (context) {
        // Extract arguments from the route settings
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

        // Retrieve order details and convert if necessary
        final orderId = args['orderId'] is int
            ? args['orderId'].toString()
            : args['orderId'] as String;
        final orderReference = args['orderRefNumber'] as String;
        final totalAmount = args['totalAmount'] as double;
        final totalItems = args['totalItems'] as int;

        // Pass the arguments to the OrderConfirmationPage
        return OrderConfirmationPage(
          orderId: orderId,
          orderReference: orderReference,
          totalAmount: totalAmount,
          totalItems: totalItems,
        );
      },
      AppRoutes.ORDER_DETAILS: (context) => OrderSummaryScreen(),
      AppRoutes.GLOBAL_SEARCH: (context) => GlobalProductList(),
      AppRoutes.PROFILE: (context) => EditProfileScreen(), // Add EditProfileScreen here if needed
      AppRoutes.Help_Support:(context) => HelpCenterScreen(),
      AppRoutes.SLOB: (context) => SlobScreen(), // Add SlobScreen here
      // Define other routes here
    };
  }
}
