import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/patient_base/views/voice_assistant/gemini_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:healthwise_patient_app/patient_base/views/voice_assistant/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:voice_bot/gemini_service.dart';

class VoiceAssistantHomePage extends StatefulWidget {
  const VoiceAssistantHomePage({super.key});

  @override
  State<VoiceAssistantHomePage> createState() => _VoiceAssistantHomePageState();
}

class _VoiceAssistantHomePageState extends State<VoiceAssistantHomePage> {
  late GeminiService geminiService;
  String lastWords = '';
  String? generatedContent;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    geminiService = GeminiService(
      apiKey: 'AIzaSyAsIWg2xV5Dv-2-IR4pZBZOKwg4wbfI6So', // Replace with your API key
    );
    initServices();
  }

  Future<void> initServices() async {
    await geminiService.initSpeechToText();
    await geminiService.initTextToSpeech();
    setState(() {});
  }

  Future<void> startListening() async {
    await geminiService.startListening(onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await geminiService.stopListening();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    geminiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: Text(
            geminiService.isEnglish ? 'Voice Assistant' : 'आवाज सहायक',
          ),
        ),
        centerTitle: true,
        actions: [
          // Language toggle button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  geminiService.toggleLanguage();
                });
              },
              child: Text(
                geminiService.isEnglish ? 'EN' : 'हिं',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Virtual assistant image
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/assistant.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Chat bubble
            FadeInRight(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(20).copyWith(
                    topLeft: Radius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    generatedContent ?? (geminiService.isEnglish
                        ? 'How can I help you today?'
                        : 'मैं आपकी कैसे मदद कर सकता हूं?'),
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: generatedContent == null ? 25 : 18,
                    ),
                  ),
                ),
              ),
            ),
            if (lastWords.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Recognized: $lastWords',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Pallete.mainFontColor,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await geminiService.hasPermission &&
                !geminiService.isListening) {
              await startListening();
            } else if (geminiService.isListening) {
              final response = await geminiService.processVoiceInput(lastWords);
              setState(() {
                generatedContent = response;
              });
              await stopListening();
            } else {
              await geminiService.initSpeechToText();
            }
          },
          child: Icon(
            geminiService.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}