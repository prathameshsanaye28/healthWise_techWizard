import 'dart:typed_data';

//import 'package:aura_techwizard/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as model;
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.Patient> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('patients').doc(currentUser.uid).get();

    return model.Patient.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String fullname,
    required String contactnumber,
    required Uint8List file,
    required int age,
    required double weight,
    required double height,
    required String wakeUpTime,
    required String bedTime,
    required String workStartTime,
    required String workEndTime,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          fullname.isNotEmpty &&
          contactnumber.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.Patient user = model.Patient(
          uid: cred.user!.uid,
          username: username,
          email: email,
          fullname: fullname,
          photoUrl: photoUrl,
          contactnumber: contactnumber,
          age: age,
          weight: weight,
          height: height,
          wakeUpTime: wakeUpTime,
          bedTime: bedTime,
          workStartTime: workStartTime,
          workEndTime: workEndTime,
        );

        await _firestore
            .collection('patients')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is invalid';
      }
      if (err.code == 'weak-password') {
        res = 'Password is weak';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging in
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all details';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
