// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_sound/flutter_sound.dart';
// // // // import 'package:tflite_flutter/tflite_flutter.dart';
// // // // import 'package:permission_handler/permission_handler.dart';
// // // // import 'dart:io';
// // // // import 'dart:typed_data';


// // // // class AudioSentimentAnalyzer {
// // // //   late Interpreter _interpreter;

// // // //   AudioSentimentAnalyzer() {
// // // //     _loadModel();
// // // //   }

// // // //   // Load the TFLite model
// // // //   Future<void> _loadModel() async {
// // // //     try {
// // // //       _interpreter = await Interpreter.fromAsset('your_model.tflite');
// // // //     } catch (e) {
// // // //       print("Error loading model: $e");
// // // //     }
// // // //   }

// // // //   // Preprocess audio data (dummy preprocessing, adjust for your needs)
// // // //   List<List<double>> preprocessAudio(Uint8List audioBytes) {
// // // //     // Convert audio data to the format needed by your model, e.g., mel-spectrogram, MFCC, etc.
// // // //     List<List<double>> input = List.generate(
// // // //         128, (i) => List.generate(128, (j) => 0.0));  // adjust dimensions
// // // //     return input;
// // // //   }

// // // //   // Run inference
// // // //   List<double> analyze(Uint8List audioBytes) {
// // // //     var input = preprocessAudio(audioBytes);
// // // //     var output = List.filled(10, 0.0).reshape([1, 10]);  // adjust output size

// // // //     _interpreter.run(input, output);
// // // //     return output[0];  // Returns the first set of predictions
// // // //   }

// // // //   // Postprocess the output for human-readable results
// // // //   String getSentiment(List<double> output) {
// // // //     int maxIndex = output.indexWhere((value) => value == output.reduce((a, b) => a > b ? a : b));
// // // //     return _sentimentLabel(maxIndex);
// // // //   }

// // // //   String _sentimentLabel(int index) {
// // // //     const labels = ["Angry", "Happy", "Sad", "Neutral", "Fearful", "Disgusted"];
// // // //     return labels[index];
// // // //   }
// // // // }

// // // // // class AudioRecorder {
// // // // //   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// // // // //   bool isRecording = false;

// // // // //   // Start recording
// // // // //   Future<void> startRecording() async {
// // // // //     await _recorder.openAudioSession();
// // // // //     await _recorder.startRecorder(toFile: 'audio.wav');
// // // // //     isRecording = true;
// // // // //   }

// // // // //   // Stop recording
// // // // //   Future<void> stopRecording() async {
// // // // //     await _recorder.stopRecorder();
// // // // //     isRecording = false;
// // // // //     String recordedFilePath = await _recorder.getRecordFilePath();
// // // // //     print('Recording saved at: $recordedFilePath');
// // // // //   }
// // // // // }

// // // // // class AudioRecorder {
// // // // //   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// // // // //   bool isRecording = false;

// // // // //   // Start recording
// // // // //   Future<void> startRecording() async {
// // // // //     await _recorder.openAudioSession();
// // // // //     await _recorder.startRecorder(toFile: 'audio.wav');  // Specify the file format here (e.g., .wav, .mp3)
// // // // //     isRecording = true;
// // // // //   }

// // // // //   // Stop recording
// // // // //   Future<void> stopRecording() async {
// // // // //     await _recorder.stopRecorder();
// // // // //     isRecording = false;
// // // // //   }

// // // // //   // Get the file path of the recorded audio
// // // // //   Future<String> getRecorderFilePath() async {
// // // // //     return await _recorder.getRecordFilePath();  // Get the path to the recorded file
// // // // //   }
// // // // // }

// // // // // class AudioRecorder {
// // // // //   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// // // // //   bool isRecording = false;

// // // // //   // Initialize the recorder (no need for openAudioSession anymore)
// // // // //   Future<void> initialize() async {
// // // // //     await _recorder.openRecorder();
// // // // //   }

