// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'vocabulary.dart';
// import 'text_preprocessor.dart';

// class ToxicityDetectionService {
//   static const int MAX_SEQUENCE_LENGTH = 2000;
  
//   Interpreter? _interpreter;
//   final Vocabulary _vocabulary = Vocabulary();
//   bool _isInitialized = false;

//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     try {
//       // Load TFLite model
//       _interpreter = await Interpreter.fromAsset('assets/toxicity1.tflite');
      
//       // Load vocabulary
//       await _vocabulary.loadVocabulary();
      
//       _isInitialized = true;
//     } catch (e) {
//       print('Error initializing toxicity service: $e');
//       _isInitialized = false;
//     }
//   }

//   List<int> _tokenizeAndPad(String text) {
//     // Tokenize text
//     List<String> tokens = TextPreprocessor.tokenize(text);
    
//     // Convert tokens to indices and pad
//     List<int> paddedIndices = List.filled(MAX_SEQUENCE_LENGTH, 
//       _vocabulary.getWordIndex(Vocabulary.padToken));
    
//     for (int i = 0; i < tokens.length && i < MAX_SEQUENCE_LENGTH; i++) {
//       paddedIndices[i] = _vocabulary.getWordIndex(tokens[i]);
//     }
    
//     return paddedIndices;
//   }

//   Future<bool> isToxic(String text) async {
//     if (!_isInitialized) {
//       await initialize();
//     }

//     if (_interpreter == null) {
//       print('Interpreter not initialized');
//       return false;
//     }

//     try {
//       // Prepare input
//       final tokens = _tokenizeAndPad(text);
//       var inputArray = List.filled(1 * MAX_SEQUENCE_LENGTH, 0);
//       inputArray.setAll(0, tokens);
      
//       // Prepare output buffer
//       var outputBuffer = List.filled(1 * 6, 0.0);
      
//       // Run inference
//       _interpreter!.run(
//         inputArray.reshape([1, MAX_SEQUENCE_LENGTH]),
//         outputBuffer.reshape([1, 6]),
//       );
      
//       // Check if any toxicity score is above threshold
//       List<double> scores = List.from(outputBuffer);
//       return scores.any((score) => score > 0.5);
//     } catch (e) {
//       print('Error during toxicity detection: $e');
//       return false;
//     }
//   }

//   void dispose() {
//     _interpreter?.close();
//   }
// }


// // import 'package:flutter/services.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'dart:convert';
// // import 'dart:developer' as developer;

// // class ToxicityDetectionService {
// //   static const int MAX_SEQUENCE_LENGTH = 2000;
// //   static const int VOCAB_SIZE = 200000;
  
// //   Interpreter? _interpreter;
// //   Map<String, int> _vocabulary = {};
// //   bool _isInitialized = false;

// //   Future<void> initialize() async {
// //     if (_isInitialized) return;

// //     try {
// //       // Load vocabulary
// //       final String vocabJson = await rootBundle.loadString('assets/vocabulary.json');
// //       _vocabulary = Map<String, int>.from(json.decode(vocabJson));
// //       developer.log('Vocabulary loaded with ${_vocabulary.length} words');

// //       // Load model
// //       _interpreter = await Interpreter.fromAsset('assets/toxicity1.tflite');
// //       developer.log('TFLite model loaded successfully');
      
// //       _isInitialized = true;
// //     } catch (e) {
// //       developer.log('Error initializing toxicity service: $e');
// //       _isInitialized = false;
// //       rethrow;
// //     }
// //   }

// //   List<int> _tokenizeText(String text) {
// //     // Convert to lowercase and split into words
// //     List<String> words = text.toLowerCase().split(RegExp(r'\s+'));
    
// //     // Convert words to indices using vocabulary
// //     List<int> indices = List.filled(MAX_SEQUENCE_LENGTH, 0); // 0 is <PAD>
    
// //     for (int i = 0; i < words.length && i < MAX_SEQUENCE_LENGTH; i++) {
// //       indices[i] = _vocabulary[words[i]] ?? _vocabulary['<UNK>'] ?? 1;
// //     }
    
// //     developer.log('Tokenized text: ${words.join(" ")} to indices: ${indices.take(words.length).toList()}');
// //     return indices;
// //   }

// //   Future<bool> isToxic(String text) async {
// //     if (!_isInitialized) {
// //       await initialize();
// //     }

// //     if (_interpreter == null) {
// //       developer.log('Interpreter not initialized');
// //       return false;
// //     }

// //     try {
// //       developer.log('Analyzing text: $text');
      
// //       // Tokenize input
// //       List<int> tokens = _tokenizeText(text);
      
// //       // Prepare input tensor
// //       var input = List.filled(1 * MAX_SEQUENCE_LENGTH, 0);
// //       input.setAll(0, tokens);
      
// //       // Prepare output tensor
// //       var output = List.filled(1 * 6, 0.0);
      
// //       // Run inference
// //       _interpreter!.run(
// //         input.reshape([1, MAX_SEQUENCE_LENGTH]),
// //         output.reshape([1, 6])
// //       );
      
// //       // Get results
// //       List<double> scores = List.from(output);
// //       developer.log('Toxicity scores: $scores');
      
// //       // Check if any toxicity score is above threshold
// //       bool isToxic = scores.any((score) => score > 0.5);
// //       developer.log('Final toxicity result: $isToxic');
      
// //       return isToxic;

// //     } catch (e) {
// //       developer.log('Error during toxicity detection: $e');
// //       return false;
// //     }
// //   }

// //   void dispose() {
// //     _interpreter?.close();
// //   }
// // }



import 'dart:convert';
import 'package:http/http.dart' as http;

class ToxicityDetectionService {
  static const String _baseUrl = 'https://c9e0-2402-3a80-4281-c0de-64ba-cb0e-9fc6-f264.ngrok-free.app';  // Update with your server URL
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // You could add any initialization logic here if needed
      _isInitialized = true;
    } catch (e) {
      print('Error initializing toxicity service: $e');
      throw Exception('Failed to initialize toxicity service');
    }
  }

  Future<bool> isToxic(String text) async {
    if (!_isInitialized) {
      throw Exception('Toxicity service not initialized');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/check_comment_toxicity'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'text': text,
        }),
      );

      // if (response.statusCode == 200) {
      //   final result = json.decode(response.body);
      //   // The model returns a list of predictions for different toxicity types
      //   // If any prediction is 1, consider the text toxic
      //   return (result['prediction'] as List).contains(0.5);
      // } else {
      //   throw Exception('Failed to analyze text toxicity');
      // }
      if (response.statusCode == 200) {
    final result = json.decode(response.body);
    // The server now returns a single boolean field 'is_toxic'
    return result['is_toxic'] == true;
} else {
    throw Exception('Failed to analyze text toxicity');
}
    } catch (e) {
      print('Error checking toxicity: $e');
      // In case of error, let's err on the side of caution
      return false;
    }
  }

  void dispose() {
    _isInitialized = false;
  }
}
