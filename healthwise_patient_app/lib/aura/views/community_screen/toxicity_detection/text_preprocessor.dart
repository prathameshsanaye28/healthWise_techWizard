class TextPreprocessor {
  static String cleanText(String text) {
    // Convert to lowercase
    String cleaned = text.toLowerCase();
    
    // Replace newlines with spaces
    cleaned = cleaned.replaceAll(RegExp(r'\n'), ' ');
    
    // Remove special characters but keep basic punctuation
    cleaned = cleaned.replaceAll(RegExp(r'[^\w\s.,!?-]'), '');
    
    // Replace multiple spaces with single space
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    return cleaned.trim();
  }

  static List<String> tokenize(String text) {
    String cleaned = cleanText(text);
    
    // Split on spaces and punctuation
    List<String> tokens = cleaned.split(RegExp(r'[\s.,!?-]+'));
    
    // Remove empty tokens
    tokens = tokens.where((token) => token.isNotEmpty).toList();
    
    return tokens;
  }
}