// // // // //   // Start recording
// // // // //   Future<void> startRecording() async {
// // // // //     await _recorder.startRecorder(toFile: 'audio.wav');  // Specify the file format here (e.g., .wav, .mp3)
// // // // //     isRecording = true;
// // // // //   }

// // // // //   // Stop recording
// // // // //   Future<void> stopRecording() async {
// // // // //     await _recorder.stopRecorder();
// // // // //     isRecording = false;
// // // // //   }

// // // // //   // Get the file path of the recorded audio
// // // // //   Future<String> getRecorderFilePath() async {
// // // // //     return await _recorder.getRecordFilePath();  // Get the path to the recorded file
// // // // //   }

// // // // //   // Close the recorder session
// // // // //   Future<void> close() async {
// // // // //     await _recorder.closeRecorder();
// // // // //   }
// // // // // }



// // // // class AudioRecorder {
// // // //   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// // // //   bool isRecording = false;
// // // //   String _filePath = '';

// // // //   // Initialize the recorder
// // // //   Future<void> initialize() async {
// // // //     await _recorder.openRecorder();
// // // //   }

// // // //   // Start recording and specify file path
// // // //   Future<void> startRecording() async {
// // // //     // You can specify the file path here. For example, 'audio.wav' in the app's document directory.
// // // //     _filePath = '/path/to/save/audio.wav'; // Update with an appropriate file path
// // // //     await _recorder.startRecorder(toFile: _filePath);
// // // //     isRecording = true;
// // // //   }

// // // //   // Stop recording
// // // //   Future<void> stopRecording() async {
// // // //     await _recorder.stopRecorder();
// // // //     isRecording = false;
// // // //   }

// // // //   // Get the file path of the recorded audio
// // // //   String getRecorderFilePath() {
// // // //     return _filePath;  // Return the path where the audio is saved
// // // //   }

// // // //   // Close the recorder session
// // // //   Future<void> close() async {
// // // //     await _recorder.closeRecorder();
// // // //   }
// // // // }


// // // // // class SentimentAnalysisPage extends StatefulWidget {
// // // // //   @override
// // // // //   _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
// // // // // }

// // // // // class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
// // // // //   late AudioSentimentAnalyzer _sentimentAnalyzer;
// // // // //   late AudioRecorder _audioRecorder;
// // // // //   String _sentiment = 'Press the button to start analysis';

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _sentimentAnalyzer = AudioSentimentAnalyzer();
// // // // //     _audioRecorder = AudioRecorder();
// // // // //     _requestMicrophonePermission();
// // // // //   }

// // // // //   // Request microphone permission
// // // // //   Future<void> _requestMicrophonePermission() async {
// // // // //     var status = await Permission.microphone.request();
// // // // //     if (status.isDenied) {
// // // // //       print("Microphone permission denied");
// // // // //     } else if (status.isGranted) {
// // // // //       print("Microphone permission granted");
// // // // //     }
// // // // //   }

// // // // //   // Start recording and analyzing the audio
// // // // //   Future<void> _startRecordingAndAnalyze() async {
// // // // //     await _audioRecorder.startRecording();
// // // // //     print('Recording started...');
    
// // // // //     // Wait for a set duration or implement your logic to stop the recording
// // // // //     await Future.delayed(Duration(seconds: 5));

// // // // //     await _audioRecorder.stopRecording();
// // // // //     print('Recording stopped...');
    
// // // // //     String recordedFilePath = await _audioRecorder.getRecordFilePath();
// // // // //     File audioFile = File(recordedFilePath);
// // // // //     Uint8List audioBytes = await audioFile.readAsBytes();
    
// // // // //     // Analyze the recorded audio
// // // // //     List<double> output = _sentimentAnalyzer.analyze(audioBytes);
// // // // //     String sentiment = _sentimentAnalyzer.getSentiment(output);
    
