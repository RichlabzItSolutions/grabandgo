import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../viewmodel/help_center_viewmodel.dart';

class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<HelpCenterViewModel>(context, listen: false);
    viewModel.fetchHelpCenterDetails();
  }

  // Function to make a phone call with permission handling
  Future<void> _makePhoneCall(String phoneNumber) async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      final Uri phoneUri = Uri.parse("tel:$phoneNumber");
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        print('Could not launch phone call');
      }
    } else {
      print('Phone call permission denied');
    }
  }

  // Function to send an email
  Future<void> _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {'subject': 'Help & Support Inquiry'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HelpCenterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
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
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Input
            TextField(
              controller: viewModel.subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Message Input
            TextField(
              controller: viewModel.messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () async {
                await viewModel.submitForm(context);
                viewModel.subjectController.clear();
                viewModel.messageController.clear();
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Details Section
            if (viewModel.helpCenter != null) ...[
              const SizedBox(height: 16),

              // Email Section
              GestureDetector(
                onTap: () => _sendEmail(viewModel.helpCenter!.email),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.helpCenter!.email,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number Section
              GestureDetector(
                onTap: () => _makePhoneCall(viewModel.helpCenter!.mobile),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.helpCenter!.mobile,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Address Section

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Ensures both are aligned
                children: [
                  const Icon(Icons.location_on, color: Colors.black),
                  const SizedBox(width: 8),
                  Flexible( // Ensures the text wraps properly instead of overflowing
                    child: Text(
                      viewModel.helpCenter?.address ?? "No Address Available", // Handle null safety
                      textAlign: TextAlign.center, // Centers the text
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )


            ],
          ],
        ),
      ),
    );
  }
}
