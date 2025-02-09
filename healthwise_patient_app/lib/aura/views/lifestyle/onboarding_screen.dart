// // import 'package:aura_techwizard/views/lifestyle/lifestlye_screen.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class OnboardingScreen extends StatefulWidget {
// //   @override
// //   _OnboardingScreenState createState() => _OnboardingScreenState();
// // }

// // class _OnboardingScreenState extends State<OnboardingScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _ageController = TextEditingController();
// //   final TextEditingController _weightController = TextEditingController();
// //   final TextEditingController _heightController = TextEditingController();

// //   TimeOfDay _wakeUpTime = TimeOfDay(hour: 6, minute: 0);
// //   TimeOfDay _bedTime = TimeOfDay(hour: 22, minute: 0);
// //   TimeOfDay _workStartTime = TimeOfDay(hour: 9, minute: 0);
// //   TimeOfDay _workEndTime = TimeOfDay(hour: 17, minute: 0);

// //   Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
// //       ValueChanged<TimeOfDay> onTimePicked) async {
// //     final TimeOfDay? time = await showTimePicker(
// //       context: context,
// //       initialTime: initialTime,
// //     );
// //     if (time != null) {
// //       onTimePicked(time);
// //     }
// //   }

// //   Future<void> _saveUserData() async {
// //     if (_formKey.currentState!.validate()) {
// //       try {
// //         final user = FirebaseAuth.instance.currentUser;
// //         if (user == null) return;

// //         final userData = {
// //           'uid': user.uid,
// //           'name': _nameController.text,
// //           'age': int.parse(_ageController.text),
// //           'weight': double.parse(_weightController.text),
// //           'height': double.parse(_heightController.text),
// //           'wakeUpTime': {
// //             'hour': _wakeUpTime.hour,
// //             'minute': _wakeUpTime.minute,
// //           },
// //           'bedTime': {
// //             'hour': _bedTime.hour,
// //             'minute': _bedTime.minute,
// //           },
// //           'workStartTime': {
// //             'hour': _workStartTime.hour,
// //             'minute': _workStartTime.minute,
// //           },
// //           'workEndTime': {
// //             'hour': _workEndTime.hour,
// //             'minute': _workEndTime.minute,
// //           },
// //         };

// //         await FirebaseFirestore.instance
// //             .collection('patients')
// //             .doc(user.uid)
// //             .set(userData);

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => LifestlyeScreen()),
// //         );
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Error saving data: $e')),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Welcome to Health Tracker')),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(16),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'Let\'s get to know you better',
// //               ),
// //               SizedBox(height: 20),
// //               TextFormField(
// //                 controller: _nameController,
// //                 decoration: InputDecoration(labelText: 'Name'),
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Please enter your name' : null,
// //               ),
// //               TextFormField(
// //                 controller: _ageController,
// //                 decoration: InputDecoration(labelText: 'Age'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Please enter your age' : null,
// //               ),
// //               TextFormField(
// //                 controller: _weightController,
// //                 decoration: InputDecoration(labelText: 'Weight (kg)'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Please enter your weight' : null,
// //               ),
// //               TextFormField(
// //                 controller: _heightController,
// //                 decoration: InputDecoration(labelText: 'Height (cm)'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) =>
// //                     value?.isEmpty ?? true ? 'Please enter your height' : null,
// //               ),
// //               ListTile(
// //                 title: Text('Wake-up Time'),
// //                 trailing: Text(_wakeUpTime.format(context)),
// //                 onTap: () => _selectTime(context, _wakeUpTime, (time) {
// //                   setState(() => _wakeUpTime = time);
// //                 }),
// //               ),
// //               ListTile(
// //                 title: Text('Bed Time'),
// //                 trailing: Text(_bedTime.format(context)),
// //                 onTap: () => _selectTime(context, _bedTime, (time) {
// //                   setState(() => _bedTime = time);
// //                 }),
// //               ),
// //               ListTile(
// //                 title: Text('Work Start Time'),
// //                 trailing: Text(_workStartTime.format(context)),
// //                 onTap: () => _selectTime(context, _workStartTime, (time) {
// //                   setState(() => _workStartTime = time);
// //                 }),
// //               ),
// //               ListTile(
// //                 title: Text('Work End Time'),
// //                 trailing: Text(_workEndTime.format(context)),
// //                 onTap: () => _selectTime(context, _workEndTime, (time) {
// //                   setState(() => _workEndTime = time);
// //                 }),
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _saveUserData,
// //                 child: Text('Save & Start Tracking'),
// //                 style: ElevatedButton.styleFrom(
// //                   minimumSize: Size(double.infinity, 50),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:aura_techwizard/views/lifestyle/lifestlye_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OnboardingScreen extends StatefulWidget {
//   final bool isEditing;
//   final Map<String, dynamic>? userData;

