
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventFormPage extends StatefulWidget {
  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final titleController = TextEditingController();
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveEvent() async {
  if (titleController.text.isEmpty || selectedDateTime == null) return;

  final uid = FirebaseAuth.instance.currentUser?.uid;
  final docRef = await FirebaseFirestore.instance.collection('events').add({
    'title': titleController.text,
    'datetime': selectedDateTime!.toIso8601String(),
    'user_id': uid,
  });

  // Schedule the notification for this event



  titleController.clear();
  setState(() => selectedDateTime = null);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: Text(selectedDateTime == null
                  ? 'Pick Date & Time'
                  : selectedDateTime.toString()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
