

import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String email;
  final String photoUrl;
  final String username;
  final String fullname;
  final String uid;
  final String contactnumber;
  final double? latitude;
  final double? longitude;
  final int age;
  final double weight;
  final double height;
  final String wakeUpTime;
  final String bedTime;
  final String workStartTime;
  final String workEndTime;

  const Patient({
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.fullname,
    required this.uid,
    required this.contactnumber,
    this.latitude,
    this.longitude,
    required this.age,
    required this.weight,
    required this.height,
    required this.wakeUpTime,
    required this.bedTime,
    required this.workStartTime,
    required this.workEndTime,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'fullname': fullname,
        'photoUrl': photoUrl,
        'contactnumber': contactnumber,
        'latitude': latitude,
        'longitude': longitude,
        'age': age,
        'weight': weight,
        'height': height,
        'wakeUpTime': wakeUpTime,
        'bedTime': bedTime,
        'workStartTime': workStartTime,
        'workEndTime': workEndTime,
      };

  static Patient fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Patient(
      username: snapshot['username'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      fullname: snapshot['fullname'],
      contactnumber: snapshot['contactnumber'],
      latitude: snapshot['latitude']?.toDouble(),
      longitude: snapshot['longitude']?.toDouble(),
      age: snapshot['age'] ?? 0,
      weight: snapshot['weight']?.toDouble() ?? 0.0,
      height: snapshot['height']?.toDouble() ?? 0.0,
      wakeUpTime: snapshot['wakeUpTime'] ?? '06:00',
      bedTime: snapshot['bedTime'] ?? '22:00',
      workStartTime: snapshot['workStartTime'] ?? '09:00',
      workEndTime: snapshot['workEndTime'] ?? '17:00',
    );
  }

  Patient copyWithLocation(double lat, double lng) {
    return Patient(
      username: username,
      email: email,
      photoUrl: photoUrl,
      fullname: fullname,
      uid: uid,
      contactnumber: contactnumber,
      latitude: lat,
      longitude: lng,
      age: age,
      weight: weight,
      height: height,
      wakeUpTime: wakeUpTime,
      bedTime: bedTime,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
    );
  }

}