// // // // //     setState(() {
// // // // //       _sentiment = sentiment;
// // // // //     });
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: Text('Audio Sentiment Analysis'),
// // // // //       ),
// // // // //       body: Center(
// // // // //         child: Column(
// // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // //           children: [
// // // // //             Text(
// // // // //               'Sentiment: $_sentiment',
// // // // //               style: TextStyle(fontSize: 24),
// // // // //             ),
// // // // //             SizedBox(height: 20),
// // // // //             ElevatedButton(
// // // // //               onPressed: _startRecordingAndAnalyze,
// // // // //               child: Text('Start Analysis'),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class SentimentAnalysisPage extends StatefulWidget {
// // // // //   @override
// // // // //   _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
// // // // // }

// // // // // class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
// // // // //   late AudioSentimentAnalyzer _sentimentAnalyzer;
// // // // //   late AudioRecorder _audioRecorder;
// // // // //   String _sentiment = 'Press the button to start analysis';

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _sentimentAnalyzer = AudioSentimentAnalyzer();
// // // // //     _audioRecorder = AudioRecorder();
// // // // //     _requestMicrophonePermission();
// // // // //   }

// // // // //   // Request microphone permission
// // // // //   Future<void> _requestMicrophonePermission() async {
// // // // //     var status = await Permission.microphone.request();
// // // // //     if (status.isDenied) {
// // // // //       print("Microphone permission denied");
// // // // //     } else if (status.isGranted) {
// // // // //       print("Microphone permission granted");
// // // // //     }
// // // // //   }

// // // // //   // Start recording and analyzing the audio
// // // // //   Future<void> _startRecordingAndAnalyze() async {
// // // // //     await _audioRecorder.startRecording();
// // // // //     print('Recording started...');
    
// // // // //     // Wait for a set duration or implement your logic to stop the recording
// // // // //     await Future.delayed(Duration(seconds: 5));

// // // // //     await _audioRecorder.stopRecording();
// // // // //     print('Recording stopped...');
    
// // // // //     // Get the file path of the recorded audio
// // // // //     String recordedFilePath = await _audioRecorder.getRecorderFilePath();
// // // // //     File audioFile = File(recordedFilePath);
// // // // //     Uint8List audioBytes = await audioFile.readAsBytes();
    
// // // // //     // Analyze the recorded audio
// // // // //     List<double> output = _sentimentAnalyzer.analyze(audioBytes);
// // // // //     String sentiment = _sentimentAnalyzer.getSentiment(output);
    
// // // // //     setState(() {
// // // // //       _sentiment = sentiment;
// // // // //     });
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: Text('Audio Sentiment Analysis'),
// // // // //       ),
// // // // //       body: Center(
// // // // //         child: Column(
// // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // //           children: [
// // // // //             Text(
// // // // //               'Sentiment: $_sentiment',
// // // // //               style: TextStyle(fontSize: 24),
// // // // //             ),
// // // // //             SizedBox(height: 20),
// // // // //             ElevatedButton(
// // // // //               onPressed: _startRecordingAndAnalyze,
// // // // //               child: Text('Start Analysis'),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // class SentimentAnalysisPage extends StatefulWidget {
// // // //   @override
// // // //   _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
// // // // }

// // // // class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
// // // //   late AudioSentimentAnalyzer _sentimentAnalyzer;
// // // //   late AudioRecorder _audioRecorder;
// // // //   String _sentiment = 'Press the button to start analysis';

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _sentimentAnalyzer = AudioSentimentAnalyzer();
// // // //     _audioRecorder = AudioRecorder();
// // // //     _initializeAudioRecorder();
// // // //     _requestMicrophonePermission();
// // // //   }

// // // //   // Initialize the audio recorder
// // // //   Future<void> _initializeAudioRecorder() async {
// // // //     await _audioRecorder.initialize();
// // // //   }

// // // //   // Request microphone permission
// // // //   Future<void> _requestMicrophonePermission() async {
// // // //     var status = await Permission.microphone.request();
// // // //     if (status.isDenied) {
// // // //       print("Microphone permission denied");
// // // //     } else if (status.isGranted) {
// // // //       print("Microphone permission granted");
// // // //     }
// // // //   }

