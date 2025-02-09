// import 'package:flutter/material.dart';
// import 'package:netwealth_vjti/models/doctor.dart';
// import 'package:netwealth_vjti/resources/auth_methods.dart';

// class UserProvider with ChangeNotifier {
//   Doctor? _user;
//   final AuthMethods _authMethods = AuthMethods();

//   Doctor? get getUser => _user;

//   // Initialize user
//   Future<void> initialize() async {
//     try {
//       await refreshUserFromAuth();
//     } catch (e) {
//       print('Error initializing user provider: $e');
//     }
//   }

//   // Update user with validation
//   Future<void> updateUser(Doctor updatedUser) async {
//     try {
//       // Validate that required fields are not null
//       if (updatedUser.name == null || 
//           updatedUser.jurisdiction == null || 
//           updatedUser.yearsExperience == null) {
//         throw Exception('Required fields cannot be null');
//       }

//       // Create a new Professional object with validated data
//       _user = Doctor(
//         id: updatedUser.id ?? _user?.id,
//         name: updatedUser.name,
//         email: updatedUser.email ?? _user?.email,
//         phone: updatedUser.phone ?? _user?.phone,
//         role: updatedUser.role,
//         technicalSkills: updatedUser.technicalSkills.isNotEmpty 
//             ? updatedUser.technicalSkills 
//             : _user?.technicalSkills ?? [],
//         regulatoryExpertise: updatedUser.regulatoryExpertise.isNotEmpty 
//             ? updatedUser.regulatoryExpertise 
//             : _user?.regulatoryExpertise ?? [],
//         financialStandards: updatedUser.financialStandards.isNotEmpty 
//             ? updatedUser.financialStandards 
//             : _user?.financialStandards ?? [],
//         industryFocus: updatedUser.industryFocus.isNotEmpty 
//             ? updatedUser.industryFocus 
//             : _user?.industryFocus ?? [],
//         jurisdiction: updatedUser.jurisdiction,
//         yearsExperience: updatedUser.yearsExperience,
//         photoUrl: updatedUser.photoUrl ?? _user?.photoUrl
//       );

//       notifyListeners();
//     } catch (e) {
//       print('Error updating user: $e');
//       rethrow;
//     }
//   }

//   // Refresh user with provided data or fetch from auth
//   Future<void> refreshUser([Doctor? updatedUser]) async {
//     try {
//       if (updatedUser != null) {
//         await updateUser(updatedUser);
//       } else {
//         await refreshUserFromAuth();
//       }
//     } catch (e) {
//       print('Error in refreshUser: $e');
//       rethrow;
//     }
//   }

//   // Refresh user from authentication
//   Future<void> refreshUserFromAuth() async {
//     try {
//       final userDetails = await _authMethods.getUserDetails();
      
//       // Validate the user details
//       if (userDetails.name == null || 
//           userDetails.jurisdiction == null || 
//           userDetails.yearsExperience == null) {
//         throw Exception('Invalid user details from auth');
//       }

//       _user = Doctor(
//         id: userDetails.id,
//         name: userDetails.name,
//         email: userDetails.email,
//         phone: userDetails.phone,
//         role: userDetails.role,
//         technicalSkills: userDetails.technicalSkills,
//         regulatoryExpertise: userDetails.regulatoryExpertise,
//         financialStandards: userDetails.financialStandards,
//         industryFocus: userDetails.industryFocus,
//         jurisdiction: userDetails.jurisdiction,
//         yearsExperience: userDetails.yearsExperience,
//         photoUrl: userDetails.photoUrl
//       );

//       notifyListeners();
//     } catch (e) {
//       print('Error in refreshUserFromAuth: $e');
//       rethrow;
//     }
//   }

//   // Clear user data
//   void clearUser() {
//     _user = null;
//     notifyListeners();
//   }

//   // Check if user is initialized
//   bool get isUserInitialized => _user != null;

