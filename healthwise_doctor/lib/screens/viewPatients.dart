import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthwise/screens/passportView.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as Patient;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as Patient;

class PatientListWidget extends StatelessWidget {
  final String userId = "lUoJzE4iXrVAvJudsCHwUwVjfPB2";

  @override
  Widget build(BuildContext context) {
    //final userProvider = Provider.of<UserProvider>(context);
    //final userId = userProvider.userId; // Assuming userId is available through the provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No patients found.'));
          }

          List<String> patientIds = List<String>.from(snapshot.data!['patientIds']);

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('patients')
                .where(FieldPath.documentId, whereIn: patientIds)
                .get(),
            builder: (context, patientsSnapshot) {
              if (patientsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!patientsSnapshot.hasData || patientsSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('No patients found.'));
              }

              return ListView.builder(
                itemCount: patientsSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var patient = patientsSnapshot.data!.docs[index];
                  var patientData = patient.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(patientData['photoUrl'] ?? ''),
                    ),
                    title: Text(patientData['fullname'] ?? 'No Name'),
                    subtitle: Text(patientData['contactnumber'] ?? 'No Contact'),
                    onTap: () {
                      // Create a Patient object and pass it to the UserScreen
                      Patient.Patient patientModel = Patient.Patient(
                        username: patientData['username'] ?? '',
                        email: patientData['email'] ?? '',
                        photoUrl: patientData['photoUrl'] ?? '',
                        fullname: patientData['fullname'] ?? 'No Name',
                        uid: patient.id,
                        contactnumber: patientData['contactnumber'] ?? 'No Contact',
                        latitude: patientData['latitude']?.toDouble(),
                        longitude: patientData['longitude']?.toDouble(),
                        age: patientData['age'] ?? 0,
                        weight: patientData['weight']?.toDouble() ?? 0.0,
                        height: patientData['height']?.toDouble() ?? 0.0,
                        wakeUpTime: patientData['wakeUpTime'] ?? '06:00',
                        bedTime: patientData['bedTime'] ?? '22:00',
                        workStartTime: patientData['workStartTime'] ?? '09:00',
                        workEndTime: patientData['workEndTime'] ?? '17:00',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserScreen(user: patientModel),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}



// class PassportView extends StatelessWidget {
//   final QueryDocumentSnapshot patient;

//   PassportView({required this.patient});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(patient['fullname'] ?? 'Patient Details'),
//       ),
//       body: Center(
//         child: Text('Passport details for ${patient['fullname']}'),
//       ),
//     );
//   }
// }
