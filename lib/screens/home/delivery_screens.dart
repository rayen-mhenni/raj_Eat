import 'package:flutter/material.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final List<Map<String, String>> _deliveries = [
    {
      'orderId': '123',
      'customerName': 'John Doe',
      'address': '123 Main St, Springfield',
      'status': 'En route',
    },
    {
      'orderId': '124',
      'customerName': 'Jane Smith',
      'address': '456 Elm St, Shelbyville',
      'status': 'Livré',
    },
    // Ajoutez plus de commandes ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livraisons'),
      ),
      body: ListView.builder(
        itemCount: _deliveries.length,
        itemBuilder: (context, index) {
          final delivery = _deliveries[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('Commande ID: ${delivery['orderId']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Client: ${delivery['customerName']}'),
                  Text('Adresse: ${delivery['address']}'),
                  Text('Statut: ${delivery['status']}'),
                ],
              ),
              trailing: _buildStatusButton(delivery['status']!, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(String status, int index) {
    if (status == 'En route') {
      return ElevatedButton(
        onPressed: () => _updateStatus(index, 'Livré'),
        child: const Text('Marquer comme livré'),
      );
    } else {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
  }

  void _updateStatus(int index, String newStatus) {
    setState(() {
      _deliveries[index]['status'] = newStatus;
    });
  }
}