//   // Validate user data
//   bool validateUserData() {
//     if (_user == null) return false;
    
//     return _user!.name != null &&
//            _user!.jurisdiction != null &&
//            _user!.yearsExperience != null &&
//            _user!.technicalSkills.isNotEmpty &&
//            _user!.regulatoryExpertise.isNotEmpty &&
//            _user!.financialStandards.isNotEmpty &&
//            _user!.industryFocus.isNotEmpty;
//   }
// }


import 'package:flutter/material.dart';
import 'package:healthwise/models/doctor.dart';
import 'package:healthwise/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Doctor? _user;
  final AuthMethods _authMethods = AuthMethods();

  Doctor? get getUser => _user;

  // Initialize user
  Future<void> initialize() async {
    try {
      await refreshUserFromAuth();
    } catch (e) {
      print('Error initializing user provider: $e');
    }
  }

  // Update user with validation
  Future<void> updateUser(Doctor updatedUser) async {
    try {
      // Validate that required fields are not null
      if (updatedUser.name == null || 
          updatedUser.region.isEmpty || 
          updatedUser.yearsExperience == 0) {
        throw Exception('Required fields cannot be null or empty');
      }

      // Create a new Doctor object with validated data
      _user = Doctor(
        id: updatedUser.id ?? _user?.id,
        name: updatedUser.name,
        email: updatedUser.email ?? _user?.email,
        phone: updatedUser.phone ?? _user?.phone,
        role: updatedUser.role,
        specializations: updatedUser.specializations.isNotEmpty
            ? updatedUser.specializations
            : _user?.specializations ?? [],
        certifications: updatedUser.certifications.isNotEmpty
            ? updatedUser.certifications
            : _user?.certifications ?? [],
        procedures: updatedUser.procedures.isNotEmpty
            ? updatedUser.procedures
            : _user?.procedures ?? [],
        conditions: updatedUser.conditions.isNotEmpty
            ? updatedUser.conditions
            : _user?.conditions ?? [],
        region: updatedUser.region,
        yearsExperience: updatedUser.yearsExperience,
        photoUrl: updatedUser.photoUrl ?? _user?.photoUrl,
      );

      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Refresh user with provided data or fetch from auth
  Future<void> refreshUser([Doctor? updatedUser]) async {
    try {
      if (updatedUser != null) {
        await updateUser(updatedUser);
      } else {
        await refreshUserFromAuth();
      }
    } catch (e) {
      print('Error in refreshUser: $e');
      rethrow;
    }
  }

  // Refresh user from authentication
  Future<void> refreshUserFromAuth() async {
    try {
      final userDetails = await _authMethods.getUserDetails();

      // Validate the user details
      if (userDetails.name == null || 
          userDetails.region.isEmpty || 
          userDetails.yearsExperience == 0) {
        throw Exception('Invalid user details from auth');
      }

      _user = Doctor(
        id: userDetails.id,
        name: userDetails.name,
        email: userDetails.email,
        phone: userDetails.phone,
        role: userDetails.role,
        specializations: userDetails.specializations,
        certifications: userDetails.certifications,
        procedures: userDetails.procedures,
        conditions: userDetails.conditions,
        region: userDetails.region,
        yearsExperience: userDetails.yearsExperience,
        photoUrl: userDetails.photoUrl,
      );

      notifyListeners();
    } catch (e) {
      print('Error in refreshUserFromAuth: $e');
      rethrow;
    }
  }

  // Clear user data
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Check if user is initialized
  bool get isUserInitialized => _user != null;

  // Validate user data
  bool validateUserData() {
    if (_user == null) return false;

    return _user!.name != null &&
           _user!.region.isNotEmpty &&
           _user!.yearsExperience > 0 &&
           _user!.specializations.isNotEmpty &&
           _user!.certifications.isNotEmpty &&
           _user!.procedures.isNotEmpty &&
           _user!.conditions.isNotEmpty;
  }
}