import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String productId;
  final List<String> selectedOptions; // Ajoutez ce champ si ce n'est pas déjà fait
  final double totalPrice;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.selectedOptions,
    required this.totalPrice,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String userId) {
    return OrderModel(
      orderId: data['cartId'] ?? '',
      userId: userId,
      productId: data['productId'] ?? '',
      selectedOptions: List<String>.from(data['selectedOptions'] ?? []),
      totalPrice: (data['cartPrice'] * data['cartQuantity']).toDouble(),
    );
  }
}
