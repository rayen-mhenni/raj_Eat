import 'package:pay/pay.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MyGooglePay extends StatefulWidget {
  final total;
  MyGooglePay({this.total});
  @override
  _MyGooglePayState createState() => _MyGooglePayState();
}

class _MyGooglePayState extends State<MyGooglePay> {
  PaymentConfiguration? _paymentConfiguration;

  @override
  void initState() {
    super.initState();
    loadPaymentConfiguration();
  }

  void loadPaymentConfiguration() async {
    String configString =
    await rootBundle.loadString('assets/sample_payment_configuration.json');
    setState(() {
      _paymentConfiguration = PaymentConfiguration.fromJsonString(configString);
    });
  }

  void onGooglePayResult(paymentResult) {
    print(paymentResult);
    // Send the resulting Google Pay token to your server or PSP
  }

  @override
  Widget build(BuildContext context) {
    if (_paymentConfiguration == null) {
      return Center(child: CircularProgressIndicator());
    }

    return GooglePayButton(
      paymentConfiguration: _paymentConfiguration!,
      paymentItems: [
        PaymentItem(
          label: 'Total',
          amount: '${widget.total}',
          status: PaymentItemStatus.final_price,
        )
      ],
      type: GooglePayButtonType.pay,
      onPaymentResult: onGooglePayResult,
    );
  }
}
