// // lib/screens/edit_user_data_screen.dart
// import 'package:aura_techwizard/views/CircadianScreens/OnBoardingScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class EditUserDataScreen extends StatefulWidget {
//   final UserHealthData userData;

//   const EditUserDataScreen({super.key, required this.userData});

//   @override
//   _EditUserDataScreenState createState() => _EditUserDataScreenState();
// }

// class _EditUserDataScreenState extends State<EditUserDataScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _ageController;
//   late TextEditingController _weightController;
//   late TextEditingController _heightController;
//   late TextEditingController _waterTargetController;
//   late TextEditingController _exerciseTargetController;
//   late TextEditingController _sleepTargetController;
//   late TimeOfDay _wakeUpTime;
//   late TimeOfDay _bedTime;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.userData.name);
//     _ageController =
//         TextEditingController(text: widget.userData.age.toString());
//     _weightController =
//         TextEditingController(text: widget.userData.weight.toString());
//     _heightController =
//         TextEditingController(text: widget.userData.height.toString());
//     _waterTargetController =
//         TextEditingController(text: widget.userData.waterTarget.toString());
//     _exerciseTargetController =
//         TextEditingController(text: widget.userData.exerciseTarget.toString());
//     _sleepTargetController =
//         TextEditingController(text: widget.userData.sleepTarget.toString());
//     _wakeUpTime = widget.userData.wakeUpTime;
//     _bedTime = widget.userData.bedTime;
//   }

//   Future<void> _updateUserData() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final user = FirebaseAuth.instance.currentUser;
//         if (user == null) return;

//         final updatedUserData = UserHealthData(
//           uid: user.uid,
//           name: _nameController.text,
//           age: int.parse(_ageController.text),
//           weight: double.parse(_weightController.text),
//           height: double.parse(_heightController.text),
//           wakeUpTime: _wakeUpTime,
//           bedTime: _bedTime,
//           waterTarget: int.parse(_waterTargetController.text),
//           exerciseTarget: int.parse(_exerciseTargetController.text),
//           sleepTarget: int.parse(_sleepTargetController.text),
//         );

//         await FirebaseFirestore.instance
//             .collection('patients')
//             .doc(user.uid)
//             .update(updatedUserData.toMap());

//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating data: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Edit Health Data')),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
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
//               TextFormField(
//                 controller: _waterTargetController,
//                 decoration:
//                     InputDecoration(labelText: 'Water Target (glasses)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter water target' : null,
//               ),
//               TextFormField(
//                 controller: _exerciseTargetController,
//                 decoration:
//                     InputDecoration(labelText: 'Exercise Target (minutes)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) => value?.isEmpty ?? true
//                     ? 'Please enter exercise target'
//                     : null,
//               ),
//               TextFormField(
//                 controller: _sleepTargetController,
//                 decoration: InputDecoration(labelText: 'Sleep Target (hours)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter sleep target' : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateUserData,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 child: Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
