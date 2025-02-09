import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/models/user.dart';
import 'package:healthwise_patient_app/aura/views/user_profile.dart';
import 'package:healthwise_patient_app/patient_base/views/ecommerce/cart_screen.dart';
import 'package:healthwise_patient_app/patient_base/views/qr_screen/qr_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../aura/components/app_drawer.dart';
import '../../../aura/resources/user_provider.dart';
import '../../models/passport_model.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final _heartRate = ValueNotifier<int>(0);
  final _bloodPressureSystolic = ValueNotifier<int>(0);
  final _bloodPressureDiastolic = ValueNotifier<int>(0);
  final _spo2 = ValueNotifier<int>(0);
  final _temperature = ValueNotifier<int>(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startFetchingData();
  }

  void _startFetchingData() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        fetchData();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.90.49:8080"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          _heartRate.value = data['heart_rate'];
          _bloodPressureSystolic.value = data['blood_pressure_systolic'];
          _bloodPressureDiastolic.value = data['blood_pressure_diastolic'];
          _spo2.value = data['spo2'];
          _temperature.value = data['temperature'];
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Patient? user = Provider.of<UserProvider>(context).getUser;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('HealthWise'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/navigatorScreen'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'Welcome, ${user?.fullname}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              PassportView(
                passport: Passports(
                    patientId: "UrE9uj9csBeqPeMF2UwWEjzTMBJ2",
                    passportId: "PP5000",
                    medicine: ["Paracetamol", "Lisinopril", "Omeprazole"],
                    doctors: ["6KgdPndlLGURG2Ki9exe"],
                    sos: ["+919876543210", "+914321098765"],
                    allergies: ["Dust", "Wheat"]),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Text("Vitals:",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VitalSignCard(
                    width: w,
                    valueNotifier: _heartRate,
                    label: "Heart Rate",
                    suffix: " bpm",
                    color: Color.fromARGB(255, 247, 124, 165),
                  ),
                  const SizedBox(width: 20),
                  BPCard(
                    width: w,
                    systolicNotifier: _bloodPressureSystolic,
                    diastolicNotifier: _bloodPressureDiastolic,
                    color: Color.fromARGB(255, 125, 171, 251),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VitalSignCard(
                    width: w,
                    valueNotifier: _spo2,
                    label: "Oxygen Saturation",
                    suffix: "%",
                    color: Color.fromARGB(255, 251, 198, 127),
                  ),
                  const SizedBox(width: 20),
                  VitalSignCard(
                    width: w,
                    valueNotifier: _temperature,
                    label: "Temperature",
                    suffix: "°C",
                    color: Color.fromARGB(255, 155, 237, 247),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Text("Reminders:",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen(
                                      userId: "UrE9uj9csBeqPeMF2UwWEjzTMBJ2",
                                    )));
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 177, 172, 172)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                            "Lisonopril strip to end in 2 days, make sure to buy soon!"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VitalSignCard extends StatelessWidget {
  final double width;
  final ValueNotifier<int> valueNotifier;
  final String label;
  final String suffix;
  final Color color;

  const VitalSignCard({
    required this.width,
    required this.valueNotifier,
    required this.label,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: width * 0.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: valueNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$value$suffix",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BPCard extends StatelessWidget {
  final double width;
  final ValueNotifier<int> systolicNotifier;
  final ValueNotifier<int> diastolicNotifier;
  final Color color;

  const BPCard({
    required this.width,
    required this.systolicNotifier,
    required this.diastolicNotifier,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: width * 0.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ValueListenableBuilder2<int, int>(
        first: systolicNotifier,
        second: diastolicNotifier,
        builder: (context, systolic, diastolic, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$systolic/$diastolic",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Blood Pressure",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Helper widget to listen to two ValueNotifiers
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueNotifier<A> first;
  final ValueNotifier<B> second;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}

class PassportView extends StatelessWidget {
  final Passports passport;

  PassportView({required this.passport});

  Future<Patient?> fetchPatientDetails(String patientId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get();
      if (doc.exists) {
        return Patient(
          username: doc['username'],
          email: doc['email'],
          photoUrl: doc['photoUrl'],
          contactnumber: doc['contactnumber'],
          age: doc['age'],
          weight: doc['weight'],
          fullname: doc['fullname'],
          uid: doc['uid'],
          height: 168,
          wakeUpTime: '',
          bedTime: '',
          workStartTime: '',
          workEndTime: '',
        );
      }
    } catch (e) {
      print("Error fetching patient details: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Patient?>(
        future: fetchPatientDetails(passport.patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Failed to load patient data"));
          }

          Patient patient = snapshot.data!;

          return Center(
            child: Card(
              color: const Color.fromARGB(255, 250, 236, 236),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(patient.photoUrl),
                    ),
                    SizedBox(height: 10),
                    Text(patient.username,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(patient.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Divider(),
                    Text("Age: ${patient.age} | Weight: ${patient.weight} kg",
                        style: TextStyle(fontSize: 14)),
                    Text("Contact: ${patient.contactnumber}",
                        style: TextStyle(fontSize: 14)),
                    SizedBox(height: 10),
                    Divider(),
                    Text("Medicines",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ...passport.medicine
                        .map((med) => Text(med, style: TextStyle(fontSize: 14)))
                        .toList(),
                    SizedBox(height: 10),
                    Text("Doctors",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("sanjeevtest", style: TextStyle(fontSize: 14)),
                    // ...passport.doctors.map((doctor) => Text(doctor, style: TextStyle(fontSize: 14))).toList(),
                    SizedBox(height: 10),
                    Text("SOS Contacts",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ...passport.sos
                        .map((contact) =>
                            Text(contact, style: TextStyle(fontSize: 14)))
                        .toList(),
                    SizedBox(height: 10),
                    Text("Allergies",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ...passport.allergies
                        .map((allergy) =>
                            Text(allergy, style: TextStyle(fontSize: 14)))
                        .toList(),
                    SizedBox(height: 10),
                    QRScreen(patientId: passport.patientId)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
