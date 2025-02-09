import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  // final String uid;
  final String patientId;
  final String doctorId; // Firestore doc ID for the doctor
  final Timestamp date; // Using Firestore's Timestamp
  final Timestamp time; // Using Firestore's Timestamp
  final int fees;

  Appointment({
    // required this.uid,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.fees,
  });

  // Convert to JSON to store in Firestore
  Map<String, dynamic> toJson() => {
        // 'uid':uid,
        'patientId': patientId,
        'doctorId': doctorId,
        'date': date, // Timestamp for date
        'time': time, // Timestamp for time
        'fees': fees,
      };

  // Create an Appointment instance from Firestore snapshot
  static Appointment fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return Appointment(
      // uid: data['uid'],
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      date: data['date'], // Assuming it's a Timestamp
      time: data['time'], // Assuming it's a Timestamp
      fees: data['fees'],
    );
  }
}
