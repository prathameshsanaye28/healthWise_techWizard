import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final Gemini gemini = Gemini.instance;
  bool _showForm = true;
  bool _isLoading = false;
  String _generatedPlan = '';

  // Form controllers
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Form values
  String _gender = 'Male';
  String _activityLevel = 'Sedentary';
  String _sleepQuality = 'Good';
  String _stressLevel = 'Low';
  final List<String> _healthConditions = [];
  final List<String> _dietaryRestrictions = [];
  String _mealPreference = '3 meals';
  String _cookingTime = '30-60 minutes';

  // Dropdown options
  final List<String> _activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active'
  ];

  final List<String> _sleepQualities = ['Good', 'Fair', 'Poor', 'Irregular'];

  final List<String> _stressLevels = ['Low', 'Moderate', 'High', 'Severe'];

  final List<String> _healthConditionOptions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Depression',
    'Anxiety',
    'Insomnia',
    'Digestive Issues',
    'None'
  ];

  final List<String> _dietaryRestrictionOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Nut Allergy',
    'None'
  ];

  final List<String> _mealPreferences = [
    '2 meals',
    '3 meals',
    '4 meals',
    '5 meals',
    '6 meals'
  ];

  final List<String> _cookingTimePreferences = [
    'Less than 30 minutes',
    '30-60 minutes',
    'More than 60 minutes'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan Generator'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _showForm ? _buildForm() : _buildPlanDisplay(),
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lifestyle & Health',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _activityLevel,
                  decoration: const InputDecoration(
                    labelText: 'Activity Level',
                    border: OutlineInputBorder(),
                  ),
                  items: _activityLevels
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _activityLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _sleepQuality,
                  decoration: const InputDecoration(
                    labelText: 'Sleep Quality',
                    border: OutlineInputBorder(),
                  ),
                  items: _sleepQualities
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _sleepQuality = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _stressLevel,
                  decoration: const InputDecoration(
                    labelText: 'Stress Level',
                    border: OutlineInputBorder(),
                  ),
                  items: _stressLevels
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _stressLevel = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dietary Preferences',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children: _healthConditionOptions.map((condition) {
                    return FilterChip(
                      label: Text(condition),
                      selected: _healthConditions.contains(condition),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _healthConditions.add(condition);
                          } else {
                            _healthConditions.remove(condition);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children: _dietaryRestrictionOptions.map((restriction) {
                    return FilterChip(
                      label: Text(restriction),
                      selected: _dietaryRestrictions.contains(restriction),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _dietaryRestrictions.add(restriction);
                          } else {
                            _dietaryRestrictions.remove(restriction);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _mealPreference,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Meals per Day',
                    border: OutlineInputBorder(),
                  ),
                  items: _mealPreferences
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _mealPreference = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _cookingTime,
                  decoration: const InputDecoration(
                    labelText: 'Available Cooking Time',
                    border: OutlineInputBorder(),
                  ),
                  items: _cookingTimePreferences
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _cookingTime = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Generate Diet Plan'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: _generateDietPlan,
          ),
        ),
      ],
    );
  }

  // Widget _buildPlanDisplay() {
  //   return Column(
  //     children: [
  //       Card(
  //         elevation: 4,
  //         child: Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Column(
  //             children: [
  //               Text(
  //                 'Your Personalized Diet Plan',
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 16),
  //               Text(_generatedPlan),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       ElevatedButton.icon(
  //         icon: Icon(Icons.edit),
  //         label: Text('Generate New Plan'),
  //         onPressed: () {
  //           setState(() {
  //             _showForm = true;
  //             _generatedPlan = '';
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

//   void _generateDietPlan() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final prompt = '''
//     Generate a detailed 7-day diet plan for a person with the following profile:

//     Basic Information:
//     - Age: ${_ageController.text}
//     - Weight: ${_weightController.text} kg
//     - Height: ${_heightController.text} cm
//     - Gender: $_gender

//     Lifestyle:
//     - Activity Level: $_activityLevel
//     - Sleep Quality: $_sleepQuality
//     - Stress Level: $_stressLevel

//     Health Conditions: ${_healthConditions.isEmpty ? 'None' : _healthConditions.join(', ')}
//     Dietary Restrictions: ${_dietaryRestrictions.isEmpty ? 'None' : _dietaryRestrictions.join(', ')}
//     Meal Preference: $_mealPreference per day
//     Cooking Time Available: $_cookingTime

//     Please create a diet plan that:
//     1. Focuses on improving energy levels, productivity, and sleep quality
//     2. Includes foods known to support mental health and reduce stress
//     3. Provides balanced nutrition while respecting dietary restrictions
//     4. Suggests simple meal prep ideas that fit within the available cooking time
//     5. Includes proper portion sizes and timing of meals
//     6. Adds specific recommendations for hydration throughout the day
//     7. Includes healthy snack options between meals if applicable

