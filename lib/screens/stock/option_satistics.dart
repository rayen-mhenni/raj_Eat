import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OptionStatisticsPage extends StatefulWidget {
  final String productId;

  const OptionStatisticsPage({super.key, required this.productId});

  @override
  _OptionStatisticsPageState createState() => _OptionStatisticsPageState();
}

class _OptionStatisticsPageState extends State<OptionStatisticsPage> {
  Map<String, int> optionStats = {};

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('OptionStatistics')
          .doc(widget.productId)
          .get();

      if (snapshot.exists) {
        setState(() {
          optionStats = Map<String, int>.from(snapshot.data() as Map<String, dynamic>);
        });
      } else {
        // Handle case when the document does not exist
        setState(() {
          optionStats = {};
        });
      }
    } catch (e) {
      print("Error fetching statistics: $e");
      // Handle error (e.g., show a message to the user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Option Statistics'),
      ),
      body: optionStats.isEmpty
          ? const Center(child: Text('No statistics available.'))
          : ListView(
        children: optionStats.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: Text(entry.value.toString()),
          );
        }).toList(),
      ),
    );
  }
}
