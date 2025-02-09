// // tflite_report_analyzer.dart

// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// class TFLiteReportAnalyzer {
//   static Interpreter? _interpreter;
//   static Map<String, int>? _vocabMap;
//   static const int maxLength = 512;
//   static const int vocabSize = 30522;  // Standard BERT vocab size

//   static const List<String> _specialTokens = [
//     '[PAD]', '[UNK]', '[CLS]', '[SEP]', '[MASK]'
//   ];

//   // Initialize TFLite model and vocabulary
//   static Future<void> initialize() async {
//     try {
//       // Load model
//       final interpreterOptions = InterpreterOptions()
//         ..threads = 4;

//       _interpreter = await Interpreter.fromAsset(
//         'assets/model/biobert_model.tflite',
//         options: interpreterOptions,
//       );

//       // Load vocabulary
//       final String vocabString = await rootBundle.loadString('assets/vocab.txt');
//       _vocabMap = {};

//       final List<String> vocabLines = vocabString.split('\n');
//       for (int i = 0; i < vocabLines.length; i++) {
//         final String token = vocabLines[i].trim();
//         if (token.isNotEmpty) {
//           _vocabMap![token] = i;
//         }
//       }
//     } catch (e) {
//       print('Initialization error: $e');
//       throw Exception('Failed to initialize TFLite analyzer');
//     }
//   }

//   // Tokenize text using WordPiece tokenization
//   static List<List<int>> tokenize(String text) {
//     if (_vocabMap == null) {
//       throw Exception('Vocabulary not initialized');
//     }

//     final List<int> inputIds = [];
//     final List<int> attentionMask = [];

//     // Add [CLS] token at start
//     inputIds.add(_vocabMap!['[CLS]']!);
//     attentionMask.add(1);

//     // Clean and normalize text
//     text = text.toLowerCase().trim();
//     final List<String> words = text.split(RegExp(r'\s+'));

//     for (String word in words) {
//       if (inputIds.length >= maxLength - 1) break;  // Leave room for [SEP]

//       // Try to find the word in vocabulary
//       if (_vocabMap!.containsKey(word)) {
//         inputIds.add(_vocabMap![word]!);
//         attentionMask.add(1);
//         continue;
//       }

//       // WordPiece tokenization
//       List<int> wordPieces = _wordPieceTokenize(word);
//       if (inputIds.length + wordPieces.length >= maxLength - 1) break;

//       inputIds.addAll(wordPieces);
//       attentionMask.addAll(List.filled(wordPieces.length, 1));
//     }

//     // Add [SEP] token at end
//     inputIds.add(_vocabMap!['[SEP]']!);
//     attentionMask.add(1);

//     // Pad to maxLength
//     while (inputIds.length < maxLength) {
//       inputIds.add(_vocabMap!['[PAD]']!);
//       attentionMask.add(0);
//     }

//     return [inputIds, attentionMask];
//   }

//   // WordPiece tokenization helper
//   static List<int> _wordPieceTokenize(String word) {
//     if (word.isEmpty) return [];

//     final List<int> tokens = [];
//     String remainingChars = word;
//     bool isBad = false;

//     while (remainingChars.isNotEmpty) {
//       int endIdx = remainingChars.length;
//       String curSubstr;
//       bool foundToken = false;

//       while (endIdx > 0) {
//         curSubstr = remainingChars.substring(0, endIdx);
//         if (tokens.isEmpty) {
//           curSubstr = curSubstr;
//         } else {
//           curSubstr = '##$curSubstr';
//         }

//         if (_vocabMap!.containsKey(curSubstr)) {
//           tokens.add(_vocabMap![curSubstr]!);
//           remainingChars = remainingChars.substring(endIdx);
//           foundToken = true;
//           break;
//         }
//         endIdx--;
//       }

//       if (!foundToken) {
//         isBad = true;
//         break;
//       }
//     }

//     if (isBad) {
//       return [_vocabMap!['[UNK]']!];
//     }

//     return tokens;
//   }

//   // Analyze report text
//   static Future<Map<String, String>> analyzeReport(String text) async {
//     if (_interpreter == null || _vocabMap == null) {
//       throw Exception('Analyzer not initialized');
//     }

//     try {
//       // Tokenize input
//       final List<List<int>> tokenized = tokenize(text);
//       final List<int> inputIds = tokenized[0];
//       final List<int> attentionMask = tokenized[1];

//       // Prepare input tensors
//       final input = [
//         [inputIds],
//         [attentionMask]
//       ];

