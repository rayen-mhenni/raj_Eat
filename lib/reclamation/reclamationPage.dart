import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReclamationsPage extends StatefulWidget {
  final String userId;

  const ReclamationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ReclamationsPageState createState() => _ReclamationsPageState();
}

class _ReclamationsPageState extends State<ReclamationsPage> {
  final TextEditingController _complaintController = TextEditingController();

  Future<void> _submitComplaint() async {
    final complaintText = _complaintController.text.trim();

    if (complaintText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('reclamations').add({
          'userId': widget.userId,
          'complaint': complaintText,
          'timestamp': FieldValue.serverTimestamp(),
          'response': '', // Initialize response field as empty
          'status': 'pending', // Initialize status as 'pending'
        });

        // Clear the text field
        _complaintController.clear();

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted successfully')),
        );
      } catch (e) {
        // Show an error message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: $e')),
        );
      }
    } else {
      // Show an error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a complaint')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit your complaint:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _complaintController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Complaint Description',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitComplaint,
              child: Text('Submit'),
            ),
            const SizedBox(height: 32),
            Text(
              'Previous Complaints:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                    return Center(child: Text('No previous complaints found.'));
                  }

                  final complaints = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final complaintDoc = complaints[index];

                      // Ensure proper data structure and handle nulls
                      final complaint = complaintDoc.data() as Map<String, dynamic>? ?? {};
                      final complaintText = complaint['complaint'] as String? ?? 'No complaint text';
                      final timestamp = complaint['timestamp'] as Timestamp?;
                      final response = complaint['response'] as String? ?? 'No response yet';
                      final status = complaint['status'] as String? ?? 'pending';

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
                            SizedBox(height: 8),
                            Text('Admin Response: $response'),
                            SizedBox(height: 8),
                            Text('Status: $status'),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
