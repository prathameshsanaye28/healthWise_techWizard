// // lib/models/user_health_data.dart
// import 'package:aura_techwizard/views/CircadianScreens/EditUserData.dart';
// import 'package:aura_techwizard/views/CircadianScreens/MainScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class UserHealthData {
//   final String uid;
//   final String name;
//   final int age;
//   final double weight;
//   final double height;
//   final TimeOfDay wakeUpTime;
//   final TimeOfDay bedTime;
//   final int waterTarget; // daily target in glasses
//   final int exerciseTarget; // daily target in minutes
//   final int sleepTarget; // daily target in hours

//   UserHealthData({
//     required this.uid,
//     required this.name,
//     required this.age,
//     required this.weight,
//     required this.height,
//     required this.wakeUpTime,
//     required this.bedTime,
//     required this.waterTarget,
//     required this.exerciseTarget,
//     required this.sleepTarget,
//   });

//   factory UserHealthData.fromMap(Map<String, dynamic> map) {
//     return UserHealthData(
//       uid: map['uid'],
//       name: map['name'],
//       age: map['age'],
//       weight: map['weight'],
//       height: map['height'],
//       wakeUpTime: TimeOfDay(
//         hour: map['wakeUpTime']['hour'],
//         minute: map['wakeUpTime']['minute'],
//       ),
//       bedTime: TimeOfDay(
//         hour: map['bedTime']['hour'],
//         minute: map['bedTime']['minute'],
//       ),
//       waterTarget: map['waterTarget'],
//       exerciseTarget: map['exerciseTarget'],
//       sleepTarget: map['sleepTarget'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'name': name,
//       'age': age,
//       'weight': weight,
//       'height': height,
//       'wakeUpTime': {
//         'hour': wakeUpTime.hour,
//         'minute': wakeUpTime.minute,
//       },
//       'bedTime': {
//         'hour': bedTime.hour,
//         'minute': bedTime.minute,
//       },
//       'waterTarget': waterTarget,
//       'exerciseTarget': exerciseTarget,
//       'sleepTarget': sleepTarget,
//     };
//   }
// }

// // lib/screens/onboarding_screen.dart
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   TimeOfDay _wakeUpTime = TimeOfDay(hour: 6, minute: 0);
//   TimeOfDay _bedTime = TimeOfDay(hour: 22, minute: 0);

//   Future<void> _saveUserData() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final user = FirebaseAuth.instance.currentUser;
//         if (user == null) return;

//         final userData = UserHealthData(
//           uid: user.uid,
//           name: _nameController.text,
//           age: int.parse(_ageController.text),
//           weight: double.parse(_weightController.text),
//           height: double.parse(_heightController.text),
//           wakeUpTime: _wakeUpTime,
//           bedTime: _bedTime,
//           waterTarget: calculateWaterTarget(
//             weight: double.parse(_weightController.text),
//             age: int.parse(_ageController.text),
//           ),
//           exerciseTarget: 30, // Default 30 minutes
//           sleepTarget: 8, // Default 8 hours
//         );

//         await FirebaseFirestore.instance
//             .collection('patients')
//             .doc(user.uid)
//             .set(userData.toMap());

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MainTrackerScreen()),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving data: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Welcome to Health Tracker')),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Let\'s get to know you better',
//                 //style: Theme.of(context).textTheme.headline5,
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter your name' : null,
//               ),
//               TextFormField(
//                 controller: _ageController,
//                 decoration: InputDecoration(labelText: 'Age'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter your age' : null,
//               ),
//               TextFormField(
//                 controller: _weightController,
//                 decoration: InputDecoration(labelText: 'Weight (kg)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter your weight' : null,
//               ),
//               TextFormField(
//                 controller: _heightController,
//                 decoration: InputDecoration(labelText: 'Height (cm)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter your height' : null,
//               ),
//               ListTile(
//                 title: Text('Wake up time'),
//                 trailing: Text(_wakeUpTime.format(context)),
//                 onTap: () async {
//                   final TimeOfDay? time = await showTimePicker(
//                     context: context,
//                     initialTime: _wakeUpTime,
//                   );
//                   if (time != null) {
//                     setState(() => _wakeUpTime = time);
//                   }
//                 },
//               ),
//               ListTile(
//                 title: Text('Bedtime'),
//                 trailing: Text(_bedTime.format(context)),
//                 onTap: () async {
//                   final TimeOfDay? time = await showTimePicker(
//                     context: context,
//                     initialTime: _bedTime,
//                   );
//                   if (time != null) {
//                     setState(() => _bedTime = time);
//                   }
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveUserData,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 child: Text('Start Tracking'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   int calculateWaterTarget({required double weight, required int age}) {
//     // Base calculation: 30ml per kg of body weight
//     double baseTarget = weight * 30 / 240; // Convert to glasses (240ml)

//     // Adjust based on age
//     if (age > 65) {
//       baseTarget *= 0.9; // Slightly lower for elderly
//     } else if (age < 18) {
//       baseTarget *= 1.1; // Slightly higher for younger people
//     }

//     return baseTarget.round();
//   }
// }

