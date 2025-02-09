// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SpeechRecognitionService {
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;

//   Future<bool> initialize() async {
//     _isListening = await _speech.initialize(
//       onStatus: (status) => print('Speech recognition status: $status'),
//       onError: (error) => print('Speech recognition error: $error'),
//     );
//     return _isListening;
//   }

//   Future<String> startListening() async {
//     if (!_isListening) {
//       await initialize();
//     }

//     String recognizedText = '';
    
//     if (_speech.isAvailable) {
//       await _speech.listen(
//         onResult: (result) {
//           recognizedText = result.recognizedWords;
//         },
//         listenMode: stt.ListenMode.confirmation,
//       );
//     }

//     return recognizedText;
//   }

//   void stopListening() {
//     _speech.stop();
//   }
// }

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart';

class SpeechRecognitionService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    try {
      _isInitialized = await _speech.initialize(
        onError: (error) => debugPrint('Speech recognition error: $error'),
        onStatus: (status) => debugPrint('Speech recognition status: $status'),
        debugLogging: true,
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  Future<String> startListening() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Could not initialize speech recognition');
      }
    }

    if (!_speech.isAvailable) {
      throw Exception('Speech recognition is not available');
    }

    String recognizedText = '';
    
    try {
      await _speech.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        listenMode: stt.ListenMode.confirmation,
        partialResults: false,
      );
      
      return recognizedText;
    } catch (e) {
      debugPrint('Error during speech recognition: $e');
      throw Exception('Failed to start speech recognition');
    }
  }

  Future<void> stopListening() async {
    try {
      await _speech.stop();
    } catch (e) {
      debugPrint('Error stopping speech recognition: $e');
    }
  }

  bool get isListening => _speech.isListening;
}