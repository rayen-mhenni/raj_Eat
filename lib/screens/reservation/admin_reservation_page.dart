import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminReservationsPage extends StatefulWidget {
  const AdminReservationsPage({super.key});

  @override
  _AdminReservationsPageState createState() => _AdminReservationsPageState();
}

class _AdminReservationsPageState extends State<AdminReservationsPage> {
  // Function to fetch all reservations
  Future<List<Map<String, dynamic>>> _fetchAllReservations() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('TableReservations').get();
      List<Map<String, dynamic>> reservations = [];
      for (var doc in snapshot.docs) {
        reservations.add({
          ...doc.data(),
          'id': doc.id, // Add the document ID for updates
        });
      }
      return reservations;
    } catch (e) {
      print("Error fetching reservations: $e");
      return [];
    }
  }

  // Function to send a notification to the user with reservation details
  Future<void> _sendNotification(String userId, String message, Map<String, dynamic> reservationDetails) async {
    try {
      await FirebaseFirestore.instance.collection('Notifications').add({
        'userId': userId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        ...reservationDetails, // Include reservation details in the notification
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  // Function to update the reservation status and send a notification
  Future<void> _updateReservationStatus(String reservationId, bool isAccepted, Map<String, dynamic> reservation) async {
    try {
      await FirebaseFirestore.instance.collection('TableReservations').doc(reservationId).update({
        'status': isAccepted ? 'accepted' : 'rejected',
      });

      String message = isAccepted
          ? 'Your table reservation has been accepted.'
          : 'Your table reservation has been rejected.';

      reservation['status'] = isAccepted ? 'accepted' : 'rejected';

      await _sendNotification(reservation['userId'], message, reservation);
    } catch (e) {
      print("Error updating reservation status or sending notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Reservations Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reservations found.'));
          } else {
            final reservations = snapshot.data!;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return ListTile(
                  title: Text('Reservation by: ${reservation['name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${reservation['date']}'),
                      Text('Time: ${reservation['time']}'),
                      Text('People: ${reservation['people']}'),
                      Text('Status: ${reservation['status'] ?? 'pending'}'),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _updateReservationStatus(reservation['id'], true, reservation);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reservation accepted and user notified')),
                              );
                              setState(() {}); // Refresh the UI to show the updated status
                            },
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 8), // Add space between buttons
                          ElevatedButton(
                            onPressed: () async {
                              await _updateReservationStatus(reservation['id'], false, reservation);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reservation rejected and user notified')),
                              );
                              setState(() {}); // Refresh the UI to show the updated status
                            },
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
