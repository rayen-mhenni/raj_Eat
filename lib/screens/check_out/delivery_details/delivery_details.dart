import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/models/delivery_address_model.dart';
import 'package:raj_eat/providers/check_out_provider.dart';
import 'package:raj_eat/screens/check_out/add_delivery_address/add_delivery_address.dart';
import 'package:raj_eat/screens/check_out/delivery_details/single_delivery_item.dart';
import 'package:raj_eat/screens/check_out/payment_summary/payment_summary.dart';

class DeliveryDetails extends StatefulWidget {
  const DeliveryDetails({super.key});

  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  DeliveryAddressModel? selectedValue;

  @override
  void initState() {
    super.initState();
    final deliveryAddressProvider = Provider.of<CheckoutProvider>(context, listen: false);
    deliveryAddressProvider.getDeliveryAddressData();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryAddressProvider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Details"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.maps_home_work),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddDeliverAddress(),
            ),
          );
        },

      ),
      bottomNavigationBar: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: MaterialButton(
          onPressed: () {
            if (selectedValue == null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddDeliverAddress(),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentSummary(
                    deliverAddressList: selectedValue!,
                  ),
                ),
              );
            }
          },
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            selectedValue == null ? "Add new Address" : "Payment Summary",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text("Deliver To"),
          ),
          const Divider(height: 1),
          deliveryAddressProvider.deliveryAddressList.isEmpty
              ? Center(
            child: Container(
              child: const Center(
                child: Text("Please, add a new address"),
              ),
            ),
          )
              : Column(
            children: deliveryAddressProvider.deliveryAddressList
                .map<Widget>((e) {
              return SingleDeliveryItem(
                deliveryAddressModel: e,
                isSelected: selectedValue == e,
                onTap: () {
                  setState(() {
                    selectedValue = e;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


