
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:netwealth_vjti/models/doctor.dart' as model;
// import 'package:netwealth_vjti/resources/storage_methods.dart';


// class AuthMethods{
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     Future<model.Doctor> getUserDetails() async {
//     User currentUser = _auth.currentUser!;
//     DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
//     return model.Doctor(name: name, region: region, yearsExperience: yearsExperience).fromSnap(snap);
//   }

//   Future<String> signUpUser({
//     required String email,
//     required String password,
//     required String name,
//     required String phone,
//     required Uint8List file,
//     required String jurisdiction,
//     required int yearsExperience,
//     required List<String> financialStandards,
//     required List<String> industryFocus,
//     required List<String> regulatoryExpertise,
//     required String role,
//     required List<String> technicalSkills,
//   }) async {
//     String res = "Some error occurred";
//     try {
//       if (email.isNotEmpty && 
//           password.isNotEmpty && 
//           name.isNotEmpty && 
//           phone.isNotEmpty && 
//           file != null) {
//         UserCredential cred = await _auth.createUserWithEmailAndPassword(
//           email: email, 
//           password: password
//         );
        
//         String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

//         model.Professional user = model.Professional(
//           id: cred.user!.uid,
//           name: name,
//           email: email,
//           jurisdiction: jurisdiction,
//           photoUrl: photoUrl,
//           yearsExperience: yearsExperience,
//           financialStandards: financialStandards,
//           industryFocus: industryFocus,
//           phone: phone,
//           regulatoryExpertise: regulatoryExpertise,
//           role: role,
//           technicalSkills: technicalSkills,
          
//         );

//         await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
//         res = 'success';
//       } 
//     } on FirebaseAuthException catch(err) {
//       if (err.code == 'invalid-email') {
//         res = 'The email is invalid';
//       }
//       if (err.code == 'weak-password') {
//         res = 'Password is weak';
//       }
//     } catch(err) {
//       res = err.toString();
//     }
//     return res;
//   }
//   //logging in
//   Future<String> loginUser({
//     required String email,
//     required String password
//   })async{
//     String res = 'Some error occured';
//     try{
//       if(email.isNotEmpty || password.isNotEmpty)
//       {
//         await _auth.signInWithEmailAndPassword(email: email, password: password);
//         res = 'success';
//       }
//       else{
//         res = 'Please enter all details';
//       }
//     }
//     catch(err){
//       res = err.toString();
//     }
//     return res;
//   }
  
//   Future<void> signOut() async {
//   try {
//     await FirebaseAuth.instance.signOut();
//     print('User signed out successfully');
//   } catch (e) {
//     print('Error signing out: $e');
//   }
// }


// }


import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthwise/models/doctor.dart' as model;
import 'package:healthwise/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user details
  Future<model.Doctor> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.Doctor.fromSnap(snap);
  }

  // Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Uint8List file,
    required String region,
    required int yearsExperience,
    required List<String> specializations,
    required List<String> certifications,
    required List<String> procedures,
    required List<String> conditions,
    String role = 'Doctor',
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty &&
          phone.isNotEmpty &&
          region.isNotEmpty &&
          file != null) {
        // Create user in Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload profile picture and get the URL
        String photoUrl = await StorageMethods().uploadImageToStorage(
          'profilePics',
          file,
          false,
        );

        // Create a new Doctor instance
        model.Doctor user = model.Doctor(
          id: cred.user!.uid,
          name: name,
          email: email,
          phone: phone,
          role: role,
          specializations: specializations,
          certifications: certifications,
          procedures: procedures,
          conditions: conditions,
          region: region,
          yearsExperience: yearsExperience,
          photoUrl: photoUrl,
        );

        // Store user data in Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      } else {
        res = 'Please fill in all required fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is invalid';
      } else if (err.code == 'weak-password') {
        res = 'The password is too weak';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all details';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}