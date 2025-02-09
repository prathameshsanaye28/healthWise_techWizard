import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../components/colors.dart';
import 'dart:convert';

class SummarizerScreen extends StatefulWidget {
  @override
  _SummarizerScreenState createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  int _selectedIndex = 2; // Set to 2 for the home icon
  File? _file;
  String _summary = '';
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _analyzePdf() async {
    if (_file == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
          'http://10.21.3.236:8000/analyze_medical_reports');

      var request = http.MultipartRequest('POST', url);
      // Add the file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      _file!.path,
      filename: path.basename(_file!.path),
    ));

    // Add headers
    var headers = {
      "Content-Type": "multipart/form-data",
      // Add other headers if necessary
    };
    request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse the JSON response and extract the "analysis" field
        var jsonResponse = json.decode(response.body);
        setState(() {
          _summary = jsonResponse['analysis'] ?? 'No summary available';
        });
      } else {
        throw Exception('Failed to analyze PDF');
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
        actions: [
          
        ],
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
            child: _file == null
                ? IconButton(
                    icon: Icon(Icons.upload_file, size: 50),
                    onPressed: _pickFile,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_present, size: 50, color: Colors.green),
                      SizedBox(height: 10),
                      Text(
                        'File Uploaded',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        path.basename(_file!.path),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 20),
          Text(
            _file == null ? 'Upload File Here' : 'File Ready for Analysis',
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
              onPressed: _file != null ? _analyzePdf : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(_file != null ? 'Analyze PDF' : 'Proceed'),
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
          Text('Summary',
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
