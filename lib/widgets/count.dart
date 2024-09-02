import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/providers/cart_provider.dart';
import 'package:raj_eat/screens/product_overview/product_overview.dart';

import '../config/colors.dart';
class Count extends StatefulWidget {
  final String productName;
  final String productImage;
  final String productId;
  final int productPrice;

  Count({super.key,
    required  this.productName,
    required  this.productId,
    required  this.productImage,
    required  this.productPrice,
  });

  @override
  _CountState createState() => _CountState();
}

class _CountState extends State<Count> {
  int count = 1;
  bool isTrue = false;

  getAddAndQuantity() {
    FirebaseFirestore.instance
        .collection("ReviewCart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourReviewCart")
        .doc(widget.productId)
        .get()
        .then(
          (value) => {
        if (mounted)
          {
            if (value.exists)
              {
                setState(() {
                  count = value.get("cartQuantity");
                  isTrue = value.get("isAdd");
                })
              }
          }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    getAddAndQuantity();
    CartProvider cartProvider = Provider.of(context);
    return Container(
        height: 30,
        width: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)
        ),
        child: isTrue == true
            ?Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                if (count == 1){
                  setState(() {
                    isTrue = false;
                  });
                  cartProvider.deleteProductInCart(productId: widget.productId);
                }

                else if (count > 1){
                  setState(() {
                  count --;
                });
                cartProvider.updateProductInCart(
                  productId: widget.productId,
                  quantity: count,

                );
                }
              },
              child:
              const Icon(Icons.remove,size: 15,color: Color(0xffd0b84c)),
            ),
            Text(
              "$count",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  count ++;
                });
                cartProvider.updateProductInCart(
                  productId: widget.productId,
                  quantity: count,
                );
              },
              child:
              const Icon(Icons.add,size: 15,color: Color(0xffd0b84c),
              ),
            ),

          ],
        ):Center(
          child: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductOverview(
                  productId: widget.productId,
                  productPrice: widget.productPrice.toInt(),
                  productName: widget.productName,
                  productImage: widget.productImage,
                ),
              ));
            },
            child: Text(
              "ADD",
              style: TextStyle(color: primaryColor),
            ),
          ),
        )
    );
  }
}