//   const OnboardingScreen({
//     Key? key,
//     this.isEditing = false,
//     this.userData,
//   }) : super(key: key);

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
//   TimeOfDay _workStartTime = TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay _workEndTime = TimeOfDay(hour: 17, minute: 0);

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditing && widget.userData != null) {
//       _loadUserData();
//     }
//   }

//   void _loadUserData() {
//     final data = widget.userData!;
//     _nameController.text = data['name'] ?? '';
//     _ageController.text = (data['age'] ?? '').toString();
//     _weightController.text = (data['weight'] ?? '').toString();
//     _heightController.text = (data['height'] ?? '').toString();

//     if (data['wakeUpTime'] != null) {
//       _wakeUpTime = TimeOfDay(
//         hour: data['wakeUpTime']['hour'] ?? 6,
//         minute: data['wakeUpTime']['minute'] ?? 0,
//       );
//     }
//     if (data['bedTime'] != null) {
//       _bedTime = TimeOfDay(
//         hour: data['bedTime']['hour'] ?? 22,
//         minute: data['bedTime']['minute'] ?? 0,
//       );
//     }
//     if (data['workStartTime'] != null) {
//       _workStartTime = TimeOfDay(
//         hour: data['workStartTime']['hour'] ?? 9,
//         minute: data['workStartTime']['minute'] ?? 0,
//       );
//     }
//     if (data['workEndTime'] != null) {
//       _workEndTime = TimeOfDay(
//         hour: data['workEndTime']['hour'] ?? 17,
//         minute: data['workEndTime']['minute'] ?? 0,
//       );
//     }
//   }

//   Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
//       ValueChanged<TimeOfDay> onTimePicked) async {
//     final TimeOfDay? time = await showTimePicker(
//       context: context,
//       initialTime: initialTime,
//     );
//     if (time != null) {
//       onTimePicked(time);
//     }
//   }

//   Future<void> _saveUserData() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final user = FirebaseAuth.instance.currentUser;
//         if (user == null) return;

//         final userData = {
//           'uid': user.uid,
//           'name': _nameController.text,
//           'age': int.parse(_ageController.text),
//           'weight': double.parse(_weightController.text),
//           'height': double.parse(_heightController.text),
//           'wakeUpTime': {
//             'hour': _wakeUpTime.hour,
//             'minute': _wakeUpTime.minute,
//           },
//           'bedTime': {
//             'hour': _bedTime.hour,
//             'minute': _bedTime.minute,
//           },
//           'workStartTime': {
//             'hour': _workStartTime.hour,
//             'minute': _workStartTime.minute,
//           },
//           'workEndTime': {
//             'hour': _workEndTime.hour,
//             'minute': _workEndTime.minute,
//           },
//         };

//         await FirebaseFirestore.instance
//             .collection('patients')
//             .doc(user.uid)
//             .set(userData);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LifestlyeScreen()),
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
//       appBar: AppBar(
//         title: Text(widget.isEditing ? 'Edit Profile' : 'Welcome to Health Tracker'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.isEditing
//                     ? 'Update your information'
//                     : 'Let\'s get to know you better',
//                 style: Theme.of(context).textTheme.titleLarge,
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
//                 title: Text('Wake-up Time'),
//                 trailing: Text(_wakeUpTime.format(context)),
//                 onTap: () => _selectTime(context, _wakeUpTime, (time) {
//                   setState(() => _wakeUpTime = time);
//                 }),
//               ),
//               ListTile(
//                 title: Text('Bed Time'),
//                 trailing: Text(_bedTime.format(context)),
//                 onTap: () => _selectTime(context, _bedTime, (time) {
//                   setState(() => _bedTime = time);
//                 }),
//               ),
//               ListTile(
//                 title: Text('Work Start Time'),
//                 trailing: Text(_workStartTime.format(context)),
//                 onTap: () => _selectTime(context, _workStartTime, (time) {
//                   setState(() => _workStartTime = time);
//                 }),
//               ),
//               ListTile(
//                 title: Text('Work End Time'),
//                 trailing: Text(_workEndTime.format(context)),
//                 onTap: () => _selectTime(context, _workEndTime, (time) {
//                   setState(() => _workEndTime = time);
//                 }),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveUserData,
//                 child: Text(widget.isEditing ? 'Update Profile' : 'Save & Start Tracking'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
