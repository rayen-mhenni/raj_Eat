import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminReservationsPage extends StatefulWidget {
  @override
  _AdminReservationsPageState createState() => _AdminReservationsPageState();
}

class _AdminReservationsPageState extends State<AdminReservationsPage> {
  // Fonction pour récupérer toutes les réservations
  Future<List<Map<String, dynamic>>> _fetchAllReservations() async {
    final snapshot = await FirebaseFirestore.instance.collection('TableReservations').get();
    List<Map<String, dynamic>> reservations = [];
    for (var doc in snapshot.docs) {
      reservations.add({
        ...doc.data(),
        'id': doc.id, // Ajout de l'identifiant du document pour les mises à jour
      });
    }
    return reservations;
  }

  // Fonction pour envoyer une notification à l'utilisateur
  Future<void> _sendNotification(String userId, String message) async {
    await FirebaseFirestore.instance.collection('Notifications').add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fonction pour mettre à jour le statut de la réservation et envoyer une notification
  Future<void> _updateReservationStatus(String reservationId, bool isAccepted, String userId) async {
    await FirebaseFirestore.instance.collection('TableReservations').doc(reservationId).update({
      'status': isAccepted ? 'accepted' : 'rejected',
    });

    String message = isAccepted
        ? 'Your table reservation has been accepted.'
        : 'Your table reservation has been rejected.';
    await _sendNotification(userId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Reservations Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reservations found.'));
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
                              await _updateReservationStatus(reservation['id'], true, reservation['userId']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Reservation accepted and user notified')),
                              );
                              setState(() {});
                            },
                            child: Text('Accept'),
                          ),
                          SizedBox(width: 8), // Ajouter de l'espace entre les boutons
                          ElevatedButton(
                            onPressed: () async {
                              await _updateReservationStatus(reservation['id'], false, reservation['userId']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Reservation rejected and user notified')),
                              );
                              setState(() {});
                            },
                            child: Text('Reject'),
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
