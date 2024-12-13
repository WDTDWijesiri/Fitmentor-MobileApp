import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String? fileName; // To store the selected file's name
  File? _selectedFile; // To store the selected file

  Future<void> pickFile() async {
    try {
      debugPrint("Browse button clicked");

      // Open the file picker to select a single file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Allows any type of file
        allowMultiple: false, // Disable multiple file selection
      );

      if (result != null) {
        // File selected successfully
        setState(() {
          fileName = result.files.single.name; // Get the name of the selected file
          _selectedFile = File(result.files.single.path!); // Store the file path
        });
        debugPrint("File selected: $fileName");
      } else {
        // User canceled the file picker
        debugPrint("File picking cancelled");
      }
    } catch (e) {
      // Catch and print any errors during file picking
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload File"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "Drag & Drop file or Browse",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                pickFile(); // Call the pickFile method
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Browse"),
            ),
            const SizedBox(height: 20),
            Text(
              fileName != null ? "Selected file: $fileName" : "No file selected",
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            if (_selectedFile != null) const SizedBox(height: 5),
            if (_selectedFile != null)
              const Text(
                "File ready for upload",
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FileUploadScreen(),
  ));
}
