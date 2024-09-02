import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:raj_eat/models/delivery_address_model.dart';
import 'package:raj_eat/screens/check_out/add_delivery_address/add_delivery_address.dart';

class CheckoutProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController alternateMobileNoController = TextEditingController();
  final TextEditingController societyController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  LocationData? _setLocation;
  LocationData? get setLocation => _setLocation;

  List<DeliveryAddressModel> _deliveryAddressList = [];
  List<DeliveryAddressModel> get deliveryAddressList => _deliveryAddressList;

  // Fetch delivery addresses for the current user
  Future<void> getDeliveryAddressData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection("deliverAddress")
          .where("userId", isEqualTo: userId)
          .get();

      _deliveryAddressList = querySnapshot.docs.map((docSnapshot) {
        final data = docSnapshot.data();
        return DeliveryAddressModel(
          reference: docSnapshot.reference,
          name: data["name"],
          firstName: data["firstname"],
          lastName: data["lastname"],
          addressType: data["addressType"],
          area: data["area"],
          alternateMobileNo: data["alternateMobileNo"],
          city: data["city"],
          landMark: data["landmark"],
          mobileNo: data["mobileNo"],
          pinCode: data["pinCode"],
          society: data["society"],
          street: data["street"],
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load delivery addresses: $e");
    }
  }

  // Validate and add a new delivery address
  Future<void> validateAndAddAddress(BuildContext context, String addressType, DeliveryAddressModel? existedDeliveryAddress) async {
    if (!_validateInputs()) return;

    _setLoading(true);

    try {
      final newData = {
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "name": nameController.text,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "mobileNo": mobileNoController.text,
        "alternateMobileNo": alternateMobileNoController.text,
        "society": societyController.text,
        "street": streetController.text,
        "landmark": landmarkController.text,
        "city": cityController.text,
        "area": areaController.text,
        "pinCode": pinCodeController.text,
        "addressType": addressType,
        "longitude": _setLocation?.longitude,
        "latitude": _setLocation?.latitude,
      };
      if (existedDeliveryAddress != null && existedDeliveryAddress.reference != null) {
        // Update existing address
        final userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.doc(existedDeliveryAddress.reference!.path).update(newData);
        Fluttertoast.showToast(msg: "Address updated successfully");
      } else {
        // Add new address
        await FirebaseFirestore.instance.collection("deliverAddress").add(newData);
        Fluttertoast.showToast(msg: "new delivery address added successfully");
      }
      // Refresh the list of delivery addresses
      await getDeliveryAddressData();
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to add address: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Validate form inputs
  bool _validateInputs() {
    if (firstNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "First name is empty");
      return false;
    } else if (lastNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Last name is empty");
      return false;
    } else if (mobileNoController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Mobile number is empty");
      return false;
    } else if (alternateMobileNoController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Alternate mobile number is empty");
      return false;
    } else if (societyController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Society is empty");
      return false;
    } else if (streetController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Street is empty");
      return false;
    } else if (landmarkController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Landmark is empty");
      return false;
    } else if (cityController.text.isEmpty) {
      Fluttertoast.showToast(msg: "City is empty");
      return false;
    } else if (areaController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Area is empty");
      return false;
    } else if (pinCodeController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Pin code is empty");
      return false;
    } else if (_setLocation == null) {
      Fluttertoast.showToast(msg: "Location is empty");
      return false;
    }
    _setLoading(true);
    return true;
  }

  // Set location data
  void updateLocation(LocationData location) {
    _setLocation = location;
    notifyListeners();
  }

  // Dispose controllers when no longer needed
  @override
  void dispose() {
    nameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNoController.dispose();
    alternateMobileNoController.dispose();
    societyController.dispose();
    streetController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }
  Future<void> editAddress(BuildContext context, DeliveryAddressModel model) async {
    nameController.text = model.name;
    firstNameController.text = model.firstName;
    lastNameController.text = model.lastName;
    mobileNoController.text = model.mobileNo;
    alternateMobileNoController.text = model.alternateMobileNo;
    societyController.text = model.society;
    streetController.text = model.street;
    landmarkController.text = model.landMark;
    cityController.text = model.city;
    areaController.text = model.area;
    pinCodeController.text = model.pinCode;

    // Show the Add/Update address screen with pre-filled data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddDeliverAddress(
          deliveryAddressModel: model, // Pass the model to the screen
          isEditing: true,             // Indicate that this is an edit operation
        ),
      ),
    );
  }
  Future<void> deleteAddress(DeliveryAddressModel deliveryAddressModel) async {
    try {
     await FirebaseFirestore.instance
          .doc(deliveryAddressModel.reference!.path)
          .delete();
        _deliveryAddressList.remove(deliveryAddressModel);
        notifyListeners();
        Fluttertoast.showToast(msg: "Address deleted successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to delete address: $e");
    }
  }
}