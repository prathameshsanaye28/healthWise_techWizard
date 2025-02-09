// // lib/screens/main_tracker_screen.dart
// import 'package:aura_techwizard/views/CircadianScreens/EditUserData.dart';
// import 'package:aura_techwizard/views/CircadianScreens/OnBoardingScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class MainTrackerScreen extends StatefulWidget {
//   const MainTrackerScreen({super.key});

//   @override
//   _MainTrackerScreenState createState() => _MainTrackerScreenState();
// }

// class _MainTrackerScreenState extends State<MainTrackerScreen> {
//   late Stream<DocumentSnapshot> _userDataStream;
//   final int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     _userDataStream = FirebaseFirestore.instance
//         .collection('patients')
//         .doc(user?.uid)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: _userDataStream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final userData = UserHealthData.fromMap(
//             snapshot.data!.data() as Map<String, dynamic>);

//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Health Tracker'),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         EditUserDataScreen(userData: userData),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: IndexedStack(
//             index: _selectedIndex,
//             children: [
//               //   DashboardScreen(userData: userData),
//               //   WaterTrackingScreen(userData: userData),
//               //   ExerciseTrackingScreen(userData: userData),
//               //   SleepTrackingScreen(userData: userData),
//               //   CircadianCycleScreen(userData: userData),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
