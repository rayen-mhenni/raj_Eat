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

  const PaymentSummary({super.key, required this.deliverAddressList});

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
    ReviewCartProvider reviewCartProvider = Provider.of(context);
    reviewCartProvider.getReviewCartData();
    double discount = 30;
    double discountValue = 0;
    double shippingCharge = 3.7;

    double totalPrice = reviewCartProvider.getTotalPrice();
    print(totalPrice);
    double total = totalPrice;
    if (totalPrice > 300) {
      discountValue = (totalPrice * discount) / 100;
      total = totalPrice - discountValue;
    }

    void placeOrder() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Order Confirmation"),
            content: const Text("Your order has been placed successfully."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
          "D${total + shippingCharge}",
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
                placeOrder();
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
                  deliveryAddressModel: widget.deliverAddressList,
                  isSelected: false,
                  onTap: () {},
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
                    "D${totalPrice + shippingCharge}",
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
                ), discountValue > 0 ?
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Compen Discount",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "D{$discountValue}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ): const Divider(),
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
                    Icons.payment,
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
