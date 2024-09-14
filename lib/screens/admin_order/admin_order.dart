import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('order').get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status, String userId, String cartName) async {
    try {
      // Update order status
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'status': status,
      });

      // Send notification to the user when the order is refused
      if (status == 'Refused') {
        await FirebaseFirestore.instance.collection('Notifications').add({
          'userId': userId,
          'message': "L'admin a refusé la commande pour le plat '$cartName' en raison de stock. Si vous voulez, passez un autre plat ou attendez le stock dans 1 heure.",
          'timestamp': FieldValue.serverTimestamp(),
          'cartName': cartName, // Add cartName to the notification
        });
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          List<Map<String, dynamic>> orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orders[index];
              String cartName = order['cartName'] ?? 'Unknown Cart'; // Default value if cartName is missing
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Order: $cartName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Name: ${order['firstname']}'),
                      Text('Last Name: ${order['lastName']}'),
                      Text('Total Amount: D${order['totalAmount']}'),
                      Text('User ID: ${order['userId']}'),
                      Text('Selected Options: ${order['selectedOptions'].toString()}'),
                      Text('Status: ${order['status'] ?? 'Pending'}'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              updateOrderStatus(order['id'], 'Accepted', order['userId'], cartName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Changed to backgroundColor
                            ),
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              updateOrderStatus(order['id'], 'Refused', order['userId'], cartName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Changed to backgroundColor
                            ),
                            child: const Text('Refuse'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
