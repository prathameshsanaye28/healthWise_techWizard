import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/utils.dart';
import 'chat_methods.dart';
import 'message.dart';

class ChatScreen extends StatelessWidget {
  final String userId;
  final String username;
  final TextEditingController _messageController = TextEditingController();
  Uint8List? _imageFile;

  ChatScreen({super.key, 
    required this.userId,
    required this.username,
  });

  void sendMessage(BuildContext context) async {
    if (_messageController.text.trim().isNotEmpty || _imageFile != null) {
      await ChatMethods().sendMessage(
        receiverId: userId,
        message: _messageController.text,
        imageFile: _imageFile,
      );
      _messageController.clear();
      _imageFile = null;
    }
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      _imageFile = image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatMethods().getMessages(currentUserId, userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var messageData = 
                        snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    Message message = Message.fromSnap(messageData);
                    bool isMe = message.senderId == currentUserId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.imageUrl != null)
                                Container(
                                  height: 200,
                                  width: 200,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(message.imageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: selectImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}