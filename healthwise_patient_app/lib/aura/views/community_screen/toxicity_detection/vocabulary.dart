import 'dart:convert';
import 'package:flutter/services.dart';

class Vocabulary {
  Map<String, int> wordIndex = {};
  static const String unknownToken = '<UNK>';
  static const String padToken = '<PAD>';

  Future<void> loadVocabulary() async {
    try {
      // Load vocabulary from asset
      String jsonContent = await rootBundle.loadString('assets/vocabulary.json');
      wordIndex = Map<String, int>.from(json.decode(jsonContent));
    } catch (e) {
      print('Error loading vocabulary: $e');
      // Initialize with basic tokens if loading fails
      wordIndex = {
        padToken: 0,
        unknownToken: 1,
      };
    }
  }

  int getWordIndex(String word) {
    return wordIndex[word.toLowerCase()] ?? wordIndex[unknownToken]!;
  }
}