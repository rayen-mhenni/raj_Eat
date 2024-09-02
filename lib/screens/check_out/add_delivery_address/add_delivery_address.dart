import 'package:flutter/material.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/providers/check_out_provider.dart';
import 'package:raj_eat/screens/check_out/google_map/google_map.dart';
import 'package:raj_eat/widgets/custom_text_field.dart';

import '../../../models/delivery_address_model.dart';

class AddDeliverAddress extends StatefulWidget {
  final DeliveryAddressModel? deliveryAddressModel;
  final bool isEditing;
  const AddDeliverAddress({super.key, this.deliveryAddressModel, this.isEditing = false});

  @override
  _AddDeliverAddressState createState() => _AddDeliverAddressState();
}

enum AddressTypes {
  Home,
  Work,
  Other,
}
class _AddDeliverAddressState extends State<AddDeliverAddress> {
  var myType = AddressTypes.Home;
  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.deliveryAddressModel != null) {
      // Pre-fill the fields with existing data
      final model = widget.deliveryAddressModel!;
      final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
      checkoutProvider.nameController.text = model.name;
      checkoutProvider.firstNameController.text = model.firstName;
      checkoutProvider.lastNameController.text = model.lastName;
      checkoutProvider.mobileNoController.text = model.mobileNo;
      checkoutProvider.alternateMobileNoController.text = model.alternateMobileNo;
      checkoutProvider.societyController.text = model.society;
      checkoutProvider.streetController.text = model.street;
      checkoutProvider.landmarkController.text = model.landMark;
      checkoutProvider.cityController.text = model.city;
      checkoutProvider.areaController.text = model.area;
      checkoutProvider.pinCodeController.text = model.pinCode;
      myType = AddressTypes.values.firstWhere((type) => type.toString() == model.addressType);
    }
  }
  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Update Address" : "Add new Delivery Address",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    bottomNavigationBar: Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    height: 48,
    child: checkoutProvider.isLoading == false
        ? MaterialButton(
      onPressed: () {
        checkoutProvider.validateAndAddAddress(context, myType.toString(), widget.deliveryAddressModel);
      },
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
        child: Text(
          widget.isEditing ? "Update Address" : "Add new Delivery Address",
        style: TextStyle(
          color: textColor,
        ),
      ),

    ):const Center(
      child: CircularProgressIndicator(),
    ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
    child: ListView(
        children: [
      CustomTextField(
        labText: "name",
        controller: checkoutProvider.nameController,
      ),
      CustomTextField(
        labText: "First name",
        controller: checkoutProvider.firstNameController,
      ),
          CustomTextField(
            labText: "Last name",
            controller: checkoutProvider.lastNameController,
          ),
          CustomTextField(
            labText: "Mobile No",
            controller: checkoutProvider.mobileNoController,
          ),
          CustomTextField(
            labText: "Alternate Mobile No",
            controller: checkoutProvider.alternateMobileNoController,
          ),
          CustomTextField(
            labText: "society",
            controller: checkoutProvider.societyController,
          ),
          CustomTextField(
            labText: "Street",
            controller: checkoutProvider.streetController,
          ),
          CustomTextField(
            labText: "Landmark",
            controller: checkoutProvider.landmarkController,
          ),
          CustomTextField(
            labText: "City",
            controller: checkoutProvider.cityController,
          ),
          CustomTextField(
            labText: "Area",
            controller: checkoutProvider.areaController,
          ),
          CustomTextField(
            labText: "Pincode",
            controller: checkoutProvider.pinCodeController,
          ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CostomGoogleMap(),
            ),
          );

        },
        child: SizedBox(
          height: 47,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkoutProvider.setLocation == null? const Text("Set Location"):
              const Text("Done!"),
            ],
          ),
        ),
      ),
          const Divider(
            color: Colors.black,
          ),
          const ListTile(
            title: Text("Address Type*"),
          ),
      RadioListTile(
        value: AddressTypes.Home,
        groupValue: myType,
          title: const Text("Home"),
        onChanged: (AddressTypes? value) {
          setState(() {
            myType = value!;
          });
        },
        secondary: Icon(
          Icons.home,
          color: primaryColor,
        ),
      ),
          RadioListTile(
            value: AddressTypes.Work,
            groupValue: myType,
            title: const Text("Work"),
            onChanged: (AddressTypes? value) {
              setState(() {
                myType = value!;
              });
            },
            secondary: Icon(
              Icons.work,
              color: primaryColor,
            ),
          ),
      RadioListTile(
        value: AddressTypes.Other,
        groupValue: myType,
        title: const Text("Other"),
        onChanged: (AddressTypes? value) {
          setState(() {
            myType = value!;
          });
        },
        secondary: Icon(
          Icons.devices_other,
          color: primaryColor,
        ),
      ),
        ],
    ),
    ),
    );
  }
}