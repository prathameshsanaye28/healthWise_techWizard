// // import 'package:aura_techwizard/views/speech_analysis/speech_recognition_service.dart';
// // import 'package:flutter/material.dart';

// // class VoiceInputWidget extends StatefulWidget {
// //   final Function(String) onTextRecognized;

// //   const VoiceInputWidget({Key? key, required this.onTextRecognized}) : super(key: key);

// //   @override
// //   _VoiceInputWidgetState createState() => _VoiceInputWidgetState();
// // }

// // class _VoiceInputWidgetState extends State<VoiceInputWidget> {
// //   final SpeechRecognitionService _speechService = SpeechRecognitionService();
// //   bool _isListening = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return FloatingActionButton(
// //       onPressed: _toggleListening,
// //       child: Icon(_isListening ? Icons.mic : Icons.mic_none),
// //     );
// //   }

// //   void _toggleListening() async {
// //     if (!_isListening) {
// //       final text = await _speechService.startListening();
// //       widget.onTextRecognized(text);
// //       setState(() => _isListening = true);
// //     } else {
// //       _speechService.stopListening();
// //       setState(() => _isListening = false);
// //     }
// //   }
// // }

// import 'package:aura_techwizard/views/speech_analysis/speech_recognition_service.dart';
// import 'package:flutter/material.dart';

// class VoiceInputWidget extends StatefulWidget {
//   final Function(String) onTextRecognized;

//   const VoiceInputWidget({Key? key, required this.onTextRecognized}) : super(key: key);

//   @override
//   _VoiceInputWidgetState createState() => _VoiceInputWidgetState();
// }

// class _VoiceInputWidgetState extends State<VoiceInputWidget> {
//   final SpeechRecognitionService _speechService = SpeechRecognitionService();
//   bool _isListening = false;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeSpeechRecognition();
//   }

//   Future<void> _initializeSpeechRecognition() async {
//     try {
//       final initialized = await _speechService.initialize();
//       setState(() {
//         _isInitialized = initialized;
//       });
//     } catch (e) {
//       debugPrint('Error initializing speech recognition: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: _isInitialized ? _toggleListening : null,
//       child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//       backgroundColor: _isInitialized ? null : Colors.grey,
//     );
//   }

//   void _toggleListening() async {
//     if (!_isListening) {
//       try {
//         setState(() => _isListening = true);
//         final text = await _speechService.startListening();
//         widget.onTextRecognized(text);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}')),
//         );
//       } finally {
//         setState(() => _isListening = false);
//       }
//     } else {
//       await _speechService.stopListening();
//       setState(() => _isListening = false);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onTextRecognized;

  const VoiceInputWidget({super.key, required this.onTextRecognized});

  @override
  _VoiceInputWidgetState createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  double _confidence = 0.0;
  String _currentWords = '';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognition();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeSpeechRecognition() async {
    try {
      _isInitialized = await _speech.initialize(
        onError: (error) => _handleError(error.errorMsg),
        onStatus: (status) => _handleStatus(status),
        debugLogging: true,
      );
      setState(() {});
    } catch (e) {
      _handleError('Failed to initialize: $e');
    }
  }

  void _handleStatus(String status) {
    debugPrint('Speech recognition status: $status');
    if (status == 'done' && _currentWords.isNotEmpty) {
      widget.onTextRecognized(_currentWords);
    }
  }

  void _handleError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _isListening = false);
  }

  Future<void> _toggleListening() async {
    if (!_isInitialized) {
      _handleError('Speech recognition not initialized');
      return;
    }

    if (_speech.isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _currentWords = '';
      });

      try {
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _currentWords = result.recognizedWords;
              _confidence = result.confidence;
            });
          },
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
          onDevice: true,
          listenFor: const Duration(seconds: 30),
        );
      } catch (e) {
        _handleError('Failed to start listening: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening) ...[
          const SizedBox(height: 20),
          Text(
            _currentWords.isEmpty ? 'Listening...' : _currentWords,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _confidence,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? 1.0 + (_pulseController.value * 0.2) : 1.0,
              child: FloatingActionButton.extended(
                onPressed: _isInitialized ? _toggleListening : null,
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                label: Text(_isListening ? 'Stop' : 'Start'),
                backgroundColor: _isInitialized
                    ? (_isListening
                        ? Colors.red
                        : Theme.of(context).primaryColor)
                    : Colors.grey,
              ),
            );
          },
        ),
      ],
    );
  }
}
