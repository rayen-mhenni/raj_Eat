import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableReservationPage extends StatefulWidget {
  @override
  _TableReservationPageState createState() => _TableReservationPageState();
}

class _TableReservationPageState extends State<TableReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  Future<void> _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('TableReservations').add({
        'name': _nameController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'people': int.parse(_peopleController.text),
        'status': 'pending',  // Initial status is 'pending'
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation submitted for approval!')),
      );

      _formKey.currentState!.reset();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve a Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _peopleController,
                decoration: InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of people';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReservation,
                child: Text('Reserve'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
