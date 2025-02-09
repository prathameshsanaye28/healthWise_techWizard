import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/appointments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  await addAppointmentsData(); // Call the function
  print("Appointments data successfully added! 🎉");
}

Future<void> addAppointmentsData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Random random = Random();

  List<String> randomDoctors = [
    "Dr. A123", "Dr. B234", "Dr. C345", "Dr. D456", "Dr. E567",
    "Dr. F678", "Dr. G789", "Dr. H890", "Dr. I901", "Dr. J012"
  ];

  List<String> randomPatients = [
    "P1001", "P1002", "P1003", "P1004", "P1005",
    "P1006", "P1007", "P1008", "P1009", "P1010"
  ];

  List<String> randomDates = [
    "2025-02-02", "2025-02-05", "2025-02-08", "2025-02-12", "2025-02-15",
    "2025-02-18", "2025-02-20", "2025-02-22", "2025-02-25", "2025-02-28"
  ];

  List<String> randomTimes = [
    "10:00 AM", "11:00 AM", "12:00 PM", "02:00 PM", "03:00 PM",
    "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM"
  ];

  List<int> randomFees = [500, 1000, 1500, 2000, 2500];

  List<Appointment> appointments = List.generate(20, (index) {
    String patientId = randomPatients[random.nextInt(randomPatients.length)];
    String doctorId = randomDoctors[random.nextInt(randomDoctors.length)];
    String appointmentDate = randomDates[random.nextInt(randomDates.length)];
    String appointmentTime = randomTimes[random.nextInt(randomTimes.length)];
    int fees = randomFees[random.nextInt(randomFees.length)];

    // Convert string date and time into Firestore Timestamp
    Timestamp dateTimestamp = Timestamp.fromDate(DateTime.parse(appointmentDate));
    // String appointmentTime = randomTimes[random.nextInt(randomTimes.length)];

    DateTime parsedTime = DateFormat("hh:mm a").parse(appointmentTime);
    DateTime fullDateTime = DateTime(
      dateTimestamp.toDate().year,
      dateTimestamp.toDate().month,
      dateTimestamp.toDate().day,
      parsedTime.hour,
      parsedTime.minute,
    );

    Timestamp timeTimestamp = Timestamp.fromDate(fullDateTime);

    return Appointment(
      patientId: patientId,
      doctorId: doctorId,
      date: dateTimestamp,
      time: timeTimestamp, 
      fees: fees,
    );
  });

  for (var appointment in appointments) {
    String appointmentId = "A${1000 + random.nextInt(9999)}";
    await firestore.collection('appointments').doc(appointmentId).set(appointment.toJson());

  }

  print('Appointments data added to Firestore!');
}
