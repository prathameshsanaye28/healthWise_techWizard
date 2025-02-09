import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/components/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart' as ModelUser;
import '../../resources/firestore_methods.dart';
import '../../resources/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isAnonymous = false;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add a Photo'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postContent(
      String uid, String username, String profImage, bool isAnonymous) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        isAnonymous,
        uid,
        username,
        profImage,
        file: _file,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar('Posted!', context);
        }
        clearPost();
        Navigator.pop(context);
      } else {
        if (context.mounted) {
          showSnackBar(res, context);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  void clearPost() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelUser.Patient? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create a Post'),
        centerTitle: false,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: isAnonymous,
                onChanged: (bool? value) {
                  setState(() {
                    isAnonymous = value ?? false;
                  });
                },
              ),
              const Text(
                'Do you want to post anonymously?',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          TextButton(
            onPressed: () => postContent(user?.uid ?? '', user?.username ?? '',
                user!.photoUrl ?? '', isAnonymous),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: TextField(
            //     controller: _titleController,
            //     decoration: const InputDecoration(
            //       hintText: "Enter post title...",
            //       border: InputBorder.none,
            //     ),
            //     style: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(height: 20),
            if (_file != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: double.infinity,
                    child: Image.memory(
                      _file!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _file = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(_file == null ? 'Add Photo' : 'Change Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