// // // //   // Start recording and analyzing the audio
// // // //   Future<void> _startRecordingAndAnalyze() async {
// // // //     await _audioRecorder.startRecording();
// // // //     print('Recording started...');
    
// // // //     // Wait for a set duration or implement your logic to stop the recording
// // // //     await Future.delayed(Duration(seconds: 5));

// // // //     await _audioRecorder.stopRecording();
// // // //     print('Recording stopped...');
    
// // // //     // Get the file path of the recorded audio
// // // //     String recordedFilePath = _audioRecorder.getRecorderFilePath();
// // // //     File audioFile = File(recordedFilePath);
// // // //     Uint8List audioBytes = await audioFile.readAsBytes();
    
// // // //     // Analyze the recorded audio
// // // //     List<double> output = _sentimentAnalyzer.analyze(audioBytes);
// // // //     String sentiment = _sentimentAnalyzer.getSentiment(output);
    
// // // //     setState(() {
// // // //       _sentiment = sentiment;
// // // //     });
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _audioRecorder.close();  // Close the recorder when done
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Audio Sentiment Analysis'),
// // // //       ),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             Text(
// // // //               'Sentiment: $_sentiment',
// // // //               style: TextStyle(fontSize: 24),
// // // //             ),
// // // //             SizedBox(height: 20),
// // // //             ElevatedButton(
// // // //               onPressed: _startRecordingAndAnalyze,
// // // //               child: Text('Start Analysis'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }








// // // //////////////////////////////////////////////////////////////////////////////////////////////////////////

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_sound/flutter_sound.dart';
// // // import 'dart:io';
// // // import 'dart:typed_data';
// // // import 'package:tflite_flutter/tflite_flutter.dart';
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:permission_handler/permission_handler.dart';


// // // class SentimentAnalysisPage extends StatefulWidget {
// // //   @override
// // //   _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
// // // }

// // // class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
// // //   late AudioSentimentAnalyzer _sentimentAnalyzer;
// // //   late AudioRecorder _audioRecorder;
// // //   String _sentiment = 'Press the button to start analysis';

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _sentimentAnalyzer = AudioSentimentAnalyzer();
// // //     _audioRecorder = AudioRecorder();
// // //     _initializeAudioRecorder();
// // //     _requestMicrophonePermission();
// // //   }

// // //   // Initialize the audio recorder
// // //   Future<void> _initializeAudioRecorder() async {
// // //     await _audioRecorder.initialize();
// // //   }

// // //   // Request microphone permission
// // //   Future<void> _requestMicrophonePermission() async {
// // //     var status = await Permission.microphone.request();
// // //     if (status.isDenied) {
// // //       print("Microphone permission denied");
// // //     } else if (status.isGranted) {
// // //       print("Microphone permission granted");
// // //     }
// // //   }

// // //   // Start recording and analyzing the audio
// // //   Future<void> _startRecordingAndAnalyze() async {
// // //     // Start recording
// // //     await _audioRecorder.startRecording();
// // //     print('Recording started...');
    
// // //     // Wait for 5 seconds or use your own condition
// // //     await Future.delayed(Duration(seconds: 5));

// // //     // Stop recording
// // //     await _audioRecorder.stopRecording();
// // //     print('Recording stopped...');
    
// // //     // Get the file path of the recorded audio
// // //     String recordedFilePath = _audioRecorder.getRecorderFilePath();
// // //     File audioFile = File(recordedFilePath);
// // //     Uint8List audioBytes = await audioFile.readAsBytes();
    
// // //     // Analyze the recorded audio
// // //     List<double> output = _sentimentAnalyzer.analyze(audioBytes);
// // //     String sentiment = _sentimentAnalyzer.getSentiment(output);
    
