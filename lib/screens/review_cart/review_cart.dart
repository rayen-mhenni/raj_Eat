import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/models/review_cart_model.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/screens/check_out/delivery_details/delivery_details.dart';
import 'package:raj_eat/widgets/product_unit.dart';
import '../../config/colors.dart';
import '../../widgets/single_item.dart';



class ReviewCart extends StatelessWidget {
  final ReviewCartProvider reviewCartProvider;

  ReviewCart({required this.reviewCartProvider});

  showAlertDialog(BuildContext context, ReviewCartModel delete) {
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
        reviewCartProvider.reviewCartDataDelete(delete.cartId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cart Product"),
      content: Text("Are you sure you want to delete this cart product?"),
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
    // Remove the assignment of reviewCartProvider here
    // reviewCartProvider = Provider.of<ReviewCartProvider>(context); // Remove this line
    // reviewCartProvider.getReviewCartData(); // Remove this line
    return Scaffold(
      bottomNavigationBar: ListTile(
        title: Text("Total Amount"),
        subtitle: Text(
          "\d ${reviewCartProvider.getTotalPrice()}",
          style: TextStyle(
            color: Colors.green[900],
          ),
        ),
        trailing: Container(
          width: 160,
          child: MaterialButton(
            child: Text('submit'),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              if(reviewCartProvider.getReviewCartDataList.isEmpty){
                Fluttertoast.showToast(msg: "No Cart Data Found");
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DeliveryDetails(),
                  ),
                );
              }
            },

          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Review Cart",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
      body: Consumer<ReviewCartProvider>(
        builder: (context, reviewCartProvider, _) {
          reviewCartProvider.getReviewCartData();
          return reviewCartProvider.getReviewCartDataList.isEmpty
              ? Center(
               child: Text("NO DATA"),
          )
              : ListView.builder(
            itemCount: reviewCartProvider.getReviewCartDataList.length,
            itemBuilder: (context, index) {
              ReviewCartModel data =
              reviewCartProvider.getReviewCartDataList[index];
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SingleItem(
                    isBool: true,
                    wishList: false,
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