import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/providers/product_provider.dart';
import 'package:raj_eat/providers/user_provider.dart';
import 'package:raj_eat/screens/admin_order/admin_order.dart';
import 'package:raj_eat/screens/home/singal_product.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/screens/product_overview/product_overview.dart';
import 'package:raj_eat/screens/reservation/admin_reservation_page.dart';
import 'package:raj_eat/screens/stock/option_satistics.dart';
import 'package:raj_eat/singup/sing_up_delivery.dart';
import '../search/search.dart';
import 'drawer_side.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  ProductProvider? productProvider;

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    userProvider.getUserData();

    // Example productId; replace with an actual productId or obtain it dynamically
    String exampleProductId = 'your-product-id-here';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SingUpDelivery()),
                );
              },
              child: const Text('Add Delivery'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminOrdersPage()),
                );
              },
              child: const Text('Review Orders'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminReservationsPage()),
                );
              },
              child: const Text('Reservations'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OptionStatisticsPage(productId: exampleProductId),
                  ),
                );
              },
              child: const Text("View Statistics"),
            ),
          ],
        ),
      ),
    );
  }
}
