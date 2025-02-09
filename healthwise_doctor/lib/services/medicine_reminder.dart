

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthwise/models/prescription_models.dart';
import 'package:intl/intl.dart';

class MedicineReminder {
  static Future<void> scheduleReminders(
    String userId,
    List<Medicine> medicines,
    [Map<String, int>? quantities]
  ) async {
    for (var medicine in medicines) {
      int strips = quantities?[medicine.id] ?? medicine.calculateRequiredStrips();
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