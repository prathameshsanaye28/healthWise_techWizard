import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GeminiService {
  final GenerativeModel model;
  final SpeechToText speechToText;
  final FlutterTts flutterTts;
  late ChatSession chatSession;
  bool isEnglish = true;

  GeminiService({
    required String apiKey,
  }) : model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
        ),
        speechToText = SpeechToText(),
        flutterTts = FlutterTts() {
    _initChatSession();
  }

  void _initChatSession() {
    chatSession = model.startChat(history: [
      Content.text(
        "You are a multilingual assistant that can communicate in both English and Hindi. "
        "When responding in Hindi, use Devanagari script. Keep responses natural and conversational. "
        "Keep responses concise but informative.",
      ),
    ]);
  }

  Future<bool> initSpeechToText() async {
    return await speechToText.initialize();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setLanguage(isEnglish ? 'en-US' : 'hi-IN');
    await flutterTts.setSpeechRate(isEnglish ? 0.5 : 0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void toggleLanguage() {
    isEnglish = !isEnglish;
    initTextToSpeech();
  }

  Future<bool> startListening(Function(SpeechRecognitionResult) onResult) async {
    return await speechToText.listen(
      onResult: onResult,
      localeId: isEnglish ? 'en-US' : 'hi-IN',
      listenMode: ListenMode.confirmation,
    );
  }

  Future<void> stopListening() async {
    await speechToText.stop();
  }

  Future<String> processVoiceInput(String voiceText) async {
    try {
      String languagePrompt = isEnglish
          ? "Respond in English to: "
          : "निम्नलिखित प्रश्न का उत्तर हिंदी में दें: ";

      final response = await chatSession.sendMessage(
        Content.text(languagePrompt + voiceText),
      );

      String generatedResponse = response.text ?? 'Sorry, I could not process that.';
      await speakResponse(generatedResponse);
      return generatedResponse;
    } catch (e) {
      String errorMessage = isEnglish
          ? 'Sorry, an error occurred. Please try again.'
          : 'क्षमा करें, कोई त्रुटि हुई। कृपया पुनः प्रयास करें।';
      return errorMessage;
    }
  }

  Future<void> speakResponse(String text) async {
    await flutterTts.speak(text);
  }

  bool get isListening => speechToText.isListening;

  Future<bool> get hasPermission => speechToText.hasPermission;

  Future<void> dispose() async {
    await speechToText.stop();
    await flutterTts.stop();
  }
}