//       // Prepare output tensor
//       final output = List.filled(1 * maxLength * 768, 0.0).reshape([1, maxLength, 768]);

//       // Run inference
//       _interpreter!.run(input, output);

//       // Process results
//       return _processResults(output[0], text);
//     } catch (e) {
//       print('Analysis error: $e');
//       throw Exception('Failed to analyze report');
//     }
//   }

//   // Process model outputs
//   static Map<String, String> _processResults(List<List<double>> embeddings, String originalText) {
//     // Extract sentence embeddings (use [CLS] token embedding)
//     final List<double> clsEmbedding = embeddings[0];

//     // Key phrases to look for
//     final Map<String, String> searchPhrases = {
//       'diagnosis': 'diagnosis|diagnosed with|condition|assessment',
//       'treatment': 'treatment|therapy|prescribed|medication',
//       'risk_factors': 'risk|factors|history|predisposing',
//       'prognosis': 'prognosis|outlook|expected|outcome',
//       'follow_up': 'follow|follow-up|next|appointment'
//     };

//     // Extract relevant sentences
//     final Map<String, String> results = {};
//     final List<String> sentences = originalText.split(RegExp(r'(?<=[.!?])\s+'));

//     for (String key in searchPhrases.keys) {
//       String? bestMatch;
//       double bestScore = -1;

//       for (String sentence in sentences) {
//         if (RegExp(searchPhrases[key]!, caseSensitive: false).hasMatch(sentence)) {
//           // Calculate relevance score (simplified for example)
//           double score = _calculateRelevanceScore(sentence, key);
//           if (score > bestScore) {
//             bestScore = score;
//             bestMatch = sentence;
//           }
//         }
//       }

//       results[key] = bestMatch ?? 'No relevant information found';
//     }

//     return results;
//   }

//   // Calculate relevance score for a sentence
//   static double _calculateRelevanceScore(String sentence, String category) {
//     // Simplified scoring based on keyword matching and sentence length
//     final Map<String, List<String>> categoryKeywords = {
//       'diagnosis': ['diagnose', 'condition', 'present', 'exhibit'],
//       'treatment': ['treat', 'prescribe', 'recommend', 'therapy'],
//       'risk_factors': ['risk', 'factor', 'history', 'likely'],
//       'prognosis': ['expect', 'outcome', 'prospect', 'likely'],
//       'follow_up': ['follow', 'visit', 'schedule', 'return']
//     };

//     int keywordMatches = 0;
//     for (String keyword in categoryKeywords[category]!) {
//       if (sentence.toLowerCase().contains(keyword.toLowerCase())) {
//         keywordMatches++;
//       }
//     }

//     // Normalize score based on sentence length and keyword matches
//     return (keywordMatches * 2.0) / (1 + log(sentence.length));
//   }

//   // Cleanup
//   static void dispose() {
//     _interpreter?.close();
//     _interpreter = null;
//     _vocabMap = null;
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/components/consts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../components/colors.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  _SummarizerScreenState createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final int _selectedIndex = 2; // Set to 2 for the home icon
  File? _file;
  String _summary = '';
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _analyzePdf() async {
    if (_file == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      const String ngrokKey = '$flask_ip';
      final url = Uri.parse('$ngrokKey/analyze_medical_reports');

      var request = http.MultipartRequest('POST', url);
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'files',
        _file!.path,
        filename: path.basename(_file!.path),
      ));

      // Add headers
      var headers = {
        "Content-Type": "multipart/form-data",
        // Add other headers if necessary
      };
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse the JSON response and extract the "analysis" field
        var jsonResponse = json.decode(response.body);
        setState(() {
          _summary = jsonResponse['analysis'] ?? 'No summary available';
        });
      } else {
        throw Exception('Failed to analyze PDF');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: const [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_summary.isEmpty ? _buildUploadScreen() : _buildSummaryScreen()),
    );
  }

  Widget _buildUploadScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: _file == null
                ? IconButton(
                    icon: const Icon(Icons.upload_file, size: 50),
                    onPressed: _pickFile,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_present,
                          size: 50, color: Colors.green),
                      const SizedBox(height: 10),
                      const Text(
                        'File Uploaded',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        path.basename(_file!.path),
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            _file == null ? 'Upload File Here' : 'File Ready for Analysis',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.mediumGreen,
                  AppColors.mediumGreen,
                  AppColors.mediumGreen,
                  AppColors.mediumGreen,
                  AppColors.paleGreen,
                  AppColors.paleGreen,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: _file != null ? _analyzePdf : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(_file != null ? 'Analyze PDF' : 'Proceed'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Text(_summary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
