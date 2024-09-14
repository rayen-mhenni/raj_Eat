import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String productId;
  final List<String> selectedOptions; // Ajoutez ce champ si ce n'est pas déjà fait
  final double totalPrice;
  final DateTime orderDate; // Ajouté pour la date de commande

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.selectedOptions,
    required this.totalPrice,
    required this.orderDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String userId) {
    return OrderModel(
      orderId: data['cartId'] ?? '',
      userId: userId,
      productId: data['productId'] ?? '',
      selectedOptions: List<String>.from(data['selectedOptions'] ?? []),
      totalPrice: (data['cartPrice'] * data['cartQuantity']).toDouble(),
      orderDate: (data['orderDate'] as Timestamp).toDate(), // Convertir le timestamp en DateTime
    );
  }
}
