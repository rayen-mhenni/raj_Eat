import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/config/colors.dart';
import '../../../models/delivery_address_model.dart';
import '../../../providers/check_out_provider.dart';

class SingleDeliveryItem extends StatelessWidget {
  final DeliveryAddressModel deliveryAddressModel;
  final bool isSelected;
  final VoidCallback onTap;

  const SingleDeliveryItem(
      {super.key,
      required this.deliveryAddressModel,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(deliveryAddressModel.name),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.all(1),
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        deliveryAddressModel.addressType
                            .toString()
                            .split('.')
                            .last,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              leading: CircleAvatar(
                radius: 8,
                backgroundColor: isSelected ? Colors.green : primaryColor,
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${deliveryAddressModel.firstName} ${deliveryAddressModel.lastName}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("${deliveryAddressModel.area} ${deliveryAddressModel.city}"),
                  Text(deliveryAddressModel.mobileNo),
                  if (isSelected) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed:  () {
                            final deliveryAddressProvider = Provider.of<CheckoutProvider>(context, listen: false);
                            deliveryAddressProvider.editAddress(context, deliveryAddressModel);
                          } ,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text("Are you sure you want to delete this address?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        final deliveryAddressProvider = Provider.of<CheckoutProvider>(context, listen: false);
                                        deliveryAddressProvider.deleteAddress(deliveryAddressModel);
                                        Navigator.of(context).pop();  // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Divider(
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
