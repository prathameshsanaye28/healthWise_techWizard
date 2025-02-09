import 'package:cloud_firestore/cloud_firestore.dart';

class Passports {
  final String patientId;
  final String passportId;
  final List<String> medicine;
  final List<String> doctors;
  final List<String> sos;
  final List<String> allergies;

  const Passports({
    required this.patientId,
    required this.passportId,
    required this.medicine,
    required this.doctors,
    required this.sos,
    required this.allergies,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'passportId': passportId,
        'medicine': medicine,
        'doctors': doctors,
        'sos': sos,
        'allergies': allergies,
      };

  static Passports fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Passports(
      patientId: snapshot['patientId'],
      passportId: snapshot['passportId'],
      medicine: List<String>.from(snapshot['medicine'] ?? []),
      doctors: List<String>.from(snapshot['doctors'] ?? []),
      sos: List<String>.from(snapshot['sos'] ?? []),
      allergies: List<String>.from(snapshot['allergies'] ?? []),
    );
  }
}
