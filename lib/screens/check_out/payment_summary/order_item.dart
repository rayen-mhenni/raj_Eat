import 'package:flutter/material.dart';
import 'package:raj_eat/models/review_cart_model.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';

class OrderItem extends StatelessWidget {
  final ReviewCartModel e;
  OrderItem({required this.e});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        e.cartImage,
        width: 60,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            e.cartName,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            e.cartUnit,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            "\D${e.cartPrice}",
          ),
        ],
      ),
      subtitle: Text(e.cartQuantity.toString()),
    );
  }
}