//     Format the response as a clear day-by-day plan with specific meals and portions.
//     Also include a brief section on meal timing and any specific tips for their health conditions.
//     ''';

//     try {
//       var response = await gemini.streamGenerateContent(prompt);
//       setState(() {
//         _generatedPlan = response.toString();
//         _showForm = false;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _generatedPlan = 'Error generating plan. Please try again.';
//       });
//     }
//   }
// }

  void _generateDietPlan() async {
    setState(() {
      _isLoading = true;
      _generatedPlan = '';
    });

    final prompt = '''
    Generate a detailed 7-day diet plan for a person with the following profile:
    
    Basic Information:
    - Age: ${_ageController.text}
    - Weight: ${_weightController.text} kg
    - Height: ${_heightController.text} cm
    - Gender: $_gender
    
    Lifestyle:
    - Activity Level: $_activityLevel
    - Sleep Quality: $_sleepQuality
    - Stress Level: $_stressLevel
    
    Health Conditions: ${_healthConditions.isEmpty ? 'None' : _healthConditions.join(', ')}
    Dietary Restrictions: ${_dietaryRestrictions.isEmpty ? 'None' : _dietaryRestrictions.join(', ')}
    Meal Preference: $_mealPreference per day
    Cooking Time Available: $_cookingTime
    
    Please create a diet plan that:
    1. Focuses on improving energy levels, productivity, and sleep quality
    2. Includes foods known to support mental health and reduce stress
    3. Provides balanced nutrition while respecting dietary restrictions
    4. Suggests simple meal prep ideas that fit within the available cooking time
    5. Includes proper portion sizes and timing of meals
    6. Adds specific recommendations for hydration throughout the day
    7. Includes healthy snack options between meals if applicable
    8. In non-veg or meat options stick to chicken, mutton and fish only
    
    Format the response as a clear day-by-day plan with specific meals and portions.
    Also include a brief section on meal timing and any specific tips for their health conditions.
    ''';

    try {
      gemini.streamGenerateContent(prompt).listen(
        (event) {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous${current.text}") ??
              "";

          setState(() {
            _generatedPlan += _formatStreamResponse(response);
          });
        },
        onDone: () {
          setState(() {
            _showForm = false;
            _isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _isLoading = false;
            _generatedPlan =
                'Error generating plan. Please try again. Error: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _generatedPlan = 'Error generating plan. Please try again. Error: $e';
      });
    }
  }

  String _formatStreamResponse(String response) {
    // First, clean up API-specific content
    String cleanText = response
        .replaceAll(RegExp(r'Candidates\(.*?text: '), '')
        .replaceAll(RegExp(r'\), finishReason:.*?NEGLIGIBLE\]\)'), '')
        .replaceAll('Parts(text: ', '')
        .replaceAll('), role: model', '')
        .replaceAll(RegExp(r'SafetyRatings\(.*?\)'), '')
        .replaceAll('Content(', '')
        .replaceAll('parts: [', '')
        .replaceAll(']', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // Convert markdown headers to plain text with proper formatting
    cleanText = cleanText
        // Convert bold headers to plain text with proper spacing
        .replaceAll(RegExp(r'\*\*Meal Timing and Hydration:\*\*'),
            '\nMeal Timing and Hydration:\n')
        .replaceAll(RegExp(r'\*\*7-Day Diet Plan:\*\*'), '\n7-Day Diet Plan:\n')
        .replaceAll(RegExp(r'\*\*Day (\d+)\*\*'), '\nDay ${1}\n')
        .replaceAll(
            RegExp(r'\*\*Meal Prep Ideas.*?:\*\*'), '\nMeal Prep Ideas:\n')
        .replaceAll(RegExp(r'\*\*Hydration:\*\*'), '\nHydration:\n')

        // Remove remaining asterisks from bullet points
        .replaceAll(RegExp(r'^\* '), '• ')
        .replaceAll(RegExp(r'\n\* '), '\n• ')

        // Clean up extra whitespace and line breaks
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();

    // Ensure proper spacing between sections
    cleanText = cleanText.split('\n').map((line) {
      // Add extra newline before section headers
      if (line.contains(':') &&
          (line.contains('Day') ||
              line.contains('Meal Timing') ||
              line.contains('Meal Prep') ||
              line.contains('Hydration') ||
              line.contains('Diet Plan'))) {
        return '\n$line';
      }
      return line;
    }).join('\n');

    // Final cleanup of any remaining formatting artifacts
    cleanText = cleanText
        .replaceAll(RegExp(r'\n{3,}'), '\n\n') // Normalize multiple newlines
        .replaceAll(':\n\n', ':\n') // Remove extra newline after headers
        .trim();

    return cleanText;
  }

  String _preserveMarkdownFormatting(String text) {
    // Ensure proper spacing for headers and sections
    final formattedText = text
        // Preserve bold markers
        .replaceAll(RegExp(r'\*{4}'), '**')
        .replaceAll(RegExp(r'\*{3}'), '**')

        // Add proper spacing for sections
        .replaceAll(RegExp(r'(?<![\n])\*\*Day'), '\n\n**Day')
        .replaceAll(RegExp(r'(?<![\n])\*\*Meal Timing:'), '\n\n**Meal Timing:')
        .replaceAll(RegExp(r'(?<![\n])\*\*Hydration:'), '\n\n**Hydration:')
        .replaceAll(
            RegExp(r'(?<![\n])\*\*Meal Prep Ideas:'), '\n\n**Meal Prep Ideas:')

        // Ensure proper list formatting
        .replaceAll(RegExp(r'(?<![\n])\* '), '\n* ')

        // Clean up extra whitespace
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .replaceAll(' \n', '\n')
        .replaceAll('\n ', '\n')
        .trim();

    return formattedText;
  }

  Widget _buildPlanDisplay() {
    return Column(
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Personalized Diet Plan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: SelectableText.rich(
                    TextSpan(
                      children: _formatTextWithHeaders(_generatedPlan),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Generate New Plan'),
              onPressed: () {
                setState(() {
                  _showForm = true;
                  _generatedPlan = '';
                });
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy Plan'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _generatedPlan));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diet plan copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  List<TextSpan> _formatTextWithHeaders(String text) {
    List<TextSpan> spans = [];

    final lines = text.split('\n');
    for (var line in lines) {
      if (line.contains(':') &&
          (line.contains('Day') ||
              line.contains('Meal Timing') ||
              line.contains('Meal Prep') ||
              line.contains('Hydration') ||
              line.contains('Diet Plan'))) {
        // Style headers differently
        spans.add(TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 2.0,
          ),
        ));
      } else {
        // Regular text
        spans.add(TextSpan(
          text: '$line\n',
        ));
      }
    }

    return spans;
  }

  // Widget _buildPlanDisplay() {
  //   return Column(
  //     children: [
  //       Card(
  //         elevation: 4,
  //         child: Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Your Personalized Diet Plan',
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 16),
  //               Container(
  //                 width: double.infinity,
  //                 child: SelectableText(
  //                   _generatedPlan,
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     height: 1.5,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           ElevatedButton.icon(
  //             icon: Icon(Icons.edit),
  //             label: Text('Generate New Plan'),
  //             onPressed: () {
  //               setState(() {
  //                 _showForm = true;
  //                 _generatedPlan = '';
  //               });
  //             },
  //           ),
  //           SizedBox(width: 16),
  //           ElevatedButton.icon(
  //             icon: Icon(Icons.copy),
  //             label: Text('Copy Plan'),
  //             onPressed: () {
  //               Clipboard.setData(ClipboardData(text: _generatedPlan));
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Diet plan copied to clipboard')),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  String _formatGeminiOutput(String response) {
    // Remove the Candidates and other API metadata
    String cleanText = response
        .replaceAll(RegExp(r'Candidates\(.*?text: '), '')
        .replaceAll(RegExp(r'\), finishReason:.*?NEGLIGIBLE\]\)'), '')
        .replaceAll('Parts(text: ', '')
        .replaceAll('), role: model', '');

    // Remove extra whitespace and clean up newlines
    cleanText = cleanText
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(' \n', '\n')
        .replaceAll('\n ', '\n')
        .trim();

    // Remove any remaining artifacts from the API response
    cleanText = cleanText
        .replaceAll('SafetyRatings(', '')
        .replaceAll('Content(', '')
        .replaceAll('parts: [', '')
        .replaceAll(']', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // Clean up any duplicate asterisks that might have been introduced
    cleanText = cleanText.replaceAll('****', '**').replaceAll('***', '**');
    cleanText = _preserveFormatting(cleanText);

    return cleanText;
  }

  String _preserveFormatting(String text) {
    // Add extra newlines before headers and sections
    text = text.replaceAll('**Day', '\n\nDay');
    text = text.replaceAll('**Meal Timing:', '\n\nMeal Timing:');
    text = text.replaceAll('**Hydration:', '\n\nHydration:');
    text = text.replaceAll('**Meal Plan:', '\n\nMeal Plan:');
    text = text.replaceAll('**Meal Prep Ideas:', '\n\nMeal Prep Ideas:');
    text = text.replaceAll('**Tips:', '\n\nTips:');

    return text;
  }
}
