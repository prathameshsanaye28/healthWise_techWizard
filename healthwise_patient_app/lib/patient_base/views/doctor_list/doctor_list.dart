import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/patient_base/views/appointment.dart';

import '../../models/doctor.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No doctors found"));
          }

          var doctors =
              snapshot.data!.docs.map((doc) => Doctor.fromSnap(doc)).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  final doctorid = doctors[index].id??'123';
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDateTimeScreen(doctorid: doctorid,)));
                },
                child: DoctorCard(doctor: doctors[index]));
            },
          );
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 80,
                width: 80,
                child: Image.network(
                  doctor.photoUrl ??
                      "https://cdn-icons-png.flaticon.com/512/8815/8815112.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. ${doctor.name}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(doctor.specializations.isNotEmpty
                      ? doctor.specializations[0]
                      : "General Practitioner"),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text("${doctor.yearsExperience} Yrs",
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Container(
                        width: 200,
                        child: Text("Consultant at: ${doctor.region}",
                            maxLines: 2, // Adjust as needed
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
