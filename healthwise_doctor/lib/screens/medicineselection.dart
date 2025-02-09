import 'package:flutter/material.dart';
import 'package:healthwise/models/prescription_models.dart';

class MedicineSelectionDialog extends StatefulWidget {
    //final String patientId;
  const MedicineSelectionDialog({Key? key,
    //required this.patientId
  }) : super(key: key);

  @override
  _MedicineSelectionDialogState createState() => _MedicineSelectionDialogState();
}

class _MedicineSelectionDialogState extends State<MedicineSelectionDialog> {
  final _formKey = GlobalKey<FormState>();
  Medicine? _selectedMedicine;
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  bool _beforeFood = true;
  List<String> _timingOptions = ['Morning', 'Afternoon', 'Evening', 'Night'];
  List<String> _selectedTimings = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Medicine'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMedicineDropdown(),
              const SizedBox(height: 12),
              _buildTextField(_dosageController, 'Dosage (e.g., 500mg)'),
              const SizedBox(height: 12),
              _buildTextField(_frequencyController, 'Frequency (e.g., 2 times a day)'),
              const SizedBox(height: 12),
              _buildTextField(_durationController, 'Duration (in days)', isNumeric: true),
              const SizedBox(height: 12),
              _buildTimingSelection(),
              const SizedBox(height: 12),
              _buildBeforeFoodToggle(),
              const SizedBox(height: 12),
              _buildTextField(_instructionsController, 'Special Instructions (Optional)'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _confirmSelection,
          child: const Text('Add'),
        ),
      ],
    );
  }

  /// Dropdown to select a medicine
  Widget _buildMedicineDropdown() {
  List<Medicine> availableMedicines = [
  Medicine(id: '1', name: 'Paracetamol', dosage: '500mg', frequency: '2 times a day', duration: 5, tabletsPerStrip: 10, price: 400, manufacturer: 'Sun', description: 'For fever'),
  Medicine(id: '2', name: 'Ibuprofen', dosage: '200mg', frequency: '3 times a day', duration: 7, tabletsPerStrip: 10, price: 700, manufacturer: 'Sun', description: 'For pain relief'),
  Medicine(id: '3', name: 'Amoxicillin', dosage: '250mg', frequency: '3 times a day', duration: 7, tabletsPerStrip: 15, price: 550, manufacturer: 'Cipla', description: 'For bacterial infections'),
  Medicine(id: '4', name: 'Metformin', dosage: '500mg', frequency: 'Twice a day', duration: 30, tabletsPerStrip: 20, price: 300, manufacturer: 'Glenmark', description: 'For diabetes management'),
  Medicine(id: '5', name: 'Amlodipine', dosage: '5mg', frequency: 'Once a day', duration: 30, tabletsPerStrip: 15, price: 450, manufacturer: 'Zydus', description: 'For high blood pressure'),
  Medicine(id: '6', name: 'Cetirizine', dosage: '10mg', frequency: 'Once a day', duration: 10, tabletsPerStrip: 10, price: 250, manufacturer: 'Mylan', description: 'For allergies'),
  Medicine(id: '7', name: 'Losartan', dosage: '50mg', frequency: 'Once a day', duration: 30, tabletsPerStrip: 15, price: 500, manufacturer: 'Dr. Reddy\'s', description: 'For hypertension'),
  Medicine(id: '8', name: 'Omeprazole', dosage: '20mg', frequency: 'Once a day', duration: 14, tabletsPerStrip: 14, price: 350, manufacturer: 'Ranbaxy', description: 'For acid reflux'),
  Medicine(id: '9', name: 'Doxycycline', dosage: '100mg', frequency: 'Twice a day', duration: 7, tabletsPerStrip: 10, price: 600, manufacturer: 'Macleods', description: 'For bacterial infections'),
  Medicine(id: '10', name: 'Levothyroxine', dosage: '50mcg', frequency: 'Once a day', duration: 30, tabletsPerStrip: 30, price: 450, manufacturer: 'Elder', description: 'For hypothyroidism'),
];


  // Ensure no duplicate values
  availableMedicines = availableMedicines.toSet().toList();

  return DropdownButtonFormField<Medicine>(
    decoration: const InputDecoration(
      labelText: 'Medicine',
      border: OutlineInputBorder(),
    ),
    items: availableMedicines.map((medicine) {
      return DropdownMenuItem(
        value: medicine,
        child: Text(medicine.name),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedMedicine = value;
        _dosageController.text = value?.dosage ?? '';
        _frequencyController.text = value?.frequency ?? '';
        _durationController.text = value?.duration.toString() ?? '';
      });
    },
    validator: (value) => value == null ? 'Please select a medicine' : null,
  );
}

  /// Text field builder
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => value?.isEmpty ?? true ? '$label is required' : null,
    );
  }

  /// Timing selection (morning, afternoon, etc.)
  Widget _buildTimingSelection() {
    return Wrap(
      spacing: 8,
      children: _timingOptions.map((time) {
        return ChoiceChip(
          label: Text(time),
          selected: _selectedTimings.contains(time),
          onSelected: (selected) {
            setState(() {
              selected ? _selectedTimings.add(time) : _selectedTimings.remove(time);
            });
          },
        );
      }).toList(),
    );
  }

  /// Before/After food toggle
  Widget _buildBeforeFoodToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Take before food?'),
        Switch(
          value: _beforeFood,
          onChanged: (value) {
            setState(() => _beforeFood = value);
          },
        ),
      ],
    );
  }

  /// Confirm and return the selected medicine
  void _confirmSelection() {
    if (_formKey.currentState!.validate() && _selectedMedicine != null && _selectedTimings.isNotEmpty) {
      final prescribedMedicine = PrescribedMedicine(
        medicine: _selectedMedicine!,
        instructions: _instructionsController.text,
        beforeFood: _beforeFood,
        timing: _selectedTimings,
      );

      Navigator.of(context).pop(prescribedMedicine);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields and select at least one timing')),
      );
    }
  }

  @override
  void dispose() {
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}