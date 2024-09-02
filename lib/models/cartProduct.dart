
import 'package:raj_eat/models/product_option_model.dart';

class CartProduct {
  final String productId;
  final List<ProductOption> productOptions;
  final int quantity;
  final int price; // Price of one unit of the product

  CartProduct({
    required this.productId,
    required this.quantity,
    required this.productOptions,
    required this.price,
  });

  int get totalPrice => price * quantity;
}
