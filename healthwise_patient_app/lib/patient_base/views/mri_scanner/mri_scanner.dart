import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/aura/components/colors.dart';
import 'package:healthwise_patient_app/aura/components/consts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MriScannerScreen extends StatefulWidget {
  const MriScannerScreen({super.key});

  @override
  _MriScannerScreenState createState() => _MriScannerScreenState();
}

class _MriScannerScreenState extends State<MriScannerScreen> {
  final int _selectedIndex = 2;
  File? _image;
  String _summary = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String ngrokKey = '$flask_ip';
      final url = Uri.parse('$ngrokKey/predict');

      var request = http.MultipartRequest('POST', url);
      // Add the image to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        filename: path.basename(_image!.path),
      ));

      var headers = {
        "Content-Type": "multipart/form-data",
      };
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          _summary =
              jsonResponse['detection_result'] ?? 'No analysis available';
        });
      } else {
        throw Exception('Failed to analyze image');
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
        title: Text('Reports'),
        actions: [],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
            child: _image == null
                ? IconButton(
                    icon: Icon(Icons.add_photo_alternate, size: 50),
                    onPressed: _pickImage,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _image!,
                          width: 180,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Image Selected',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        path.basename(_image!.path),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 20),
          Text(
            _image == null ? 'Upload Image Here' : 'Image Ready for Analysis',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
              onPressed: _image != null ? _analyzeImage : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(_image != null ? 'Analyze Image' : 'Proceed'),
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
          Text('Analysis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
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
