import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryAddressModel {
  DocumentReference? reference;
  String name;
  String firstName;
  String lastName;
  String mobileNo;
  String alternateMobileNo;
  String society;
  String street;
  String landMark;
  String city;
  String area;
  String pinCode;
  String addressType;

  DeliveryAddressModel({
    this.reference,
    required this.addressType,
    required this.area,
    required this.alternateMobileNo,
    required this.city,
    required this.firstName,
    required this.landMark,
    required this.lastName,
    required this.mobileNo,
    required this.pinCode,
    required this.street,
    required this.society,
    required this.name,
  });
}