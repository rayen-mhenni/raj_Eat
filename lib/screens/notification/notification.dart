import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .where('userId', isEqualTo: 'CURRENT_USER_ID') // Remplacez par l'ID utilisateur actuel
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
                final message = notification['message'] ?? 'No message';
                final timestamp = (notification['timestamp'] as Timestamp).toDate();

                return ListTile(
                  title: Text(message),
                  subtitle: Text('${timestamp.toLocal()}'), // Affiche l'heure locale
                );
              },
            );
          }
        },
      ),
    );
  }
}
