import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/data/model/update_address.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:hygi_health/features/view/widgets/addresss_form_widget.dart';
import 'package:provider/provider.dart';

import '../../data/model/DeliveryAddress.dart';
import '../../viewmodel/AddressViewModel.dart';

class AddAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the address passed via arguments
    final DeliveryAddress? address =
        ModalRoute.of(context)!.settings.arguments as DeliveryAddress?;

    bool isEditing = address != null;

    return BaseScreen(
      title: isEditing ? AppStrings.editAddress : AppStrings.addAddress,
      showCartIcon: false,
      showShareIcon: false,
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => AddressViewModel()
            ..initializeWithAddress(address), // Pass address if editing
          child: Consumer<AddressViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: AddressFormWidget(
                    address: address), // Pass address to the form widget
              );
            },
          ),
        ),
      ),
    );
  }
}
