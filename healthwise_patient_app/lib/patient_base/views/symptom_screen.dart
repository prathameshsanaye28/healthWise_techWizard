import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/components/consts.dart';
import 'package:http/http.dart' as http;

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({Key? key}) : super(key: key);

  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final List<String> predefinedSymptoms = [
    'Fever',
    'Diarrhea',
    'Vomiting',
    'Weight loss',
    'Coughing',
    'Lethargy',
    'Dehydration',
    'Sneezing',
    'Ulcers',
    'Facial swelling',
    'Nasal discharge',
    'Nausea',
    'Weakness',
    'Skin irritation',
    'Loss of appetite',
    'Shortness of breath',
    'Abnormal behavior',
    'Convulsions',
    'Ring-shaped lesion',
    'Blood in urine',
    'Fatigue',
    'Dizziness',
    'Epistaxis',
    'Difficulty in breathing'
  ];

  Future<void> showSymptomsPopup(String symptomsString) async {
    try {
      // Parse the response directly as JSON without string manipulation
      Map<String, dynamic> symptomsMap = jsonDecode(symptomsString);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Predicted Diseases'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: symptomsMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${entry.key}: ${entry.value}%',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error parsing JSON: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing the response')),
      );
    }
  }

  List<String> symptoms = [];
  Map<String, int> symptomSeverities = {};
  //String animalName = 'Tommy'; // Default animal name
  TextEditingController newSymptomController = TextEditingController();
  bool isLoading = false;

  void toggleSymptom(String symptom) {
    setState(() {
      if (symptoms.contains(symptom)) {
        symptoms.remove(symptom);
        symptomSeverities.remove(symptom);
      } else if (symptoms.length < 5) {
        // This allows up to 5
        symptoms.add(symptom);
        symptomSeverities[symptom] = 50;
      }
    });
  }

  void addCustomSymptom() {
    String newSymptom = newSymptomController.text.trim();
    if (newSymptom.isNotEmpty && !predefinedSymptoms.contains(newSymptom)) {
      setState(() {
        predefinedSymptoms.add(newSymptom); // Add the new symptom to the list
        symptoms.add(newSymptom); // Add it to the selected symptoms
        symptomSeverities[newSymptom] = 50;
      });
      newSymptomController.clear(); // Clear the input field
    }
  }

  Future<void> sendRequest() async {
    if (symptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least 1 symptom.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simplify the symptoms format to match server expectations
      List<Map<String, dynamic>> formattedSymptoms = [];
      for (String symptom in symptoms) {
        formattedSymptoms.add({'symptoms': symptom});
        formattedSymptoms.add({'symptoms': symptomSeverities[symptom] ?? 50});
      }

      Map<String, dynamic> requestBody = {
        'symptoms': formattedSymptoms,
        'top_n': 3
      };

      print(requestBody);

      final url = Uri.parse('$flask_ip/predict_disease');

      // Print request details for debugging
      print('Sending request to: $url');
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (!mounted) return;

        try {
          final decoded = jsonDecode(response.body);
          showSymptomsPopup(response.body);
        } catch (e) {
          print('JSON decode error: $e');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid response format from server: $e')),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Server error ${response.statusCode}: ${response.body}')),
        );
      }
    } catch (e, stackTrace) {
      print('Network error: $e');
      print('Stack trace: $stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select symptoms or add of your own',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newSymptomController,
                    decoration: InputDecoration(
                      labelText: 'Add a new symptom',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: addCustomSymptom,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: predefinedSymptoms.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final symptom = predefinedSymptoms[index];
                        final isSelected = symptoms.contains(symptom);
                        TextEditingController severityController =
                            TextEditingController(
                          text: symptomSeverities[symptom]?.toString() ?? '',
                        );
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(251, 233, 233, 0.85),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => toggleSymptom(symptom),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    symptom,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  CustomCheckbox(isSelected: isSelected),
                                  if (isSelected)
                                    Container(
                                      width: 80,
                                      child: TextField(
                                        controller: severityController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Severity',
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            int? severity = int.tryParse(value);
                                            if (severity != null &&
                                                severity >= 1 &&
                                                severity <= 100) {
                                              symptomSeverities[symptom] =
                                                  severity;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: sendRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(200, 230, 201, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Check Your Condition Severity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool isSelected;

  const CustomCheckbox({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? (isSelected ? Colors.black : Colors.grey)
              : Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 24,
              color: Colors.black,
            )
          : null,
    );
  }
}

class DangerScreen extends StatefulWidget {
  final double probability;

  const DangerScreen({Key? key, required this.probability}) : super(key: key);

  @override
  _DangerScreenState createState() => _DangerScreenState();
}

class _DangerScreenState extends State<DangerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Slower animation
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Alert'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Warning',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'You are not well.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GradedMeter(value: _animation.value * widget.probability),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Danger Level: ${(widget.probability * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement vet consultation functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Connecting to a doctor...')),
                  );
                },
                child: Text('Consult a Doctor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SafeScreen extends StatefulWidget {
  final double probability;

  const SafeScreen({Key? key, required this.probability}) : super(key: key);

  @override
  _SafeScreenState createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Status'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                'Good news!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'You seem to be doing fine.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GradedMeter(
                  value:
                      0.5 + (_animation.value * (1 - widget.probability) / 2)),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Safety Level: ${((1 - widget.probability) * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Symptoms'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradedMeter extends StatelessWidget {
  final double value;

  const GradedMeter({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.yellow, Colors.green],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: math.max(
                10.0,
                math.min((200 - 20) * value,
                    190.0)), // Keep circle between left and center
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
