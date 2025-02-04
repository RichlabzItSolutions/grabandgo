import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/login_view_model.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller to release resources
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    final height = size.height;
    final width = size.width;

    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Container(
                height: height, // Full screen height
                width: width, // Full screen width
                child: Column(
                  children: [
                    // Image Banner
                    SizedBox(
                      height: height * 0.4, // 40% of screen height
                      width: double.infinity,
                      child: Image.asset(
                        'assets/banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Login Section
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                          width * 0.05, // 5% of screen width for padding
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Login Title
                            Text(
                              AppStrings.login,
                              style: TextStyle(
                                fontSize: width * 0.09, // 9% of screen width
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Manrope',
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            // Login Subtitle
                            Text(
                              AppStrings.pleasenetermobile,
                              style: TextStyle(
                                fontSize: width * 0.04, // 4% of screen width
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            // Mobile Input Field
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/mobile.png',
                                    width: width * 0.05,
                                    height: width * 0.05,
                                  ),
                                ),
                                hintText: AppStrings.enterMobileNumber,
                                hintStyle: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textbg,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: AppColors.backgroundColor,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                  horizontal: width * 0.04,
                                ),
                                counterText: '',
                              ),
                              onChanged: (value) {
                                viewModel.setPhone(value);
                              },
                            ),
                            SizedBox(height: height * 0.03),
                            // Send OTP Button
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () async {
                                  await viewModel.login();
                                  if (viewModel.successMessage != null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            viewModel.successMessage!),
                                        backgroundColor:
                                        AppColors.primaryColor,
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.VERIFY,
                                    );
                                  } else if (viewModel
                                      .errorMessage.isNotEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                        Text(viewModel.errorMessage),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.02,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.sentOtp,
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            // Terms and Conditions
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: AppStrings.byproceed,
                                  style: TextStyle(
                                    fontSize: width * 0.035,
                                    color: Colors.black54,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppStrings.termsAndConditions,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " & ",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text: AppStrings.privacyPolicy,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
