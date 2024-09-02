import 'package:cloud_firestore/cloud_firestore.dart';

import 'cartProduct.dart';
import 'delivery_address_model.dart';

class OrderModel {
  final DocumentReference? reference;
  final String userId;
  final List<CartProduct> products;
  final DeliveryAddressModel address;
  final List<String> selectedOptions;
  final double totalPrice;

  OrderModel({
    this.reference,
    required this.userId,
    required this.products,
    required this.address,
    required this.selectedOptions,
    required this.totalPrice,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String userName) {
    return OrderModel(
      reference: data['reference'],
      userId: data['userId'],
      address: data['address'],
      products: List<CartProduct>.from(data['products'] ?? []),
      selectedOptions: List<String>.from(data['selectedOptions'] ?? []),
      totalPrice: data['totalPrice'],
    );
  }
}
