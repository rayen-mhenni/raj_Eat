import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final String userId;

  const NotificationsPage({Key? key, required this.userId}) : super(key: key);

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications.'));
          } else {
            final notifications = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index].data() as Map<String, dynamic>;
                final id = notifications[index].id; // Use the document ID
                final message = notification['message'] ?? 'No message';
                final name = notification['name'] ?? 'No name';
                final people = notification['people'] ?? 'No people';
                final status = notification['status'] ?? 'No status';
                final time = notification['time'] ?? 'No time';
                final cartName = notification['cartName'] ?? 'No cart name';
                final timestamp = (notification['timestamp'] as Timestamp).toDate();
                final formattedDate = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
                final formattedTime = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

                // Determine if the notification is related to a stock issue
                final isStockIssue = message.contains("L'admin a refusé la commande");

                return ListTile(
                  title: Text(isStockIssue ? 'Order: $cartName' : 'Notification'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isStockIssue) ...[
                        Text('Attention: $message'), // Display the message for stock issues
                      ] else ...[
                        Text('ID: $id'),
                        Text('Name: $name'),
                        Text('People: $people'),
                        Text('Status: $status'),
                        Text('Time: $time'),
                        Text('Message: $message'),
                      ],
                      Text('Date: $formattedDate'),
                      Text('Time: $formattedTime'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNotification(id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
