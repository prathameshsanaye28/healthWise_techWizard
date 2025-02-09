import 'package:cloud_firestore/cloud_firestore.dart';

class Therapist {
  final String email;
  final String fullname;
  final String uid;
  final String contactnumber;
  final double? latitude;
  final double? longitude;
  final int age;

  const Therapist({
    required this.email,
    required this.fullname,
    required this.uid,
    required this.contactnumber,
    this.latitude,
    this.longitude,
    required this.age,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'fullname': fullname,
        'contactnumber': contactnumber,
        'latitude': latitude,
        'longitude': longitude,
        'age': age,
      };

  static Therapist fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Therapist(
      email: snapshot['email'],
      uid: snapshot['uid'],
      fullname: snapshot['fullname'],
      contactnumber: snapshot['contactnumber'],
      latitude: snapshot['latitude']?.toDouble(),
      longitude: snapshot['longitude']?.toDouble(),
      age: snapshot['age'] ?? 0,
    );
  }

  Therapist copyWithLocation(double lat, double lng) {
    return Therapist(
      email: email,
      fullname: fullname,
      uid: uid,
      contactnumber: contactnumber,
      latitude: lat,
      longitude: lng,
      age: age,
    );
  }
}