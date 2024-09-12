import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/models/delivery_address_model.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:raj_eat/screens/check_out/delivery_details/single_delivery_item.dart';
import 'package:raj_eat/screens/check_out/payment_summary/my_google_pay.dart';
import 'package:raj_eat/screens/check_out/payment_summary/order_item.dart';

class PaymentSummary extends StatefulWidget {
  final DeliveryAddressModel deliverAddressList;
  final Map<String, bool> selectedOptions;

  const PaymentSummary({
    Key? key,
    required this.deliverAddressList,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

enum AddressTypes {
  Home,
  OnlinePayment,
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var myType = AddressTypes.Home;




  @override
  Widget build(BuildContext context) {
    ReviewCartProvider reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    reviewCartProvider.getReviewCartData();

    double discount = 30;
    double discountValue = 0;
    double shippingCharge = 3.7;

    double totalPrice = reviewCartProvider.getTotalPrice();
    double total = totalPrice + shippingCharge; // Include shipping charge in total

    if (totalPrice > 300) {
      discountValue = (totalPrice * discount) / 100;
      total = totalPrice - discountValue + shippingCharge; // Apply discount and add shipping charge
    }

    Future<void> placeOrder({
      required String firstName,
      required String lastName,
      required String cartName,
      required Map<String, bool> selectedOptions,
      required double totalAmount,
      required String userId,
    }) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Firestore logic for adding the order to different collections
          await FirebaseFirestore.instance.collection('AddDeliverAddress').add({
            'firstname': widget.deliverAddressList.firstName,
            'lastname': widget.deliverAddressList.lastName,
            'userId': user.uid,
          });

          DocumentReference reviewCartRef = await FirebaseFirestore.instance.collection('ReviewCart').add({
            'cartName': cartName,
            'userId': user.uid,
            'totalAmount': total,
          });

          // Update the Products collection with selected options
          await FirebaseFirestore.instance.collection('UserSelections').doc(user.uid).collection('Products').add({
            'productId': 'your-product-id', // Replace with actual product ID
            'selectedOptions': selectedOptions,
          });

          await FirebaseFirestore.instance.collection('order').doc(user.uid).set({
            "firstname": firstName,
            "lastName": lastName,
            "cartName": cartName,
            "selectedOptions": selectedOptions,
            "totalAmount": totalAmount,
            "userId": user.uid,
          });

          // Show order confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Order Confirmation"),
                content: Text("Your order has been placed successfully."),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print('Error placing order: $e');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Summary",
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: ListTile(
        title: const Text("Total Amount"),
        subtitle: Text(
          "D${total}",
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        trailing: SizedBox(
          width: 160,
          child: MaterialButton(
            onPressed: () {
              if (myType == AddressTypes.OnlinePayment) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyGooglePay(total: total),
                  ),
                );
              } else {
                String cartName = reviewCartProvider.getReviewCartDataList
                    .map((e) => e.cartName)
                    .join(", ");

                placeOrder(
                  firstName: widget.deliverAddressList.firstName,
                  lastName: widget.deliverAddressList.lastName,
                  cartName: cartName,
                  selectedOptions: widget.selectedOptions,
                  totalAmount: total,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                );
              }
            },
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Place Order",
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SingleDeliveryItem(
                  address:
                  "Area, ${widget.deliverAddressList.area}, Street, ${widget.deliverAddressList.street}, Society ${widget.deliverAddressList.society}, Pincode ${widget.deliverAddressList.pinCode}",
                  title:
                  "${widget.deliverAddressList.firstName} ${widget.deliverAddressList.lastName}",
                  number: widget.deliverAddressList.mobileNo,
                  addressType: widget.deliverAddressList.addressType == "AddressTypes.Home"
                      ? "Home"
                      : widget.deliverAddressList.addressType == "AddressTypes.Other"
                      ? "Other"
                      : "Work",
                ),
                const Divider(),

                ExpansionTile(
                  title: Text(
                      "Order Items (${reviewCartProvider.getReviewCartDataList.length})"),
                  children: reviewCartProvider.getReviewCartDataList.map((e) {
                    return OrderItem(
                      e: e,
                    );
                  }).toList(),
                ),
                const Divider(),
                ListTile(
                  minVerticalPadding: 5,
                  leading: const Text(
                    "Sub Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "D${totalPrice}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Shipping Charge",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "D$shippingCharge",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Discount",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "D$discountValue",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                const ListTile(
                  leading: Text("Payment Options"),
                ),
                RadioListTile(
                  value: AddressTypes.Home,
                  groupValue: myType,
                  title: const Text("Home"),
                  onChanged: (AddressTypes? value) {
                    setState(() {
                      myType = value!;
                    });
                  },
                  secondary: Icon(
                    Icons.home,
                    color: primaryColor,
                  ),
                ),
                RadioListTile(
                  value: AddressTypes.OnlinePayment,
                  groupValue: myType,
                  title: const Text("Online Payment"),
                  onChanged: (AddressTypes? value) {
                    setState(() {
                      myType = value!;
                    });
                  },
                  secondary: Icon(
                    Icons.credit_card,
                    color: primaryColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
