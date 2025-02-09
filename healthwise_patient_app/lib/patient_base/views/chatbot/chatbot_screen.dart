import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/components/consts.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<ChatMessage> messages = [];
  final ChatUser user = ChatUser(id: '1', firstName: 'User');
  final ChatUser bot = ChatUser(id: '2', firstName: 'Bot');

  Future<void> sendMessage(ChatMessage message) async {
    setState(() => messages.insert(0, message));

    try {
      final response = await http.post(
        Uri.parse('$flask_ip/ask_medical_chatbot'), // Change this for emulator
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': message.text}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botMessage = ChatMessage(
          text: responseData['response'],
          user: bot,
          createdAt: DateTime.now(),
        );
        setState(() => messages.insert(0, botMessage));
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      final errorMessage = ChatMessage(
        text: 'Error: Unable to connect to the server.',
        user: bot,
        createdAt: DateTime.now(),
      );
      setState(() => messages.insert(0, errorMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Chatbot')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.jpg'), // Add your image here
            fit: BoxFit.cover,
          ),
        ),
        child: DashChat(
          currentUser: user,
          onSend: sendMessage,
          messages: messages,
        ),
      ),
    );
  }
}
