import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class HeartRiskInputScreen extends StatefulWidget {
  const HeartRiskInputScreen({super.key});

  @override
  State<HeartRiskInputScreen> createState() => _HeartRiskInputScreenState();
}

class _HeartRiskInputScreenState extends State<HeartRiskInputScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool? _riskStatus;
  String? _prediction;

  // Form Controllers
  final _ageController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _maxHeartRateController = TextEditingController();
  final _oldpeakController = TextEditingController();

  // Arrays for dropdown options
  final List<String> _sexOptions = ['Female', 'Male'];
  final List<String> _chestPainTypes = [
    'Typical angina',
    'Atypical angina',
    'Non-anginal pain',
  ];
  final List<String> _restEcgOptions = [
    'Normal',
    'ST-T wave abnormality',
  ];
  final List<String> _slopeOptions = [
    'Upsloping',
    'Flat',
  ];
  final List<String> _vesselOptions = [
    'Zero',
    'One',
    'Two',
    'Three',
  ];
  final List<String> _thalassemiaOptions = [
    'Normal',
    'No',
    'Reversable Defect',
  ];

  // Validation ranges for numeric inputs
  final Map<String, List<num>> _validationRanges = {
    'age': [1, 120],
    'bloodPressure': [80, 200],
    'cholesterol': [100, 500],
    'maxHeartRate': [60, 220],
    'oldpeak': [0, 10],
  };

  // Form Values
  String _sex = 'Female';
  bool _fastingBloodSugar = false;
  bool _exerciseAngina = false;
  String _chestPainType = 'Typical angina';
  String _restEcg = 'Normal';
  String _slope = 'Upsloping';
  String _vessels = 'Zero';
  String _thalassemia = 'Normal';

  @override
  void dispose() {
    _ageController.dispose();
    _bloodPressureController.dispose();
    _cholesterolController.dispose();
    _maxHeartRateController.dispose();
    _oldpeakController.dispose();
    super.dispose();
  }

  String? _validateNumericInput(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${field.toLowerCase()}';
    }
    
    num numValue;
    try {
      numValue = field == 'oldpeak' ? double.parse(value) : int.parse(value);
    } catch (e) {
      return 'Please enter a valid number';
    }

    final range = _validationRanges[field]!;
    if (numValue < range[0] || numValue > range[1]) {
      return 'Please enter a value between ${range[0]} and ${range[1]}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Disease Risk Assessment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    SizedBox(height: 20),
                    _buildMedicalSection(),
                    SizedBox(height: 20),
                    _buildDiagnosticSection(),
                    SizedBox(height: 32),
                    _isLoading
                    ? Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.grey[200],
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSubmitButton(),
                        SizedBox(height: 20),
                        if (_riskStatus != null && _prediction != null)
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Risk Status: $_riskStatus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Prediction: $_prediction',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => _validateNumericInput(value, 'age'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _sex,
              decoration: InputDecoration(
                labelText: 'Sex',
                border: OutlineInputBorder(),
              ),
              items: _sexOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _sex = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _bloodPressureController,
              decoration: InputDecoration(
                labelText: 'Resting Blood Pressure (mmHg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => _validateNumericInput(value, 'bloodPressure'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _cholesterolController,
              decoration: InputDecoration(
                labelText: 'Cholesterol (mg/dl)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => _validateNumericInput(value, 'cholesterol'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _maxHeartRateController,
              decoration: InputDecoration(
                labelText: 'Maximum Heart Rate',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => _validateNumericInput(value, 'maxHeartRate'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _oldpeakController,
              decoration: InputDecoration(
                labelText: 'ST Depression (Oldpeak)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) => _validateNumericInput(value, 'oldpeak'),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Fasting Blood Sugar > 120 mg/dl'),
              value: _fastingBloodSugar,
              onChanged: (value) => setState(() => _fastingBloodSugar = value),
            ),
            SwitchListTile(
              title: Text('Exercise Induced Angina'),
              value: _exerciseAngina,
              onChanged: (value) => setState(() => _exerciseAngina = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnostic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _chestPainType,
              decoration: InputDecoration(
                labelText: 'Chest Pain Type',
                border: OutlineInputBorder(),
              ),
              items: _chestPainTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _chestPainType = value!),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _restEcg,
              decoration: InputDecoration(
                labelText: 'Resting ECG Results',
                border: OutlineInputBorder(),
              ),
              items: _restEcgOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _restEcg = value!),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _slope,
              decoration: InputDecoration(
                labelText: 'ST Segment Slope',
                border: OutlineInputBorder(),
              ),
              items: _slopeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _slope = value!),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _vessels,
              decoration: InputDecoration(
                labelText: 'Number of Vessels (Flourosopy)',
                border: OutlineInputBorder(),
              ),
              items: _vesselOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _vessels = value!),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _thalassemia,
              decoration: InputDecoration(
                labelText: 'Thalassemia',
                border: OutlineInputBorder(),
              ),
              items: _thalassemiaOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _thalassemia = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.medical_services),
        label: Text('Calculate Risk'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        onPressed: _submitForm,
      ),
    );
  }

  void _submitForm() async {
    const String baseUrl = 'http://10.21.3.236:8000';
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    //Future.delayed( Duration(seconds: 2), () {
     
    //});
    try {
      // Create the data structure matching your model input
          await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds

      final Map<String, List<dynamic>> inputData = {
        "age": [int.parse(_ageController.text)],
        "sex": [_sex == 'Male' ? 1 : 0],
        "resting_blood_pressure": [int.parse(_bloodPressureController.text)],
        "cholestoral": [int.parse(_cholesterolController.text)],
        "fasting_blood_sugar": [_fastingBloodSugar ? 1 : 0],
        "Max_heart_rate": [int.parse(_maxHeartRateController.text)],
        "exercise_induced_angina": [_exerciseAngina ? 1 : 0],
        "oldpeak": [double.parse(_oldpeakController.text)],
        "chest_pain_type_Atypical angina": [_chestPainType == 'Atypical angina' ? 1 : 0],
        "chest_pain_type_Non-anginal pain": [_chestPainType == 'Non-anginal pain' ? 1 : 0],
        "chest_pain_type_Typical angina": [_chestPainType == 'Typical angina' ? 1 : 0],
        "rest_ecg_Normal": [_restEcg == 'Normal' ? 1 : 0],
        "rest_ecg_ST-T wave abnormality": [_restEcg == 'ST-T wave abnormality' ? 1 : 0],
        "slope_Flat": [_slope == 'Flat' ? 1 : 0],
        "slope_Upsloping": [_slope == 'Upsloping' ? 1 : 0],
        "vessels_colored_by_flourosopy_One": [_vessels == 'One' ? 1 : 0],
        "vessels_colored_by_flourosopy_Three": [_vessels == 'Three' ? 1 : 0],
        "vessels_colored_by_flourosopy_Two": [_vessels == 'Two' ? 1 : 0],
        "vessels_colored_by_flourosopy_Zero": [_vessels == 'Zero' ? 1 : 0],
        "thalassemia_No": [_thalassemia == 'No' ? 1 : 0],
        "thalassemia_Normal": [_thalassemia == 'Normal' ? 1 : 0],
        "thalassemia_Reversable Defect": [_thalassemia == 'Reversable Defect' ? 1 : 0],
      };

      print(inputData);
      // Here you would typically send the data to your ML model
      // Navigator.of(context).push(...);
      final response = await http.post(
        Uri.parse('$baseUrl/predict_heart_disease'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(inputData), // Convert the data to a JSON string
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // if (data['success'] == true) {
        //   // Handle the prediction result
    
        // } else {
        //   throw Exception(data['error']);
        // }
        setState(() {
          _riskStatus = data['risk_status'];
          _prediction = data['prediction'];
        });
          print('Risk Status: ${data['risk_status']}');
          print('Prediction: ${data['prediction']}');
      } else {
        throw Exception('Failed to predict heart disorder. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}