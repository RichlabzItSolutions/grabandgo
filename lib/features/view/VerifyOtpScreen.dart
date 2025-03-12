import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart'; // Import your AppRoutes file
import '../../viewmodel/verify_otp_view_model.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';

class VerifyOtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    final height = size.height;
    final width = size.width;

    return ChangeNotifierProvider(
      create: (context) => VerifyOtpViewModel(),
      child: Scaffold(
        body: Consumer<VerifyOtpViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Container(
                height: height, // Full screen height
                width: width, // Full screen width
                child: Column(
                  children: [
                    // Banner Image
                    SizedBox(
                      height: height * 0.4, // 40% of screen height
                      width: double.infinity,
                      child: Image.asset(
                        'assets/banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: height * 0.02), // Spacing

                    // Title and Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.verifyOtp,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: width * 0.07, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            AppStrings.enterOtp,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: width * 0.045,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.03),

                    // OTP Input Fields
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          4,
                          (index) => SizedBox(
                            width: width * 0.15, // Proportional width
                            height: width * 0.15, // Proportional height
                            child: TextField(
                              controller: viewModel.controllers[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                // Removes the border line
                                enabledBorder: InputBorder.none,
                                // Removes the enabled border line
                                focusedBorder: InputBorder.none,
                                // Removes the focused border line
                                filled: true,
                                // fillColor: AppColors.backgroundColor, // Optional: Uncomment to add background color
                              ),
                              onChanged: (value) {
                                if (!context.mounted) return;
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },

                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.03),

                    // Timer or Resend Link
                    viewModel.canResend
                        ? GestureDetector(
                            onTap: () async {
                              await viewModel.handleResend(context);
                            },
                            child: Text.rich(
                              TextSpan(
                                text: AppStrings.dontreciveOtp,
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: AppStrings.resendOtp,
                                    style: TextStyle(
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Text(
                            viewModel.formatTime(viewModel.start),
                            style: TextStyle(
                              fontSize: width * 0.045,
                              color: Colors.black,
                            ),
                          ),
                    SizedBox(height: height * 0.03),

                    // Verify OTP Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await viewModel.verifyOtp(context);
                            if (!context.mounted)
                              return; // Check if the widget is still in the tree/**/
                            if (viewModel.isOtpVerified) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.HOME);
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
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),

                    // Error Message Placeholder (if needed)
                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * 0.04,
                        ),
                        textAlign: TextAlign.center,
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
