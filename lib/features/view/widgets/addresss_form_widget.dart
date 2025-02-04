import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/data/model/DeliveryAddress.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/AddressViewModel.dart';

class AddressFormWidget extends StatefulWidget {
  final DeliveryAddress? address;

  AddressFormWidget({Key? key, this.address}) : super(key: key);

  @override
  _AddressFormWidgetState createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileController;
  late TextEditingController _cityController;
  late TextEditingController _areaController;
  late TextEditingController _pincodeController;
  late TextEditingController _addressController;
  late TextEditingController _landmarkController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _mobileController = TextEditingController();
    _cityController = TextEditingController();
    _areaController = TextEditingController();
    _pincodeController = TextEditingController();
    _addressController = TextEditingController();
    _landmarkController = TextEditingController();

    if (widget.address != null) {
      _firstNameController.text = widget.address!.firstName;
      _lastNameController.text = widget.address!.lastName;
      _mobileController.text = widget.address!.mobile;
      _cityController.text = widget.address!.city;
      _areaController.text = widget.address!.area;
      _pincodeController.text = widget.address!.pincode.toString();
      _addressController.text = widget.address!.address;
      _landmarkController.text = widget.address!.landmark ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddressViewModel>(context);

    if (widget.address != null && !viewModel.isInitialized) {
      // Only initialize once
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initializeWithAddress(widget.address!);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.availableStates.isEmpty) {
        viewModel.loadStates();
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildExpandedTextField(AppStrings.firstName,
                      _firstNameController, viewModel.updateFirstName),
                  const SizedBox(width: 16),
                  _buildExpandedTextField(AppStrings.lastName,
                      _lastNameController, viewModel.updateLastName),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: AppStrings.mobile,
                controller: _mobileController,
                onChanged: viewModel.updateMobileNumber,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterMobileNumber;
                  }
                  if (value.length != 10) {
                    return AppStrings.pleaseEnterValidMobileNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "City",
                controller: _cityController,
                onChanged: viewModel.updateCity,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: AppStrings.area,
                controller: _areaController,
                onChanged: viewModel.updateArea,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterArea;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: AppStrings.pincode,
                controller: _pincodeController,
                onChanged: viewModel.updatePincode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterPincode;
                  }
                  if (value.length != 6) {
                    return AppStrings.pleaseenterPincode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: AppStrings.apartMentorHouseNo,
                controller: _addressController,
                onChanged: viewModel.updateApartmentNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterApartMentHouseNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: AppStrings.landmark,
                controller: _landmarkController,
                onChanged: viewModel.updateLandmark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterLandmark;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // In AddressFormWidget's build method
              Consumer<AddressViewModel>(builder: (context, viewModel, child) {
                if (viewModel.availableStates.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField<String>(
                  value: viewModel.selectedState.isEmpty
                      ? null
                      : viewModel.selectedState,
                  hint: const Text("Select State"),
                  items: viewModel.availableStates.map((state) {
                    final stateName = state['stateName'];
                    return DropdownMenuItem<String>(
                        value: stateName, child: Text(stateName));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final state = viewModel.availableStates
                          .firstWhere((state) => state['stateName'] == value);
                      final stateId = state['stateId'];
                      viewModel.updateSelectedState(
                          value, stateId); // Ensure state is updated here
                    }
                  },
                  decoration:
                      const InputDecoration(labelText: AppStrings.state),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.pleaseenterState;
                    }
                    return null;
                  },
                );
              }),

              const SizedBox(height: 16),
              Row(
                children: [
                  _buildAddressTypeButton(context, "Home", 1),
                  _buildAddressTypeButton(context, "Office", 2),
                  _buildAddressTypeButton(context, "Other", 3),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: viewModel.address.isDefault,
                onChanged: (value) => viewModel.toggleDefaultAddress(value!),
                title: const Text(AppStrings.defaultAddress),
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.address == null) {
                        viewModel.saveAddress(context);
                      } else {
                        viewModel.editAddress(context, widget.address!);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white
                  ),
                  child: Text(widget.address == null
                      ? AppStrings.saveAddress
                      : AppStrings.updateAdress),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text field widgets
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      // Ensure the controller is passed here
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor)),
      ),
    );
  }

  // Helper method to create the text field for first and last name with underline
  Widget _buildExpandedTextField(String label, TextEditingController controller,
      Function(String) onChanged) {
    return Expanded(
      child: TextFormField(
        controller: controller, // Ensure controller is passed here too
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAddressTypeButton(
      BuildContext context, String type, int typeID) {
    final viewModel = Provider.of<AddressViewModel>(context, listen: false);
    final isSelected = viewModel.selectedAddressType == type;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          viewModel.updateAddressType(
              type, typeID); // Update the address type here
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          side: BorderSide(color: isSelected ? Colors.green : Colors.grey),
        ),
        child: Text(type),
      ),
    );
  }
}
