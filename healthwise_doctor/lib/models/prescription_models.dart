class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final int duration;
  final int tabletsPerStrip;
  final double price;
  final String manufacturer;
  final String description;
  
  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.tabletsPerStrip,
    required this.price,
    required this.manufacturer,
    required this.description,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Medicine && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dosage': dosage,
    'frequency': frequency,
    'duration': duration,
    'tabletsPerStrip': tabletsPerStrip,
    'price': price,
    'manufacturer': manufacturer,
    'description': description,
  };

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id'],
    name: json['name'],
    dosage: json['dosage'],
    frequency: json['frequency'],
    duration: json['duration'],
    tabletsPerStrip: json['tabletsPerStrip'],
    price: json['price'],
    manufacturer: json['manufacturer'],
    description: json['description'],
  );

  int calculateRequiredStrips() {
    int tabletsPerDay = _calculateTabletsPerDay();
    int totalTabletsNeeded = tabletsPerDay * duration;
    return (totalTabletsNeeded / tabletsPerStrip).ceil();
  }

  int _calculateTabletsPerDay() {
    final regExp = RegExp(r'(\d+)');
    final match = regExp.firstMatch(frequency);
    return match != null ? int.parse(match.group(1)!) : 1;
  }

  double calculateTotalCost(int strips) {
    return price * strips;
  }
}

class Prescription {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime date;
  final List<PrescribedMedicine> medicines;
  final String notes;
  final String diagnosis;
  final DateTime nextVisit;

  Prescription({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.medicines,
    required this.notes,
    required this.diagnosis,
    required this.nextVisit,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'patientId': patientId,
    'date': date.toIso8601String(),
    'medicines': medicines.map((m) => m.toJson()).toList(),
    'notes': notes,
    'diagnosis': diagnosis,
    'nextVisit': nextVisit.toIso8601String(),
  };

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
    id: json['id'],
    doctorId: json['doctorId'],
    patientId: json['patientId'],
    date: DateTime.parse(json['date']),
    medicines: (json['medicines'] as List)
        .map((m) => PrescribedMedicine.fromJson(m))
        .toList(),
    notes: json['notes'],
    diagnosis: json['diagnosis'],
    nextVisit: DateTime.parse(json['nextVisit']),
  );
}

class PrescribedMedicine {
  final Medicine medicine;
  final String instructions;
  final bool beforeFood;
  final List<String> timing;

  PrescribedMedicine({
    required this.medicine,
    required this.instructions,
    required this.beforeFood,
    required this.timing,
  });

  Map<String, dynamic> toJson() => {
    'medicine': medicine.toJson(),
    'instructions': instructions,
    'beforeFood': beforeFood,
    'timing': timing,
  };

  factory PrescribedMedicine.fromJson(Map<String, dynamic> json) => PrescribedMedicine(
    medicine: Medicine.fromJson(json['medicine']),
    instructions: json['instructions'],
    beforeFood: json['beforeFood'],
    timing: List<String>.from(json['timing']),
  );
}