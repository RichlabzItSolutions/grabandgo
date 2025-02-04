import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/viewmodel/AddressViewModel.dart';
import 'package:hygi_health/viewmodel/CartProvider.dart';
import 'package:hygi_health/viewmodel/base_view_%20model.dart';
import 'package:hygi_health/viewmodel/category_view_model.dart';
import 'package:hygi_health/viewmodel/delivery_address_viewmodel.dart';
import 'package:hygi_health/viewmodel/help_center_viewmodel.dart';
import 'package:hygi_health/viewmodel/location_view_model.dart';
import 'package:hygi_health/viewmodel/myaccount_view_Model.dart';
import 'package:hygi_health/viewmodel/notification_viewmodel.dart';
import 'package:hygi_health/viewmodel/order_summary_viewModel.dart';
import 'package:hygi_health/viewmodel/order_view_model.dart';
import 'package:hygi_health/viewmodel/product_view_model.dart';
import 'package:hygi_health/viewmodel/profile_view_model.dart';
import 'package:hygi_health/viewmodel/shopping_cart_view_model.dart';
import 'package:hygi_health/viewmodel/slide_view_model.dart';
import 'package:hygi_health/viewmodel/slob_viewmodel.dart';
import 'package:hygi_health/viewmodel/subcategory_view_model.dart';
import 'package:hygi_health/viewmodel/verify_otp_view_model.dart';
import 'routs/Approuts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => BaseViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => VerifyOtpViewModel()),
        ChangeNotifierProvider(create: (_) => ShoppingCartViewModel()),
        ChangeNotifierProvider(create: (_) => MyAccountViewModel()),
        ChangeNotifierProvider(create: (_) => DeliveryViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => SliderViewModel()),
        ChangeNotifierProvider(create: (_) => AddressViewModel()),
        ChangeNotifierProvider(create: (_) => SubcategoryViewModel()),
        ChangeNotifierProvider(create: (_) =>OrderViewModel()),
        ChangeNotifierProvider(create: (_) =>LocationViewModel()),
        ChangeNotifierProvider(create: (_) =>OrderSummaryViewModel()),
        ChangeNotifierProvider(create: (_) =>CartProvider()),
        ChangeNotifierProvider(create: (_) =>ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => HelpCenterViewModel()),
        ChangeNotifierProvider(create: (_) => SlobViewModel()),


        // Add other providers here if needed
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        fontFamily: 'Manrope',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}


