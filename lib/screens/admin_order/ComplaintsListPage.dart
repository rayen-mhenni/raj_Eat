import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ComplaintsListPage extends StatelessWidget {
  final String userId;

  const ComplaintsListPage({Key? key, required this.userId}) : super(key: key);

  // Function to update the complaint with a response and send a notification
  Future<void> _respondToComplaint(String complaintId, String responseText, String userId) async {
    await FirebaseFirestore.instance.collection('reclamations').doc(complaintId).update({
      'response': responseText,
      'status': 'responded', // Update status to 'responded' or any other appropriate status
    });

    await FirebaseFirestore.instance.collection('Notifications').add({
      'userId': userId,
      'message': 'Your complaint has been responded to. Check the details in your complaints list.',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reclamations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No complaints found.'));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaintDoc = complaints[index];
              final complaint = complaintDoc.data() as Map<String, dynamic>?;

              if (complaint == null || !complaint.containsKey('complaint') || !complaint.containsKey('timestamp')) {
                return ListTile(
                  title: Text('Invalid data'),
                  subtitle: Text('This document is missing required fields.'),
                );
              }

              final complaintText = complaint['complaint'] as String;
              final timestamp = complaint['timestamp'] as Timestamp?;
              final complaintId = complaintDoc.id;  // Get the document ID

              // TextEditingController to capture admin's response
              final TextEditingController _responseController = TextEditingController();

              return ListTile(
                title: Text('Complaint: $complaintText'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timestamp != null
                          ? 'Submitted on ${timestamp.toDate()}'
                          : 'No date available',
                    ),
                    Text('User ID: ${complaint['userId']}'),
                    SizedBox(height: 8),
                    TextField(
                      controller: _responseController,
                      decoration: InputDecoration(
                        labelText: 'Response to User',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final responseText = _responseController.text.trim();
                        if (responseText.isNotEmpty) {
                          await _respondToComplaint(complaintId, responseText, complaint['userId']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Response sent and user notified')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter a response')),
                          );
                        }
                      },
                      child: Text('Send Response'),
                    ),
                  ],
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
