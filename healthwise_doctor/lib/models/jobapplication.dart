
import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String? id;
  final String title;
  final String facility;
  final String region;
  final int yearsExperienceRequired;
  final List<String> requiredSpecializations;
  final List<String> requiredCertifications;
  final List<String> requiredProcedures;
  final List<String> treatedConditions;
  final String description;
  final DateTime postedDate;

  JobApplication({
    this.id,
    required this.title,
    required this.facility,
    required this.region,
    required this.yearsExperienceRequired,
    required this.requiredSpecializations,
    required this.requiredCertifications,
    required this.requiredProcedures,
    required this.treatedConditions,
    required this.description,
    required this.postedDate,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'facility': facility,
    'region': region,
    'yearsExperienceRequired': yearsExperienceRequired,
    'requiredSpecializations': requiredSpecializations,
    'requiredCertifications': requiredCertifications,
    'requiredProcedures': requiredProcedures,
    'treatedConditions': treatedConditions,
    'description': description,
    'postedDate': postedDate.toIso8601String(),
  };

  static JobApplication fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return JobApplication(
      id: snap.id,
      title: snapshot['title'] ?? '',
      facility: snapshot['facility'] ?? '',
      region: snapshot['region'] ?? '',
      yearsExperienceRequired: snapshot['yearsExperienceRequired'] ?? 0,
      requiredSpecializations: List<String>.from(snapshot['requiredSpecializations'] ?? []),
      requiredCertifications: List<String>.from(snapshot['requiredCertifications'] ?? []),
      requiredProcedures: List<String>.from(snapshot['requiredProcedures'] ?? []),
      treatedConditions: List<String>.from(snapshot['treatedConditions'] ?? []),
      description: snapshot['description'] ?? '',
      postedDate: DateTime.parse(snapshot['postedDate']),
    );
  }
}