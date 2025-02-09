// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:healthwise/models/prescription_models.dart';

// class MedicineReminder {
//   static Future<void> scheduleReminders(
//     String userId,
//     List<Medicine> medicines,
//     [Map<String, int>? quantities]
//   ) async {
//     final notificationService = NotificationService();
//     await notificationService.init();

//     for (var medicine in medicines) {
//       int strips = quantities?[medicine.id] ?? medicine.calculateRequiredStrips();
//       int tabletsPerDay = _calculateTabletsPerDay(medicine.frequency);
//       int totalTablets = medicine.tabletsPerStrip * strips;
//       int daysUntilEmpty = totalTablets ~/ tabletsPerDay;

//       // Schedule reminder 2 days before running out
//       if (daysUntilEmpty > 2) {
//         DateTime reminderDate = DateTime.now().add(
//           Duration(days: daysUntilEmpty - 2),
//         );

//         await notificationService.scheduleMedicineReminder(
//           userId: userId,
//           medicine: medicine,
//           reminderDate: reminderDate,
//         );

//         // Add reminder to Firestore
//         await _saveReminderToFirestore(
//           userId: userId,
//           medicine: medicine,
//           reminderDate: reminderDate,
//         );
//       }
//     }
//   }

//   static int _calculateTabletsPerDay(String frequency) {
//     final regExp = RegExp(r'(\d+)');
//     final match = regExp.firstMatch(frequency);
//     return match != null ? int.parse(match.group(1)!) : 1;
//   }

//   static Future<void> _saveReminderToFirestore({
//     required String userId,
//     required Medicine medicine,
//     required DateTime reminderDate,
//   }) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('reminders')
//         .add({
//       'medicineId': medicine.id,
//       'medicineName': medicine.name,
//       'reminderDate': reminderDate.toIso8601String(),
//       'status': 'scheduled',
//       'createdAt': DateTime.now().toIso8601String(),
//     });
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:healthwise/models/prescription_models.dart';

// // class MedicineReminderBar extends StatelessWidget {
// //   final String userId;
// //   final Function(Medicine) onTap;

// //   const MedicineReminderBar({
// //     Key? key,
// //     required this.userId,
// //     required this.onTap,
// //   }) : super(key: key);

// //   Stream<List<Map<String, dynamic>>> _getReminderStream() {
// //     return FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('reminders')
// //         .where('status', isEqualTo: 'scheduled')
// //         .where('reminderDate', isGreaterThan: DateTime.now().toIso8601String())
// //         .snapshots()
// //         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<List<Map<String, dynamic>>>(
// //       stream: _getReminderStream(),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //           return const SizedBox.shrink();
// //         }

// //         final reminder = snapshot.data!.first;
// //         final reminderDate = DateTime.parse(reminder['reminderDate']);
// //         final daysUntilEmpty = reminderDate.difference(DateTime.now()).inDays;

// //         return GestureDetector(
// //           onTap: () {
// //             // Create a Medicine object from the reminder data
// //             final medicine = Medicine(
// //               id: reminder['medicineId'],
// //               name: reminder['medicineName'],
// //               dosage: reminder['dosage'],
// //               description: reminder['description'],
// //               duration: reminder['duration'],
// //               frequency: reminder['frequency'],
// //               manufacturer: reminder['manufacturer'],
// //               price: reminder['price'],
// //               tabletsPerStrip: reminder['tabletsPerStrip']
// //               // Add other required Medicine properties here
// //             );
// //             onTap(medicine);
// //           },
// //           child: Container(
// //             padding: const EdgeInsets.all(16),
// //             margin: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: Theme.of(context).colorScheme.surface,
// //               borderRadius: BorderRadius.circular(8),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.1),
// //                   blurRadius: 4,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.medication_outlined),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Text(
// //                         'Medicine Reminder',
// //                         style: Theme.of(context).textTheme.titleMedium,
// //                       ),
// //                       Text(
// //                         'Your ${reminder['medicineName']} will run out in $daysUntilEmpty days',
// //                         style: Theme.of(context).textTheme.bodyMedium,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const Icon(Icons.chevron_right),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthwise_patient_app/patient_base/models/prescription_models.dart';

class MedicineReminder {
  static Future<void> scheduleReminders(String userId, List<Medicine> medicines,
      [Map<String, int>? quantities]) async {
    for (var medicine in medicines) {
      int strips =
          quantities?[medicine.id] ?? medicine.calculateRequiredStrips();
      int tabletsPerDay = _calculateTabletsPerDay(medicine.frequency);
      int totalTablets = medicine.tabletsPerStrip * strips;
      int daysUntilEmpty = totalTablets ~/ tabletsPerDay;

      // Schedule reminder 2 days before running out
      if (daysUntilEmpty > 2) {
        DateTime reminderDate = DateTime.now().add(
          Duration(days: daysUntilEmpty - 2),
        );

        await _saveReminderToFirestore(
          userId: userId,
          medicine: medicine,
          reminderDate: reminderDate,
        );
      }
    }
  }

  static int _calculateTabletsPerDay(String frequency) {
    final regExp = RegExp(r'(\d+)');
    final match = regExp.firstMatch(frequency);
    return match != null ? int.parse(match.group(1)!) : 1;
  }

  static Future<void> _saveReminderToFirestore({
    required String userId,
    required Medicine medicine,
    required DateTime reminderDate,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .add({
      'medicineId': medicine.id,
      'medicineName': medicine.name,
      'reminderDate': reminderDate.toIso8601String(),
      'status': 'scheduled',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