// // //     setState(() {
// // //       _sentiment = sentiment;
// // //     });
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _audioRecorder.close();  // Close the recorder when done
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Audio Sentiment Analysis'),
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Text(
// // //               'Sentiment: $_sentiment',
// // //               style: TextStyle(fontSize: 24),
// // //             ),
// // //             SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: _startRecordingAndAnalyze,
// // //               child: Text('Start Analysis'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // Audio Sentiment Analyzer - TensorFlow Lite integration
// // // class AudioSentimentAnalyzer {
// // //   late Interpreter _interpreter;

// // //   AudioSentimentAnalyzer() {
// // //     _loadModel();
// // //   }

// // //   // Load the TFLite model
// // //   Future<void> _loadModel() async {
// // //     try {
// // //       _interpreter = await Interpreter.fromAsset('model.tflite');
// // //     } catch (e) {
// // //       print("Error loading model: $e");
// // //     }
// // //   }

// // //   // Preprocess audio data
// // //   List<List<double>> preprocessAudio(Uint8List audioBytes) {
// // //     // Convert audio data to the format needed by your model, e.g., mel-spectrogram, MFCC, etc.
// // //     // Example: Convert audio bytes to float and reshape if needed.
// // //     List<List<double>> input = List.generate(
// // //         128, (i) => List.generate(128, (j) => 0.0));  // Adjust dimensions

// // //     // Perform any necessary preprocessing here based on your model requirements.
// // //     return input;
// // //   }

// // //   // Run inference
// // //   List<double> analyze(Uint8List audioBytes) {
// // //     var input = preprocessAudio(audioBytes);
// // //     var output = List.filled(10, 0.0).reshape([1, 10]);  // Adjust output size

// // //     _interpreter.run(input, output);
// // //     return output[0];  // Return the first set of predictions
// // //   }

// // //   // Postprocess the output for human-readable results
// // //   String getSentiment(List<double> output) {
// // //     int maxIndex = output.indexWhere((value) => value == output.reduce((a, b) => a > b ? a : b));
// // //     return _sentimentLabel(maxIndex);
// // //   }

// // //   String _sentimentLabel(int index) {
// // //     // Map output index to sentiment label
// // //     const labels = ["Angry", "Happy", "Sad", "Neutral"];  // Example labels
// // //     return labels[index];
// // //   }
// // // }

// // // // Audio Recorder using flutter_sound
// // // class AudioRecorder {
// // //   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
// // //   bool isRecording = false;
// // //   String _filePath = '';

// // //   // Initialize the recorder
// // //   Future<void> initialize() async {
// // //     await _recorder.openRecorder();
// // //   }

// // //   // Start recording and specify file path
// // //   Future<void> startRecording() async {
// // //     final directory = await getApplicationDocumentsDirectory();
// // //     _filePath = '${directory.path}/audio.wav';  // File path in app's document directory
// // //     await _recorder.startRecorder(toFile: _filePath);
// // //     isRecording = true;
// // //   }

// // //   // Stop recording
// // //   Future<void> stopRecording() async {
// // //     await _recorder.stopRecorder();
// // //     isRecording = false;
// // //   }

// // //   // Get the file path of the recorded audio
// // //   String getRecorderFilePath() {
// // //     return _filePath;  // Return the path where the audio is saved
// // //   }

// // //   // Close the recorder session
// // //   Future<void> close() async {
// // //     await _recorder.closeRecorder();
// // //   }
// // // }

// // ////////////////////////////////////////////////////////////////////////////////////////////////////////
// // import 'package:flutter/material.dart';
// // import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// // import 'dart:io';
// // import 'dart:typed_data';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Audio Sentiment Analysis',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: SentimentAnalysisPage(),
// //     );
// //   }
// // }

// // class SentimentAnalysisPage extends StatefulWidget {
// //   @override
// //   _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
// // }

// // class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
// //   late AudioSentimentAnalyzer _sentimentAnalyzer;
// //   FlutterAudioRecorder2? _audioRecorder;
// //   String _sentiment = 'Press the button to start analysis';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _sentimentAnalyzer = AudioSentimentAnalyzer();
// //     _requestMicrophonePermission();
// //   }

// //   // Request microphone permission
// //   Future<void> _requestMicrophonePermission() async {
// //     var status = await Permission.microphone.request();
// //     if (status.isDenied) {
// //       print("Microphone permission denied");
// //     } else if (status.isGranted) {
// //       print("Microphone permission granted");
// //     }
// //   }

// //   // Initialize the audio recorder
// //   Future<void> _initializeAudioRecorder() async {
// //     var hasPermission = await Permission.microphone.isGranted;
// //     if (!hasPermission) {
// //       await Permission.microphone.request();
// //     }

// //     final directory = await getApplicationDocumentsDirectory();
// //     String filePath = '${directory.path}/audio.wav';

// //     _audioRecorder = FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.WAV);
// //     await _audioRecorder!.initialized;
// //   }

// //   // Start recording and analyzing the audio
// //   Future<void> _startRecordingAndAnalyze() async {
// //     await _initializeAudioRecorder();

// //     // Start recording
// //     await _audioRecorder!.start();
// //     print('Recording started...');
    
// //     // Wait for 5 seconds (you can customize this)
// //     await Future.delayed(Duration(seconds: 5));

// //     // Stop recording
// //     await _audioRecorder!.stop();
// //     print('Recording stopped...');
    
// //     // Get the file path of the recorded audio
// //     String recordedFilePath = _audioRecorder!.path!;
// //     File audioFile = File(recordedFilePath);
// //     Uint8List audioBytes = await audioFile.readAsBytes();
    
// //     // Analyze the recorded audio
// //     List<double> output = _sentimentAnalyzer.analyze(audioBytes);
// //     String sentiment = _sentimentAnalyzer.getSentiment(output);
    
// //     setState(() {
// //       _sentiment = sentiment;
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _audioRecorder?.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Audio Sentiment Analysis'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               'Sentiment: $_sentiment',
// //               style: TextStyle(fontSize: 24),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: _startRecordingAndAnalyze,
// //               child: Text('Start Analysis'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Audio Sentiment Analyzer - TensorFlow Lite integration
// // class AudioSentimentAnalyzer {
// //   late Interpreter _interpreter;

// //   AudioSentimentAnalyzer() {
// //     _loadModel();
// //   }

// //   // Load the TFLite model
// //   Future<void> _loadModel() async {
// //     try {
// //       _interpreter = await Interpreter.fromAsset('model.tflite');
// //     } catch (e) {
// //       print("Error loading model: $e");
// //     }
// //   }

// //   // Preprocess audio data
// //   List<List<double>> preprocessAudio(Uint8List audioBytes) {
// //     // Convert audio data to the format needed by your model, e.g., mel-spectrogram, MFCC, etc.
// //     // Example: Convert audio bytes to float and reshape if needed.
// //     List<List<double>> input = List.generate(
// //         128, (i) => List.generate(128, (j) => 0.0));  // Adjust dimensions

// //     // Perform any necessary preprocessing here based on your model requirements.
// //     return input;
// //   }

// //   // Run inference
// //   List<double> analyze(Uint8List audioBytes) {
// //     var input = preprocessAudio(audioBytes);
// //     var output = List.filled(10, 0.0).reshape([1, 10]);  // Adjust output size

// //     _interpreter.run(input, output);
// //     return output[0];  // Return the first set of predictions
// //   }

// //   // Postprocess the output for human-readable results
// //   String getSentiment(List<double> output) {
// //     int maxIndex = output.indexWhere((value) => value == output.reduce((a, b) => a > b ? a : b));
// //     return _sentimentLabel(maxIndex);
// //   }

// //   String _sentimentLabel(int index) {
// //     // Map output index to sentiment label
// //     const labels = ["Angry", "Happy", "Sad", "Neutral"];  // Example labels
// //     return labels[index];
// //   }
// // }

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ///
// ///

// import 'package:flutter/material.dart';
// import 'package:record/record.dart'; // Correct import for 'record'
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Audio Sentiment Analysis',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SentimentAnalysisPage(),
//     );
//   }
// }

// class SentimentAnalysisPage extends StatefulWidget {
//   @override
//   _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
// }

// class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
//   final Record _record = Record(); // Singleton instance
//   late AudioSentimentAnalyzer _sentimentAnalyzer;
//   String _sentiment = 'Press the button to start analysis';
//   bool _isRecording = false;
//   String? _audioFilePath;

//   @override
//   void initState() {
//     super.initState();
//     _sentimentAnalyzer = AudioSentimentAnalyzer();
//     _requestMicrophonePermission();
//   }

//   // Request microphone permission
//   Future<void> _requestMicrophonePermission() async {
//     var status = await Permission.microphone.request();
//     if (status.isDenied) {
//       print("Microphone permission denied");
//     } else if (status.isGranted) {
//       print("Microphone permission granted");
//     }
//   }

//   // Start recording audio
//   Future<void> _startRecording() async {
//     final hasPermission = await Permission.microphone.isGranted;
//     if (!hasPermission) {
//       await Permission.microphone.request();
//     }

//     final appDirectory = await getApplicationDocumentsDirectory();
//     String filePath = '${appDirectory.path}/audio.wav';

//     // Start recording
//     bool isRecording = await _record.start(
//       path: filePath,
//       encoder: AudioEncoder.wav,
//       bitRate: 128000,
//     );

//     setState(() {
//       _isRecording = isRecording;
//       _audioFilePath = filePath;
//     });
//   }

//   // Stop recording and analyze audio
//   Future<void> _stopRecordingAndAnalyze() async {
//     if (!_isRecording) return;

//     // Stop recording
//     await _record.stop();

//     // Analyze the recorded audio
//     if (_audioFilePath != null) {
//       File audioFile = File(_audioFilePath!);
//       Uint8List audioBytes = await audioFile.readAsBytes();
      
//       // Analyze the recorded audio
//       List<double> output = _sentimentAnalyzer.analyze(audioBytes);
//       String sentiment = _sentimentAnalyzer.getSentiment(output);

//       setState(() {
//         _sentiment = sentiment;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // No need for 'dispose' method on Record instance in this package
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Sentiment Analysis'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Sentiment: $_sentiment',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isRecording ? _stopRecordingAndAnalyze : _startRecording,
//               child: Text(_isRecording ? 'Stop and Analyze' : 'Start Recording'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Audio Sentiment Analyzer - TensorFlow Lite integration
// class AudioSentimentAnalyzer {
//   late Interpreter _interpreter;

//   AudioSentimentAnalyzer() {
//     _loadModel();
//   }

//   // Load the TFLite model
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('model.tflite');
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//   }

//   // Preprocess audio data
//   List<List<double>> preprocessAudio(Uint8List audioBytes) {
//     // Convert audio data to the format needed by your model, e.g., mel-spectrogram, MFCC, etc.
//     // Example: Convert audio bytes to float and reshape if needed.
//     List<List<double>> input = List.generate(
//         128, (i) => List.generate(128, (j) => 0.0));  // Adjust dimensions

//     // Perform any necessary preprocessing here based on your model requirements.
//     return input;
//   }

//   // Run inference
//   List<double> analyze(Uint8List audioBytes) {
//     var input = preprocessAudio(audioBytes);
//     var output = List.filled(10, 0.0).reshape([1, 10]);  // Adjust output size

//     _interpreter.run(input, output);
//     return output[0];  // Return the first set of predictions
//   }

//   // Postprocess the output for human-readable results
//   String getSentiment(List<double> output) {
//     int maxIndex = output.indexWhere((value) => value == output.reduce((a, b) => a > b ? a : b));
//     return _sentimentLabel(maxIndex);
//   }

//   String _sentimentLabel(int index) {
//     // Map output index to sentiment label
//     const labels = ["Angry", "Happy", "Sad", "Neutral"];  // Example labels
//     return labels[index];
//   }
// }
