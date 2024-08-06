import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/models/review_cart_model.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/screens/check_out/delivery_details/delivery_details.dart';
import '../../config/colors.dart';
import '../../widgets/single_item.dart';

class MyOrder extends StatelessWidget {
  const MyOrder({super.key});

  void showAlertDialog(BuildContext context, ReviewCartModel delete) {
    // Set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Provider.of<ReviewCartProvider>(context, listen: false)
            .reviewCartDataDelete(delete.cartId);
        Navigator.of(context).pop();
      },
    );

    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Cart Product"),
      content: const Text("Are you sure you want to delete this cart product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 0, // Set height to 0 or remove this widget if you don't want any BottomAppBar
      ),
      appBar: AppBar(
        title: Text(
          "My Order",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
      body: Consumer<ReviewCartProvider>(
        builder: (context, reviewCartProvider, _) {
          reviewCartProvider.getReviewCartData(); // Fetch data here if needed
          return reviewCartProvider.getReviewCartDataList.isEmpty
              ? const Center(
            child: Text("NO DATA"),
          )
              : ListView.builder(
            itemCount: reviewCartProvider.getReviewCartDataList.length,
            itemBuilder: (context, index) {
              ReviewCartModel data = reviewCartProvider.getReviewCartDataList[index];
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SingleItem(
                    isBool: true,
                    wishList: true,
                    productImage: data.cartImage,
                    productPrice: data.cartPrice,
                    productName: data.cartName,
                    productId: data.cartId,
                    productQuantity: data.cartQuantity,
                    productUnit: data.cartUnit,
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
