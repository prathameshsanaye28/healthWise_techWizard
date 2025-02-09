
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/therapist.dart';

void addTherapistsData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Therapist> therapists = [
    const Therapist(
      email: 'therapist1@example.com',
      fullname: 'Therapist A',
      uid: 'therapist_uid_1',
      contactnumber: '1234567890',
      latitude: 19.0760,
      longitude: 72.8777, // Mumbai Central
      age: 35,
    ),
    const Therapist(
      email: 'therapist2@example.com',
      fullname: 'Therapist B',
      uid: 'therapist_uid_2',
      contactnumber: '1234567891',
      latitude: 19.0896,
      longitude: 72.8656, // Bandra
      age: 40,
    ),
    const Therapist(
      email: 'therapist3@example.com',
      fullname: 'Therapist C',
      uid: 'therapist_uid_3',
      contactnumber: '1234567892',
      latitude: 19.1354,
      longitude: 72.8648, // Andheri
      age: 32,
    ),
    const Therapist(
      email: 'therapist4@example.com',
      fullname: 'Therapist D',
      uid: 'therapist_uid_4',
      contactnumber: '1234567893',
      latitude: 19.2183,
      longitude: 72.9781, // Borivali
      age: 45,
    ),
    const Therapist(
      email: 'therapist5@example.com',
      fullname: 'Therapist E',
      uid: 'therapist_uid_5',
      contactnumber: '1234567894',
      latitude: 19.0434,
      longitude: 72.8162, // Worli
      age: 29,
    ),
    const Therapist(
      email: 'therapist6@example.com',
      fullname: 'Therapist F',
      uid: 'therapist_uid_6',
      contactnumber: '1234567895',
      latitude: 19.0026,
      longitude: 72.8419, // Colaba
      age: 50,
    ),
    const Therapist(
      email: 'therapist7@example.com',
      fullname: 'Therapist G',
      uid: 'therapist_uid_7',
      contactnumber: '1234567896',
      latitude: 19.1224,
      longitude: 72.8424, // Juhu
      age: 38,
    ),
    const Therapist(
      email: 'therapist8@example.com',
      fullname: 'Therapist H',
      uid: 'therapist_uid_8',
      contactnumber: '1234567897',
      latitude: 19.1673,
      longitude: 72.8518, // Malad
      age: 43,
    ),
    const Therapist(
      email: 'therapist9@example.com',
      fullname: 'Therapist I',
      uid: 'therapist_uid_9',
      contactnumber: '1234567898',
      latitude: 19.1905,
      longitude: 72.8484, // Goregaon
      age: 31,
    ),
    const Therapist(
      email: 'therapist10@example.com',
      fullname: 'Therapist J',
      uid: 'therapist_uid_10',
      contactnumber: '1234567899',
      latitude: 19.2154,
      longitude: 72.8626, // Kandivali
      age: 36,
    ),
    const Therapist(
      email: 'therapist11@example.com',
      fullname: 'Therapist K',
      uid: 'therapist_uid_11',
      contactnumber: '1234567810',
      latitude: 19.2434,
      longitude: 72.8551, // Dahisar
      age: 41,
    ),
    const Therapist(
      email: 'therapist12@example.com',
      fullname: 'Therapist L',
      uid: 'therapist_uid_12',
      contactnumber: '1234567811',
      latitude: 19.0816,
      longitude: 72.8882, // Dadar
      age: 30,
    ),
    const Therapist(
      email: 'therapist13@example.com',
      fullname: 'Therapist M',
      uid: 'therapist_uid_13',
      contactnumber: '1234567812',
      latitude: 19.1325,
      longitude: 72.9212, // Powai
      age: 34,
    ),
    const Therapist(
      email: 'therapist14@example.com',
      fullname: 'Therapist N',
      uid: 'therapist_uid_14',
      contactnumber: '1234567813',
      latitude: 19.2118,
      longitude: 72.8566, // Mira Road
      age: 46,
    ),
    const Therapist(
      email: 'therapist15@example.com',
      fullname: 'Therapist O',
      uid: 'therapist_uid_15',
      contactnumber: '1234567814',
      latitude: 19.0030,
      longitude: 72.8231, // Marine Lines
      age: 28,
    ),
    const Therapist(
      email: 'therapist16@example.com',
      fullname: 'Therapist P',
      uid: 'therapist_uid_16',
      contactnumber: '1234567815',
      latitude: 19.0979,
      longitude: 72.8476, // Sion
      age: 52,
    ),
    const Therapist(
      email: 'therapist17@example.com',
      fullname: 'Therapist Q',
      uid: 'therapist_uid_17',
      contactnumber: '1234567816',
      latitude: 19.0473,
      longitude: 72.8236, // Parel
      age: 39,
    ),
    const Therapist(
      email: 'therapist18@example.com',
      fullname: 'Therapist R',
      uid: 'therapist_uid_18',
      contactnumber: '1234567817',
      latitude: 19.1340,
      longitude: 72.8997, // Vikhroli
      age: 33,
    ),
    const Therapist(
      email: 'therapist19@example.com',
      fullname: 'Therapist S',
      uid: 'therapist_uid_19',
      contactnumber: '1234567818',
      latitude: 19.1042,
      longitude: 72.8703, // Chembur
      age: 42,
    ),
    const Therapist(
      email: 'therapist20@example.com',
      fullname: 'Therapist T',
      uid: 'therapist_uid_20',
      contactnumber: '1234567819',
      latitude: 19.1436,
      longitude: 72.8346, // Versova
      age: 37,
    ),
  ];

  for (var therapist in therapists) {
    await firestore.collection('therapists').doc(therapist.uid).set(therapist.toJson());
  }

  print('Therapists data added to Firestore!');
}

void main() {
  addTherapistsData();
}