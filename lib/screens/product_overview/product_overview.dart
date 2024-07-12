import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/providers/wishlist_provider.dart';
import 'package:raj_eat/screens/review_cart/review_cart.dart';
import 'package:raj_eat/widgets/count.dart';

enum SinginCharacter { fill, outline }


class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;

  ProductOverview(
      { this.productImage = '', this.productName = '',this.productPrice = 0, this.productId=''});

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {

  SinginCharacter _character = SinginCharacter.fill;

  Widget bonntonNavigatorBar({
    Color iconColor = Colors.black,
    Color backgroundColor = Colors.white,
    Color color = Colors.black,
    String title  = '',
    IconData iconData = Icons.error,
    Function ()? onTap,
  }) {
    return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
          padding: EdgeInsets.all(20),
              color: backgroundColor,
           child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(
            iconData,
            size: 20,
            color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(color: color),
              ),
            ],
              ),
          ),
        ),
    );
  }

  bool wishListBool = false;

  getWishtListBool() {
    FirebaseFirestore.instance
        .collection("WishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourWishList")
        .doc(widget.productId)
        .get()
        .then((value) => {
      if (this.mounted)
        {
          if (value.exists)
            {
              setState(
                    () {
                  wishListBool = value.get("wishList");
                },
              ),
            }
        }
    });
  }
@override
  Widget build(BuildContext context) {
  WishListProvider wishListProvider = Provider.of(context);
  getWishtListBool();
    return Scaffold(
        bottomNavigationBar: Row(
        children: [
         bonntonNavigatorBar(
         backgroundColor: textColor,
         color: Colors.white70,
         iconColor: Colors.grey,
         title: "Add To WishList",
           iconData: wishListBool==false?Icons.favorite_outline:Icons.favorite,
           onTap: (){
           setState(() {
             wishListBool = !wishListBool;
           });
           if (wishListBool == true) {
             wishListProvider.addWishListData(
               wishListId: widget.productId,
               wishListImage: widget.productImage,
               wishListName: widget.productName,
               wishListPrice: widget.productPrice,
               wishListQuantity: 2,

             );
           } else {
             wishListProvider.deleteWishtList(widget.productId);
           }
           }
        ),
         bonntonNavigatorBar(
         backgroundColor: primaryColor,
         color: textColor,
         iconColor: Colors.white70,
         title: "Go To Cart",
         iconData: Icons.shop_outlined,
           onTap: () {
             Navigator.of(context).push(
               MaterialPageRoute(
                 builder: (context) => Consumer<ReviewCartProvider>(
                   builder: (context, reviewCartProvider, _) => ReviewCart(
                     reviewCartProvider: reviewCartProvider,
                   ),
                 ),
               ),
             );
           }),
      ],
        ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "Product Overview",
          style: TextStyle(color: textColor),
        ),
      ),
     body: Column(
      children: [
      Expanded(
       flex: 2,
       child: Container(
         width: double.infinity,
         child: Column(
             children: [
               ListTile(
                 title: Text(widget.productName),
                 subtitle: Text("\D${widget.productPrice}"),
               ),
          Container(
            height: 250,
            padding: EdgeInsets.all(40),
            child: Image.network(
              widget.productImage??"",
            )
       ),
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 width: double.infinity,
                 child: Text(
                   "Available Options",
                   textAlign: TextAlign.start,
                   style: TextStyle(
                     color: textColor,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
               Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Row(
                children: [
                CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.green[700],
            ),
               Radio(
                 value: SinginCharacter.fill,
                 groupValue: _character,
                 activeColor: Colors.green[700],
                onChanged: (SinginCharacter? value) {
                 setState(() {
                   if (value != null) {
                     _character = value;
                   }
                });
                },
            ),
            ],
              ),
                  Text("Salad Mechwiya"),
                  Count(
                    productId: widget.productId,
                    productImage: widget.productImage,
                    productName: widget.productName,
                    productPrice: widget.productPrice,
                    productUnit: ' Gram',

                  ),

                ],
            ),
          ),
               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         CircleAvatar(
                           radius: 3,
                           backgroundColor: Colors.green[700],
                         ),
                         Radio(
                           value: SinginCharacter.fill,
                           groupValue: _character,
                           activeColor: Colors.green[700],
                           onChanged: (SinginCharacter? value) {
                             setState(() {
                               if (value != null) {
                                 _character = value;
                               }
                             });
                           },
                         ),
                       ],
                     ),
                     Text("Oignons"),
                     Count(
                       productId: widget.productId,
                       productImage: widget.productImage,
                       productName: widget.productName,
                       productPrice: widget.productPrice,
                       productUnit: ' Gram',
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         CircleAvatar(
                           radius: 3,
                           backgroundColor: Colors.green[700],
                         ),
                         Radio(
                           value: SinginCharacter.fill,
                           groupValue: _character,
                           activeColor: Colors.green[700],
                           onChanged: (SinginCharacter? value) {
                             setState(() {
                               if (value != null) {
                                 _character = value;
                               }
                             });
                           },
                         ),
                       ],
                     ),
                     Text("Salad"),

                     Count(
                       productId: widget.productId,
                       productImage: widget.productImage,
                       productName: widget.productName,
                       productPrice: widget.productPrice,
                       productUnit: ' Gram',
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: 10,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         CircleAvatar(
                           radius: 3,
                           backgroundColor: Colors.green[700],
                         ),
                         Radio(
                           value: SinginCharacter.fill,
                           groupValue: _character,
                           activeColor: Colors.green[700],
                           onChanged: (SinginCharacter? value) {
                             setState(() {
                               if (value != null) {
                                 _character = value;
                               }
                             });
                           },
                         ),
                       ],
                     ),
                     Text("Tomatoes"),
                     Count(
                       productId: widget.productId,
                       productImage: widget.productImage,
                       productName: widget.productName,
                       productPrice: widget.productPrice,
                       productUnit: ' Gram',
                     ),
                     
                   ],
                 ),
               ),


             ],
         ),
       ),
     ),


      ],
     ),


    );
  }
}