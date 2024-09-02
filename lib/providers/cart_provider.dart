import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:raj_eat/models/cartProduct.dart';
import 'package:raj_eat/models/product_option_model.dart';
import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  List<CartProduct> listCartProduct = [];

  void addProductToCart({
    required String productId,
    required int quantity,
    required List<ProductOption> productOptions,
    required int price,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CartProduct cartProduct = CartProduct(
        productId: productId,
        productOptions: productOptions,
        quantity: quantity,
        price: price,
      );

      DocumentReference cartRef = FirebaseFirestore.instance.collection("carts").doc(user.uid);

      await cartRef.set(
        {
          "userId": user.uid,
          "products": FieldValue.arrayUnion([
            {
              "productId": cartProduct.productId,
              "quantity": cartProduct.quantity,
              "options": cartProduct.productOptions,
              "price": cartProduct.price,
            }
          ]),
        },
        SetOptions(merge: true),
      );
    }
  }

  void updateProductInCart({
    required String productId,
    required int quantity,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference cartRef =
      FirebaseFirestore.instance.collection("carts").doc(user.uid);

      // Fetch current cart data
      DocumentSnapshot cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        List<dynamic> products = cartSnapshot.get("products");
        for (var product in products) {
          if (product["productId"] == productId) {
            product["quantity"] = quantity;
          }
        }

        // Update the cart with the modified products list
        await cartRef.update({
          "products": products,
        });
      }
    }
  }
  void deleteProductInCart({
    required String productId,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference cartRef =
      FirebaseFirestore.instance.collection("carts").doc(user.uid);

      // Fetch current cart data
      DocumentSnapshot cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        List<dynamic> products = cartSnapshot.get("products");
        for (var product in products) {
          if (product["productId"] == productId) {
            products.remove(product);
          }
        }

        // Update the cart with the modified products list
        await cartRef.update({
          "products": products,
        });
      }
    }
  }

  void getCartProductData() async {
    List<CartProduct> newList = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot cartSnapshot =
      await FirebaseFirestore.instance.collection("carts").doc(user.uid).get();
      if (cartSnapshot.exists) {
        List<dynamic> products = cartSnapshot.get("products");
        for (var element in products) {
          CartProduct cartProduct = CartProduct(
            productId: element["productId"],
            quantity: element["quantity"],
            productOptions: element["productOptions"],
            price: element["price"],
          );
          newList.add(cartProduct);
        }
      }
      listCartProduct = newList;
    }
  }
  List<CartProduct> get getCartProductList {
    return listCartProduct;
  }


  Future<Cart?> getCartData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    DocumentSnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection("carts")
        .doc(user.uid)
        .get();

    if (cartSnapshot.exists) {
      List<CartProduct> products = [];
      int totalPrice = 0;

      // Assuming cartSnapshot contains a list of products
      for (var product in cartSnapshot['products']) {
        CartProduct cartProduct = CartProduct(
          productId: product['productId'],
          quantity: product['quantity'],
          productOptions: product['productOptions'],
          price: product['price'],
        );
        products.add(cartProduct);
        totalPrice += cartProduct.price * cartProduct.quantity;
      }

      return Cart(
        userId: user.uid,
        products: products,
      );
    }

    return null;
  }
}
