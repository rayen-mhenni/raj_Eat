import 'package:flutter/material.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/models/product_model.dart';
import 'package:raj_eat/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/widgets/product_unit.dart';
import 'package:raj_eat/widgets/single_item.dart';

class WishLsit extends StatefulWidget {
  final WishListProvider wishListProvider;
  WishLsit({required this.wishListProvider});

  @override
  _WishLsitState createState() => _WishLsitState();
}

class _WishLsitState extends State<WishLsit> {
  late WishListProvider wishListProvider;

  @override
  void initState() {
    super.initState();
    wishListProvider = widget.wishListProvider;
    wishListProvider.getWishtListData();
  }

  void showAlertDialog(BuildContext context, ProductModel delete) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        wishListProvider.deleteWishtList(delete.productId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WishList Product"),
      content: Text("Are you delete on wishList Product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WishList",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
      body: Consumer<WishListProvider>(
        builder: (context, wishListProvider, _) {
          // No need to call getWishtListData() here
          return ListView.builder(
            itemCount: wishListProvider.getWishList.length,
            itemBuilder: (context, index) {
              ProductModel data = wishListProvider.getWishList[index];
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SingleItem(
                    isBool: true,
                    productImage: data.productImage,
                    productName: data.productName,
                    productPrice: data.productPrice,
                    productId: data.productId,
                    productQuantity: data.productQuantity,
                    productUnit: ProductUnit(),
                    onDelete: () {
                      showAlertDialog(context, data);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
