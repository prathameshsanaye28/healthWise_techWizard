

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthwise/models/prescription_models.dart';
import 'package:healthwise/screens/medicineselection.dart';
import 'package:healthwise/services/medicine_reminder.dart';
import 'package:http/http.dart' as http;

class PrescriptionFormScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  // bool _isLoading = false;
  // String? _effects;
  // String? _recommendation;

  const PrescriptionFormScreen({
    Key? key,
    required this.doctorId,
    required this.patientId,
  }) : super(key: key);

  @override
  _PrescriptionFormScreenState createState() => _PrescriptionFormScreenState();
}

class _PrescriptionFormScreenState extends State<PrescriptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _nextVisit;
  List<PrescribedMedicine> _medicines = [];
  String? _effects;
  String? _recommendation;
  bool _isLoading = false;
  
  @override
Widget build(BuildContext context) { 
  return Scaffold(
    appBar: AppBar(title: const Text('Create Prescription')),
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnosis',
                border: OutlineInputBorder(),
              ),
              validator: (value) => 
                  value?.isEmpty ?? true ? 'Diagnosis is required' : null,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text('Medicines', 
                style: Theme.of(context).textTheme.titleLarge),
            ..._buildMedicinesList(),
            ElevatedButton.icon(
              onPressed: _addMedicine,
              icon: const Icon(Icons.add),
              label: const Text('Add Medicine'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_effects != null && _recommendation != null)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(  // Fixed: Wrap children inside a Column
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Possible effects:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_effects != null && _effects!.isNotEmpty) 
                          ..._effects!.split(", ").map((effect) => Text(
                            "• $effect", // Bullet point formatting
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Recommendation: $_recommendation',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Next Visit'),
              subtitle: Text(_nextVisit?.toString() ?? 'Not set'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectNextVisitDate(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPrescription,
                child: const Text('Create Prescription'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  List<Widget> _buildMedicinesList() {
    return _medicines.map((medicine) => Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(medicine.medicine.name,
                    style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeMedicine(medicine),
                ),
              ],
            ),
            Text('Dosage: ${medicine.medicine.dosage}'),
            Text('Frequency: ${medicine.medicine.frequency}'),
            Text('Duration: ${medicine.medicine.duration} days'),
            Text('Instructions: ${medicine.instructions}'),
            Text('Timing: ${medicine.timing.join(", ")}'),
            Text('Take ${medicine.beforeFood ? "before" : "after"} food'),
          ],
        ),
      ),
    )).toList();
  }

  Future<void> _addMedicine() async {
    final result = await showDialog<PrescribedMedicine>(
      context: context,
      builder: (context) => const MedicineSelectionDialog(),
    );

    if (result != null) {
      setState(() => _medicines.add(result));
      _checkMatch(result.medicine);
    }
  }

  void _removeMedicine(PrescribedMedicine medicine) {
    setState(() => _medicines.remove(medicine));
  }

  Future<void> _selectNextVisitDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _nextVisit ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _nextVisit = picked);
    }
  }

  Future<void> _checkMatch(Medicine medicine) async {
    const String baseUrl = 'http://10.21.3.236:8000';
    setState(() {
      _isLoading = true;
      // Clear previous results when checking new medicine
      _effects = null;
      _recommendation = null;
    });

    try {
      final Map<String, List<String>> inputData = {
        "drugs": ["Naproxen", medicine.name],
      };

      final response = await http.post(
        Uri.parse('$baseUrl/predict_adr'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        print(response.body);
          final Map<String, dynamic> data = jsonDecode(response.body); // Correctly decode JSON
          if (data['adr_detected'] == true) { // Correctly access map values
            setState(() {
              _effects = (data['potential_adverse_effects'] as List<dynamic>).join(", ");
              _recommendation = data['recommendation'];
            });
          }
        } else {
          throw Exception('Failed to predict ADR. Status code: ${response.statusCode}');
        }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }



  Future<void> _submitPrescription() async {
    if (!_formKey.currentState!.validate()) return;
    if (_medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one medicine')),
      );
      return;
    }
    if (_nextVisit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select next visit date')),
      );
      return;
    }

    try {
      final prescription = Prescription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorId: widget.doctorId,
        patientId: widget.patientId,
        date: DateTime.now(),
        medicines: _medicines,
        notes: _notesController.text,
        diagnosis: _diagnosisController.text,
        nextVisit: _nextVisit!,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('prescriptions')
          .doc(prescription.id)
          .set(prescription.toJson());

      // Schedule reminders
      MedicineReminder.scheduleReminders(
        widget.patientId,
        prescription.medicines.cast<Medicine>(),
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription created successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating prescription: $e')),
      );
    }
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
