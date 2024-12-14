import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  FilePickerResult? result;
  String? _filename;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null) {
        _filename = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
        debugPrint('File name: $_filename');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error picking file: $e");
      setState(() {
        isLoading = false;
      });
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
              onPressed: pickFile, // Set to the pickFile method
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.file_upload, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Browse",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_filename != null)
              Text(
                "Selected file: $_filename",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            if (fileToDisplay != null) const SizedBox(height: 10),
            if (fileToDisplay != null)
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
