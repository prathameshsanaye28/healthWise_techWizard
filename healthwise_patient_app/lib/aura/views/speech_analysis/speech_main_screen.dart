// import 'dart:convert';

// import 'package:aura_techwizard/views/speech_analysis/sentiment_analysis_service.dart';
// import 'package:aura_techwizard/views/speech_analysis/voice_input_widget.dart';
// import 'package:flutter/material.dart';

// class SpeechMainScreen extends StatefulWidget {
//   @override
//   _SpeechMainScreenState createState() => _SpeechMainScreenState();
// }

// class _SpeechMainScreenState extends State<SpeechMainScreen> {
//   final SentimentAnalysisService _sentimentService = SentimentAnalysisService();
//   String _recognizedText = '';
//   Map<String, dynamic>? _sentimentResult;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Speech & Sentiment Analysis'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Recognized Text:', style: Theme.of(context).textTheme.titleLarge),
//             Text(_recognizedText),
//             if (_sentimentResult != null) ...[
//               SizedBox(height: 20),
//               Text('Sentiment Analysis:', style: Theme.of(context).textTheme.titleLarge),
//               Text(json.encode(_sentimentResult)),
//             ],
//           ],
//         ),
//       ),
//       floatingActionButton: VoiceInputWidget(
//         onTextRecognized: _handleRecognizedText,
//       ),
//     );
//   }

//   void _handleRecognizedText(String text) async {
//     setState(() => _recognizedText = text);
//     if (text.isNotEmpty) {
//       try {
//         final sentiment = await _sentimentService.analyzeSentiment(text);
//         setState(() => _sentimentResult = sentiment);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error analyzing sentiment: $e')),
//         );
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';

import 'voice_input_widget.dart';

// class SpeechMainScreen extends StatefulWidget {
//   const SpeechMainScreen({Key? key}) : super(key: key);

//   @override
//   _SpeechMainScreenState createState() => _SpeechMainScreenState();
// }

// class _SpeechMainScreenState extends State<SpeechMainScreen> {
//   String _recognizedText = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Speech Recognition'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Recognized Text:',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(_recognizedText),
//           ],
//         ),
//       ),
//       floatingActionButton: VoiceInputWidget(
//         onTextRecognized: (text) {
//           setState(() {
//             _recognizedText = text;
//           });
//         },
//       ),
//     );
//   }
// }

class SpeechMainScreen extends StatefulWidget {
  const SpeechMainScreen({super.key});

  @override
  _SpeechMainScreenState createState() => _SpeechMainScreenState();
}

class _SpeechMainScreenState extends State<SpeechMainScreen> {
  String _recognizedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recognized Text:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_recognizedText),
                  ],
                ),
              ),
            ),
            VoiceInputWidget(
              onTextRecognized: (text) {
                setState(() {
                  _recognizedText = text;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
