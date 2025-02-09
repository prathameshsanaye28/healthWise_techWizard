

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthwise/screens/summarizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as Patient;
import '../models/passport.dart' as Pass;
import '../models/appointments.dart';
import '../resources/user_provider.dart';
import 'auth_screens/login.dart';

// Keeping your original PastelColors class
class PastelColors {
  static const Color pastelGreen = Color(0xFFB8E3A7);
  static const Color pastelBlue = Color(0xFFA7D8EA);
  static const Color pastelPink = Color(0xFFF2C6C2);
  static const Color pastelPurple = Color(0xFFD8BFD8);
  static const Color pastelYellow = Color(0xFFFFF5BA);
}

// Keeping your original AuthMethods class exactly as is
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getPassportByPatientUID(String patientUID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('passports')
          .where('patientId', isEqualTo: patientUID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        print("No passport found for patientId: $patientUID");
        return null;
      }
    } catch (e) {
      print("Error fetching passport: $e");
      return null;
    }
  }

    
}

  

class UserScreen extends StatefulWidget {
  final Patient.Patient user;

  const UserScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Map<String, dynamic> passportData;
  List<Appointment> appointments = [];


  @override
  void initState() {
    super.initState();
    passportData = {};
    fetchPassportData(widget.user.uid);
    fetchAppointments();
  }

  // Keeping your original fetchPassportData method
  fetchPassportData(String patientUID) async {
    DocumentSnapshot<Map<String, dynamic>>? passport = await AuthMethods().getPassportByPatientUID(patientUID);

    if (passport != null && passport.exists) {
      setState(() {
        passportData = passport.data()!;
      });
    } else {
      print("No passport found for this patient.");
    }
  }

  Future<void> fetchAppointments() async {
      // final doctor = Provider.of<DoctorProvider>(context, listen: false).doctor;
      // if (doctor == null) return;

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('appointments')
          .where('patientId', isEqualTo: widget.user.uid)
          .where('doctorId', isEqualTo: 'lUoJzE4iXrVAvJudsCHwUwVjfPB2') // Fetch only for this doctor
          .get();

      List<Appointment> tempAppointments = querySnapshot.docs.map((doc) {
        return Appointment.fromSnapshot(doc);
      }).toList();

      setState(() {
        appointments = tempAppointments;
      });
    }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: PastelColors.pastelBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    if (appointments.isEmpty) {
      return const Text("No appointments found.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Appointments'),
        ...appointments.map((appointment) {
          return Card(
            color: PastelColors.pastelPurple.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(
                "Date: ${appointment.date.toDate().toString().split(' ')[0]}", // Display Date
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Time: ${appointment.time.toDate()}:${appointment.time.toDate().minute}\nFees: ₹${appointment.fees}",
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (passportData.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<dynamic> allergy = passportData['allergies'] ?? [];
    List<dynamic> sos = passportData['sos'] ?? [];
    List<dynamic> medicines = passportData['medicine'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Passport'),
        backgroundColor: PastelColors.pastelBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.user.photoUrl),
                        backgroundColor: PastelColors.pastelPink,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.user.fullname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Basic Information Section
                _buildSectionTitle('Basic Information'),
                _buildInfoCard('Contact No.', widget.user.contactnumber),
                _buildInfoCard('Age', widget.user.age.toString()),
                _buildInfoCard('Weight', '${widget.user.weight} kg'),
                _buildInfoCard('Height', '${widget.user.height} cm'),

                const SizedBox(height: 24),
                _buildAppointmentsSection(), 

                // Vitals Section
                _buildSectionTitle('Vital Signs'),
                _buildInfoCard('Heart Rate', '78 bpm'),
                _buildInfoCard('Blood Pressure', '123/67 mmHg'),
                _buildInfoCard('Temperature', '37.6°C'),
                _buildInfoCard('spO2', '98%'),

                const SizedBox(height: 24),

                // Medical Information Section
                _buildSectionTitle('Medical Information'),
                if (allergy.isNotEmpty) ...[
                  const Text(
                    'Allergies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...allergy.map((item) => Card(
                    color: PastelColors.pastelPink.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item.toString()),
                    ),
                  )).toList(),
                ],

                const SizedBox(height: 16),

                if (medicines.isNotEmpty) ...[
                  const Text(
                    'Current Medications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...medicines.map((item) => Card(
                    color: PastelColors.pastelGreen.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item.toString()),
                    ),
                  )).toList(),
                ],

                const SizedBox(height: 16),

                if (sos.isNotEmpty) ...[
                  const Text(
                    'Emergency Contacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...sos.map((item) => Card(
                    color: PastelColors.pastelYellow.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item.toString()),
                    ),
                  )).toList(),
                  const SizedBox(height: 24),
              
              // Button to navigate to Summarizer screen
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SummarizerScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 185, 95, 185),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Go to Summarizer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
                  
                ],
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}