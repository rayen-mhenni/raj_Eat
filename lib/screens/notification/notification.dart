import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  Future<void> _deleteNotification(String notificationId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('Notifications').doc(notificationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted successfully')),
      );
    } catch (e) {
      print("Error deleting notification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete notification')),
      );
    }
  }

  void _confirmDeleteNotification(String notificationId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Notification"),
          content: const Text("Are you sure you want to delete this notification?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteNotification(notificationId, context); // Delete the notification
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .where('userId', isEqualTo: currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications.'));
          } else {
            final notifications = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final data = notification.data() as Map<String, dynamic>;
                final message = data['message'] ?? 'No message';
                final name = data['name'] ?? 'Unknown';
                final date = data['date'] ?? 'Unknown';
                final time = data['time'] ?? 'Unknown';
                final people = data['people'] ?? 'Unknown';
                final status = data['status'] ?? 'Unknown';
                final timestamp = (data['timestamp'] as Timestamp).toDate();

                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _confirmDeleteNotification(notification.id, context); // Show confirmation dialog before deleting
                  },
                  child: ListTile(
                    title: Text(message),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: $name'),
                        Text('Date: $date'),
                        Text('Time: $time'),
                        Text('People: $people'),
                        Text('Status: $status'),
                        Text('Received at: ${timestamp.toLocal()}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteNotification(notification.id, context); // Show confirmation dialog before deleting
                      },
                    ),
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
