import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cartProduct.dart';

class Cart {
  final String userId;
  final List<CartProduct> products;

  Cart({
    required this.userId,
    required this.products,
  });

  int get totalPrice {
    int total = 0;
    for (var product in products) {
      total += product.totalPrice;
    }
    return total;
  }
}
