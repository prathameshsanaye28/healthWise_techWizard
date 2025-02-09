import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/models/user.dart' as ModelUser;
import 'package:healthwise_patient_app/aura/resources/user_provider.dart';
import 'package:provider/provider.dart';

class AppointmentDateTimeScreen extends StatefulWidget {
  const AppointmentDateTimeScreen({Key? key, required this.doctorid})
      : super(key: key);
  final String doctorid;
  @override
  State<AppointmentDateTimeScreen> createState() =>
      _AppointmentDateTimeScreenState();
}

class _AppointmentDateTimeScreenState extends State<AppointmentDateTimeScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Function to show DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Function to show TimePicker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  void _submitAppointment() async {
    if (_selectedDate != null && _selectedTime != null) {
      final user = Provider.of<UserProvider>(context, listen: false).getUser;

      if (user == null) {
        print("User not found.");
        return;
      }

      // Convert selected date and time into a DateTime object
      DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      try {
        await FirebaseFirestore.instance.collection('appointments').add({
          'date': Timestamp.fromDate(_selectedDate!), // Store only date
          'time':
              Timestamp.fromDate(appointmentDateTime), // Store full datetime
          'doctorId': widget.doctorid,
          'patientId': user.uid, // Assuming user object has `uid`
          'fees': 2500, // Replace with dynamic value if needed
        });

        print("Appointment successfully added.");
        SnackBar(content: Text('Appointment successfully added.'));
      } catch (e) {
        print("Error adding appointment: $e");
      }
    } else {
      print('Please select both date and time.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ModelUser.Patient? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Scheduler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Appointment Date:'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Pick a date'
                      : '${_selectedDate!.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Select Appointment Time:'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedTime == null
                      ? 'Pick a time'
                      : _selectedTime!.format(context),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAppointment,
              child: Text('Submit Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

  // Widget _buildNavItem(IconData icon, String label) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(icon, color: Colors.black),
  //       const SizedBox(height: 4),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 12,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ],
  //   );
  // }

